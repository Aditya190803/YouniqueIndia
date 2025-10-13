import 'dotenv/config';
import { bootstrap, ProductService, ProductVariantService, TransactionalConnection, LanguageCode, RequestContextService, ChannelService, AssetService, CollectionService, FacetService, FacetValueService, StockLocationService, StockMovementService } from '@vendure/core';
import path from 'path';
import fs from 'fs';
import { config as vendureConfig } from '../vendure-config';
import { SEED_PRODUCTS } from './2-seed-products-with-local-images.generated';

type CategoryDefinition = {
  name: string;
  slug: string;
};

const BASE_CATEGORY_DEFINITIONS: CategoryDefinition[] = [
  { name: 'Necklace', slug: 'necklace' },
  { name: 'Bracelet', slug: 'bracelet' },
  { name: 'Earring', slug: 'earring' },
  { name: 'Ring', slug: 'ring' },
  { name: 'Anklets', slug: 'anklets' },
  { name: 'Hair Accessories', slug: 'hair-accessories' },
  { name: "Men's jewellery", slug: 'mens-jewellery' },
  { name: 'Gifts', slug: 'gifts' },
];

const DEFAULT_STOCK_ON_HAND = 5;

function slugifyCategory(input: string): string {
  return input
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '');
}

const determineCategories = (): CategoryDefinition[] => {
  const bySlug = new Map<string, CategoryDefinition>();

  const register = (def: CategoryDefinition) => {
    const slug = slugifyCategory(def.slug || def.name);
    if (!slug) return;
    const name = def.name?.trim() || def.slug;
    if (!name) return;
    if (!bySlug.has(slug)) {
      bySlug.set(slug, { name, slug });
    }
  };

  for (const base of BASE_CATEGORY_DEFINITIONS) {
    register(base);
  }

  for (const product of SEED_PRODUCTS) {
    if (!Array.isArray(product.categories)) continue;
    for (const rawCategory of product.categories) {
      if (!rawCategory || typeof rawCategory !== 'string') continue;
      register({ name: rawCategory.trim(), slug: slugifyCategory(rawCategory) });
    }
  }

  return Array.from(bySlug.values());
};

async function ensureCategoryFacetAndCollections(args: {
  adminCtx: any;
  facetService: FacetService;
  facetValueService: FacetValueService;
  collectionService: CollectionService;
  categoryDefinitions: CategoryDefinition[];
}) {
  const { adminCtx, facetService, facetValueService, collectionService, categoryDefinitions } = args;
  const facetCode = 'category';
  const facetTranslations = [{ languageCode: LanguageCode.en, name: 'Category' }];

  let facet = await facetService.findByCode(adminCtx, facetCode, LanguageCode.en);
  if (!facet) {
    facet = await facetService.create(adminCtx, {
      code: facetCode,
      isPrivate: false,
      translations: facetTranslations,
      values: categoryDefinitions.map(category => ({
        code: slugifyCategory(category.slug),
        translations: [{ languageCode: LanguageCode.en, name: category.name }],
      })),
    });
  }

  const facetEntity = await facetService.findOne(adminCtx, (facet as any).id, ['values']);
  if (!facetEntity) {
    throw new Error('Unable to load category facet');
  }

  facetEntity.values = facetEntity.values || [];
  const facetValueIdsBySlug = new Map<string, string>();

  for (const category of categoryDefinitions) {
    const valueCode = slugifyCategory(category.slug);
    let current = facetEntity.values.find((value: any) => value.code === valueCode);
    if (!current) {
      current = await facetValueService.create(adminCtx, facetEntity as any, {
        code: valueCode,
        translations: [{ languageCode: LanguageCode.en, name: category.name }],
      } as any);
      facetEntity.values.push(current as any);
    }
    const valueId = (current as any)?.id;
    if (valueId) {
      facetValueIdsBySlug.set(category.slug, valueId);
    }
  }

  const collectionIdsBySlug = new Map<string, string>();
  for (const category of categoryDefinitions) {
    const collectionSlug = slugifyCategory(category.slug);
    let collection = await collectionService.findOneBySlug(adminCtx, collectionSlug);
    if (!collection) {
      collection = await collectionService.create(adminCtx, {
        parentId: undefined,
        isPrivate: false,
        inheritFilters: false,
        filters: [],
        translations: [{
          languageCode: LanguageCode.en,
          name: category.name,
          slug: collectionSlug,
          description: `${category.name} products`,
        }],
      });
    } else {
      const translation = (collection as any)?.translations?.find((t: any) => t.languageCode === LanguageCode.en);
      if (!translation || translation.name !== category.name) {
        try {
          await collectionService.update(adminCtx, {
            id: (collection as any).id,
            translations: [{
              languageCode: LanguageCode.en,
              name: category.name,
              slug: collectionSlug,
              description: `${category.name} products`,
            }],
          });
        } catch (updateError) {
          console.log('⚠️  Unable to update collection translation (continuing):', (updateError as any)?.message || updateError);
        }
      }
    }
    const collectionId = (collection as any)?.id;
    if (collectionId) {
      collectionIdsBySlug.set(category.slug, collectionId);
    }
  }

  return { facetValueIdsBySlug, collectionIdsBySlug };
}

async function assignVariantsToCollections(args: {
  adminCtx: any;
  tx: TransactionalConnection;
  categories: CategoryDefinition[];
  collectionIdsBySlug: Map<string, string>;
  variantIds: string[];
}) {
  const { adminCtx, tx, categories, collectionIdsBySlug, variantIds } = args;
  if (variantIds.length === 0 || categories.length === 0) {
    return;
  }

  for (const category of categories) {
    const collectionId = collectionIdsBySlug.get(category.slug);
    if (!collectionId) continue;
    try {
      const collectionRepo = tx.getRepository(adminCtx, 'Collection' as any);
      const collection = await collectionRepo.findOne({ where: { id: collectionId } as any, relations: ['productVariants'] } as any);
      const existingIds = new Set((collection?.productVariants || []).map((pv: any) => pv.id));
      const toAdd = variantIds.filter(id => !existingIds.has(id));
      if (toAdd.length === 0) continue;
      await tx.rawConnection
        .createQueryBuilder()
        .relation('Collection', 'productVariants')
        .of(collectionId)
        .add(toAdd);
      console.log(`   🗂️ Assigned ${toAdd.length} variant(s) to ${category.name} collection`);
    } catch (err: any) {
      console.log(`   ⚠️ Failed assigning variants to ${category.name} collection:`, err?.message || err);
    }
  }
}

// Suppress noisy post-import connection termination errors triggered by background jobs after shutdown
process.on('uncaughtException', err => {
  if (/Connection terminated/i.test((err as any)?.message || '')) {
    console.log('ℹ️ Ignored post-shutdown "Connection terminated" error');
    process.exitCode = 0;
  } else if (/trust proxy/i.test((err as any)?.message || '')) {
    console.log('ℹ️ Ignored express trust proxy validation error');
    process.exitCode = 0;
  } else {
    console.error('Uncaught:', err);
    process.exit(1);
  }
});
process.on('unhandledRejection', reason => {
  const msg = (reason as any)?.message || String(reason);
  if (/Connection terminated/i.test(msg)) {
    console.log('ℹ️ Ignored post-shutdown "Connection terminated" rejection');
    process.exitCode = 0;
  } else {
    console.error('Unhandled rejection:', reason);
    process.exit(1);
  }
});

async function run() {
  console.log(`📥 Importing ${SEED_PRODUCTS.length} products from seed...`);
  const app = await bootstrap(vendureConfig);
  const tx = app.get(TransactionalConnection);
  const productService = app.get(ProductService);
  const variantService = app.get(ProductVariantService);
  const assetService = app.get(AssetService);
  const requestContextService = app.get(RequestContextService);
  const channelService = app.get(ChannelService);
  const collectionService = app.get(CollectionService);
  const facetService = app.get(FacetService);
  const facetValueService = app.get(FacetValueService);
  const stockLocationService = app.get(StockLocationService);
  const stockMovementService = app.get(StockMovementService);

  let defaultChannel = await channelService.getDefaultChannel();
  let adminCtx = await requestContextService.create({
    apiType: 'admin',
    channelOrToken: defaultChannel,
    languageCode: LanguageCode.en,
    isAuthorized: true,
  } as any);
  let defaultStockLocationId: string | undefined;

  async function ensureDefaultStockLocation() {
    defaultStockLocationId = undefined;
    try {
      const defaultLocation = await stockLocationService.defaultStockLocation(adminCtx);
      if (defaultLocation?.id) {
        defaultStockLocationId = String(defaultLocation.id);
      }
    } catch (err: any) {
      const message = err?.message || err;
      console.log('⚠️  Unable to load default stock location (will attempt fallback):', message);
    }

    if (!defaultStockLocationId) {
      try {
        const locations = await stockLocationService.findAll(adminCtx, { take: 50 } as any);
        const fallback = locations?.items?.find((loc: any) => {
          const name = (loc?.name || '').toString();
          const code = (loc?.code || '').toString();
          return /stock/i.test(name) || code.toLowerCase() === 'stock';
        });
        if (fallback?.id) {
          defaultStockLocationId = String(fallback.id);
        }
      } catch (listErr: any) {
        console.log('⚠️  Unable to list stock locations (continuing):', listErr?.message || listErr);
      }
    }

    if (!defaultStockLocationId) {
      try {
        const createdLocation = await stockLocationService.create(adminCtx, {
          code: 'stock',
          name: 'Stock',
          description: 'Default stock location for seeded inventory',
        } as any);
        if (createdLocation?.id) {
          defaultStockLocationId = String(createdLocation.id);
          console.log('✅ Created default stock location "Stock" with ID:', defaultStockLocationId);
        }
      } catch (createErr: any) {
        console.log('⚠️  Unable to create default stock location (variants will seed without stock):', createErr?.message || createErr);
      }
    }

    if (defaultStockLocationId) {
      try {
        await stockLocationService.assignStockLocationsToChannel(adminCtx, {
          channelId: (defaultChannel as any).id,
          stockLocationIds: [defaultStockLocationId],
        } as any);
      } catch (assignErr: any) {
        const assignMsg = assignErr?.message || assignErr;
        if (!/already|assigned/i.test(String(assignMsg))) {
          console.log('⚠️  Unable to assign stock location to default channel (continuing):', assignMsg);
        }
      }
    }

    if (!defaultStockLocationId) {
      console.log('⚠️  No default stock location detected. Seeded variants will have 0 stock until configured.');
    }
  }

  const applySeedStock = async (variantId: string, sku: string) => {
    if (!defaultStockLocationId) {
      console.log(`   ⚠️ No stock location available, skipping stock for ${sku}`);
      return false;
    }
    try {
      await stockMovementService.adjustProductVariantStock(adminCtx, variantId, [
        {
          stockLocationId: defaultStockLocationId,
          stockOnHand: DEFAULT_STOCK_ON_HAND,
        } as any,
      ]);
      console.log(`   📦 Stock set to ${DEFAULT_STOCK_ON_HAND} for ${sku} at location "Stock"`);
      return true;
    } catch (stockErr: any) {
      console.log(`   ⚠️ Failed to set stock for ${sku}:`, stockErr?.message || stockErr);
      return false;
    }
  };

  const addVariantIdOnce = (list: string[], id: string) => {
    if (!list.includes(id)) {
      list.push(id);
    }
  };

  // Ensure default tax setup exists to avoid "no active tax zone" errors
  async function ensureDefaultTaxSetup() {
    await tx.withTransaction(async ctx => {
      const zoneRepo = tx.getRepository(ctx, 'Zone' as any);
      const countryRepo = tx.getRepository(ctx, 'Country' as any);
      const channelRepo = tx.getRepository(ctx, 'Channel' as any);
      const taxCategoryRepo = tx.getRepository(ctx, 'TaxCategory' as any);
      const taxRateRepo = tx.getRepository(ctx, 'TaxRate' as any);

      // 1) Ensure a Zone exists with at least one Country (prefer IN). If none, create empty zone anyway.
      let zone = await zoneRepo.findOne({ where: { name: 'Default Tax Zone' } as any, relations: ['members'] });
      if (!zone) {
        let country = await countryRepo.findOne({ where: { code: 'IN', enabled: true } as any });
        if (!country) {
          // fallback to any enabled country
          country = await countryRepo.findOne({ where: { enabled: true } as any });
        }
        if (country) {
          zone = await zoneRepo.save({ name: 'Default Tax Zone', members: [country] } as any);
        } else {
          // create zone without members; still usable as default zone
          zone = await zoneRepo.save({ name: 'Default Tax Zone' } as any);
        }
      }

      // 2) Assign Channel.defaultTaxZone if missing
      if (zone) {
        const ch = await channelRepo.findOne({ where: { id: (defaultChannel as any).id } as any, relations: ['defaultTaxZone','defaultShippingZone'] });
        const needsTax = !ch?.defaultTaxZone || (ch.defaultTaxZone as any).id !== (zone as any).id;
        const needsShip = !ch?.defaultShippingZone || (ch.defaultShippingZone as any).id !== (zone as any).id;
        if (needsTax || needsShip) {
          try {
            if (typeof (channelService as any).update === 'function') {
              await (channelService as any).update(adminCtx as any, { id: (defaultChannel as any).id, defaultTaxZoneId: (zone as any).id, defaultShippingZoneId: (zone as any).id } as any);
            } else {
              // best-effort direct repo update
              await channelRepo.update({ id: (defaultChannel as any).id } as any, { defaultTaxZone: zone, defaultShippingZone: zone } as any);
            }
          } catch {
            // ignore failures, variant creation will still try proceed
          }
        }
      }

      // 3) Ensure a default TaxCategory exists
      let defaultTaxCat = await taxCategoryRepo.findOne({ where: { isDefault: true } as any });
      if (!defaultTaxCat) {
        defaultTaxCat = await taxCategoryRepo.save({ name: 'Standard', isDefault: true } as any);
      }

      // 4) Ensure a TaxRate exists for (zone, category); use 0% to avoid price changes
      if (zone && defaultTaxCat) {
        const existingRate = await taxRateRepo.findOne({ where: { category: { id: (defaultTaxCat as any).id }, zone: { id: (zone as any).id } } as any, relations: ['category', 'zone'] });
        if (!existingRate) {
          try {
            await taxRateRepo.save({ name: 'Standard 0%', enabled: true, value: 0, category: defaultTaxCat, zone } as any);
          } catch {
            // ignore if shape mismatch
          }
        }
      }
    });
  }

  await ensureDefaultTaxSetup();
  // refresh channel and admin context to ensure updated zones are active in ctx
  defaultChannel = await channelService.getDefaultChannel();
  adminCtx = await requestContextService.create({
    apiType: 'admin',
    channelOrToken: defaultChannel,
    languageCode: LanguageCode.en,
    isAuthorized: true,
  } as any);
  await ensureDefaultStockLocation();
  
  if (defaultStockLocationId) {
    console.log(`📦 Using stock location "Stock" (ID: ${defaultStockLocationId}) with ${DEFAULT_STOCK_ON_HAND} units per variant`);
  } else {
    console.log('⚠️  No stock location available - products will be imported without stock');
  }

  // Basic preflight checks: DB connectivity, default channel and default tax zone
  async function preflightCheck() {
    try {
      await tx.withTransaction(async ctx => {
        // check DB reachable by counting products (fast)
        const productRepo = tx.getRepository(ctx, 'Product' as any);
        await productRepo.count();

        const channelRepo = tx.getRepository(ctx, 'Channel' as any);
        const ch = await channelRepo.findOne({ where: { id: (defaultChannel as any).id } as any, relations: ['defaultTaxZone'] });
        if (!ch) throw new Error('Default channel not found');
        if (!ch.defaultTaxZone) {
          console.log('⚠️ Default channel has no defaultTaxZone assigned — attempting to ensure default tax setup now');
          // attempt to repair
          await ensureDefaultTaxSetup();
        }
      });

      // re-check after attempted repair
      const refreshed = await tx.withTransaction(async ctx => {
        const channelRepo = tx.getRepository(ctx, 'Channel' as any);
        return await channelRepo.findOne({ where: { id: (defaultChannel as any).id } as any, relations: ['defaultTaxZone'] });
      });
      if (!refreshed || !refreshed.defaultTaxZone) {
        console.error('❌ Preflight failed: default tax zone still not configured for default channel.');
        return false;
      }
      console.log('✅ Preflight checks passed');
      return true;
    } catch (e:any) {
      console.error('❌ Preflight DB check failed:', e?.message || e);
      return false;
    }
  }

  const preflightOk = await preflightCheck();
  if (!preflightOk) {
    console.error('Aborting import due to failed preflight checks. Please ensure the database and channel configuration are correct, or run `npm run setup` to initialize.');
    try { await app.close(); } catch {};
    process.exit(1);
  }

  const categoryDefinitions = determineCategories();
  const { facetValueIdsBySlug, collectionIdsBySlug } = await ensureCategoryFacetAndCollections({
    adminCtx,
    facetService,
    facetValueService,
    collectionService,
    categoryDefinitions,
  });

  // Load default tax category id for assignment
  let taxCategoryId: string | undefined;
  await tx.withTransaction(async ctx => {
    const taxRepo = tx.getRepository(ctx, 'TaxCategory' as any);
    let taxCat = await taxRepo.findOne({ where: { isDefault: true } as any });
    if (!taxCat) {
      taxCat = await taxRepo.save({ name: 'Standard', isDefault: true } as any);
    }
    taxCategoryId = (taxCat as any)?.id;
  });
  console.log('🔧 Using tax category id:', taxCategoryId);

  let created = 0;
  let updated = 0;
  let variantCreated = 0;
  let variantUpdated = 0;
  let stockApplied = 0;
  for (const seed of SEED_PRODUCTS) {
    const baseSlug = (seed.slug || seed.name || 'product')
      .toLowerCase()
      .replace(/[^a-z0-9-]+/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '');
    const slug = baseSlug || `product-${Date.now()}`;
    // Get the specific categories for this product from the seed data
    const productCategories = (seed.categories || []).map((catName: string) => {
      const categoryDef = categoryDefinitions.find(cat => 
        cat.name === catName || cat.slug === catName.toLowerCase().replace(/\s+/g, '-')
      );
      return categoryDef || { name: catName, slug: catName.toLowerCase().replace(/\s+/g, '-') };
    });
    
    const facetValueIds = productCategories
      .map(category => facetValueIdsBySlug.get(category.slug))
      .filter((id): id is string => Boolean(id));
    try {
      const existing = await productService.findOneBySlug(adminCtx, slug);
      let productId: string;
      const variantIdsForProduct: string[] = [];
      if (!existing) {
        const variantsInput = (seed.variants && seed.variants.length > 0 ? seed.variants : [{ sku: `${slug}-SKU`, price: 0 }]).map(v => ({
          sku: (v as any).sku || `${slug}-SKU`,
          price: Number.isFinite((v as any).price) ? (v as any).price : 0,
          translations: [{ languageCode: LanguageCode.en, name: seed.name || slug }],
        }));
  const res = await productService.create(adminCtx, {
          translations: [{
            languageCode: LanguageCode.en,
            name: seed.name || slug,
            description: seed.description || '',
            slug,
          }],
          facetValueIds,
        });
        if (!res) {
          throw new Error('Create returned no result');
        }
        const createdEntity = await productService.findOneBySlug(adminCtx, slug) as any;
        productId = createdEntity?.id;
        if (!productId) throw new Error('Product id not retrievable after create');
        created++;
        console.log(`✅ Created ${slug}`);
        // Attach local assets if any (after product creation). We expect download-seed-assets to have rewritten assetIds to relative paths under static/assets/seed
  await attachLocalAssets({ adminCtx, assetService, productService, productId, seed });

        // Now create variants separately
        for (const v of variantsInput) {
          const createInput = {
            productId,
            sku: v.sku,
            price: v.price,
            translations: v.translations,
            trackInventory: 'TRUE' as any,
            facetValueIds,
          };
          let createdVariantId: string | undefined;
          try {
            const createdVariants = await variantService.create(adminCtx, [createInput]);
            const createdVariant = Array.isArray(createdVariants) ? createdVariants[0] : undefined;
            if (createdVariant?.id) {
              createdVariantId = String(createdVariant.id);
              addVariantIdOnce(variantIdsForProduct, createdVariantId);
            }
            variantCreated++;
            console.log(`   ➕ Variant created ${v.sku}`);
          } catch (ve: any) {
            if (/no[-\s]*active[-\s]*tax[-\s]*zone/i.test(ve?.message || '')) {
              console.log(`   ⚠️ No active tax zone for variant ${v.sku} — attempting to ensure default tax setup and retrying...`);
              try {
                await ensureDefaultTaxSetup();
                // refresh channel and admin context
                defaultChannel = await channelService.getDefaultChannel();
                adminCtx = await requestContextService.create({
                  apiType: 'admin',
                  channelOrToken: defaultChannel,
                  languageCode: LanguageCode.en,
                  isAuthorized: true,
                } as any);
                await ensureDefaultStockLocation();
                const createdVariants = await variantService.create(adminCtx, [createInput]);
                const createdVariant = Array.isArray(createdVariants) ? createdVariants[0] : undefined;
                if (createdVariant?.id) {
                  createdVariantId = String(createdVariant.id);
                  addVariantIdOnce(variantIdsForProduct, createdVariantId);
                }
                variantCreated++;
                console.log(`   ➕ Variant created on retry ${v.sku}`);
              } catch (retryErr: any) {
                console.log(`   ⚠️ Retry failed for variant ${v.sku}:`, (retryErr?.message || retryErr));
                console.log(`   ⚠️ Ignored tax zone error for variant ${v.sku}`);
              }
            } else {
              throw ve;
            }
          }
          if (createdVariantId) {
            const stockSuccess = await applySeedStock(createdVariantId, v.sku);
            if (stockSuccess) stockApplied++;
          }
        }
        await assignVariantsToCollections({ adminCtx, tx, categories: productCategories, collectionIdsBySlug, variantIds: variantIdsForProduct });
      } else {
        productId = (existing as any).id;
        // Update translations (slug fixed) – ignore errors silently
        try {
          await productService.update(adminCtx, {
            id: productId,
            translations: [{
              languageCode: LanguageCode.en,
              name: seed.name || slug,
              description: seed.description || '',
              slug,
            }],
            facetValueIds,
          });
          updated++;
          console.log(`🔁 Updated ${slug}`);
        } catch (e) {
          console.log(`⚠️ Update skipped for ${slug}:`, (e as any)?.message);
        }

  // Ensure assets present for existing product too (in case first run failed or seed updated)
  await attachLocalAssets({ adminCtx, assetService, productService, productId, seed, existing });

  // Upsert variants (reuse adminCtx so channel & currency populate properly)
        const seedVariants = (seed.variants && seed.variants.length > 0) ? seed.variants : [{ sku: `${slug}-SKU`, price: 0 }];
        const variantRepo = tx.getRepository(adminCtx, 'ProductVariant' as any);
        for (const v of seedVariants) {
          const sku = (v as any).sku || `${slug}-SKU`;
          const existingVariant: any = await variantRepo.findOne({ where: { sku } as any });
          const price = Number.isFinite((v as any).price) ? (v as any).price : existingVariant?.price ?? 0;
          if (existingVariant) {
            const variantId = String(existingVariant.id);
            const updateInput = {
              id: existingVariant.id,
              sku,
              price,
              translations: [{ languageCode: LanguageCode.en, name: seed.name || slug }],
              trackInventory: 'TRUE' as any,
              facetValueIds,
            };
            let variantSynced = false;
            try {
              await variantService.update(adminCtx, [updateInput]);
              variantSynced = true;
              variantUpdated++;
              addVariantIdOnce(variantIdsForProduct, variantId);
              console.log(`   ↻ Variant synced ${sku}`);
            } catch (ve: any) {
              if (/no[-\s]*active[-\s]*tax[-\s]*zone/i.test(ve?.message || '')) {
                console.log(`   ⚠️ No active tax zone for variant ${sku} — attempting to ensure default tax setup and retrying update...`);
                try {
                  await ensureDefaultTaxSetup();
                  defaultChannel = await channelService.getDefaultChannel();
                  adminCtx = await requestContextService.create({
                    apiType: 'admin',
                    channelOrToken: defaultChannel,
                    languageCode: LanguageCode.en,
                    isAuthorized: true,
                  } as any);
                  await ensureDefaultStockLocation();
                  await variantService.update(adminCtx, [updateInput]);
                  variantSynced = true;
                  variantUpdated++;
                  addVariantIdOnce(variantIdsForProduct, variantId);
                  console.log(`   ↻ Variant synced on retry ${sku}`);
                } catch (retryErr: any) {
                  console.log(`   ⚠️ Retry failed for variant ${sku}:`, (retryErr?.message || retryErr));
                  console.log(`   ⚠️ Ignored tax zone error for variant ${sku}`);
                }
              } else {
                throw ve;
              }
            }
            if (variantSynced) {
              const stockSuccess = await applySeedStock(variantId, sku);
              if (stockSuccess) stockApplied++;
            }
          } else {
            const createInput = {
              productId,
              sku,
              price,
              translations: [{ languageCode: LanguageCode.en, name: seed.name || slug }],
              trackInventory: 'TRUE' as any,
              facetValueIds,
            };
            try {
              const createdVariants = await variantService.create(adminCtx, [createInput]);
              const createdVariant = Array.isArray(createdVariants) ? createdVariants[0] : undefined;
              if (createdVariant?.id) {
                const variantId = String(createdVariant.id);
                addVariantIdOnce(variantIdsForProduct, variantId);
                const stockSuccess = await applySeedStock(variantId, sku);
                if (stockSuccess) stockApplied++;
              }
              variantCreated++;
              console.log(`   ➕ Variant created ${sku}`);
            } catch (ve: any) {
              if (/no[-\s]*active[-\s]*tax[-\s]*zone/i.test(ve?.message || '')) {
                console.log(`   ⚠️ No active tax zone for variant ${sku} — attempting to ensure default tax setup and retrying...`);
                try {
                  await ensureDefaultTaxSetup();
                  defaultChannel = await channelService.getDefaultChannel();
                  adminCtx = await requestContextService.create({
                    apiType: 'admin',
                    channelOrToken: defaultChannel,
                    languageCode: LanguageCode.en,
                    isAuthorized: true,
                  } as any);
                  await ensureDefaultStockLocation();
                  const createdVariants = await variantService.create(adminCtx, [createInput]);
                  const createdVariant = Array.isArray(createdVariants) ? createdVariants[0] : undefined;
                  if (createdVariant?.id) {
                    const variantId = String(createdVariant.id);
                    addVariantIdOnce(variantIdsForProduct, variantId);
                    const stockSuccess = await applySeedStock(variantId, sku);
                    if (stockSuccess) stockApplied++;
                  }
                  variantCreated++;
                  console.log(`   ➕ Variant created on retry ${sku}`);
                } catch (retryErr: any) {
                  console.log(`   ⚠️ Retry failed for variant ${sku}:`, (retryErr?.message || retryErr));
                  console.log(`   ⚠️ Ignored tax zone error for variant ${sku}`);
                }
              } else {
                throw ve;
              }
            }
          }
        }
        await assignVariantsToCollections({ adminCtx, tx, categories: productCategories, collectionIdsBySlug, variantIds: variantIdsForProduct });
      }
    } catch (err: any) {
      console.error('❌ Failed', slug, '-', err?.message || err);
    }
  }
  console.log(`🎉 Done. Products created: ${created}, updated: ${updated}. Variants created: ${variantCreated}, updated: ${variantUpdated}. Stock applied to ${stockApplied} variants. Total products in seed: ${SEED_PRODUCTS.length}`);
  try {
    await app.close();
  } catch (e:any) {
    if (!/Connection terminated/i.test(e?.message || '')) {
      console.error('Shutdown error:', e?.message || e);
      process.exitCode = 1;
    }
  }
}

function detectMime(filename: string): string {
  const ext = path.extname(filename).toLowerCase();
  switch (ext) {
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.png':
      return 'image/png';
    case '.webp':
      return 'image/webp';
    default:
      return 'application/octet-stream';
  }
}

async function attachLocalAssets(args: { adminCtx: any; assetService: AssetService; productService: ProductService; productId: string; seed: any; existing?: any }) {
  const { adminCtx, assetService, productService, productId, seed, existing } = args;
  const desiredRelPaths: string[] = Array.isArray(seed.assetIds) ? seed.assetIds.filter((a: string) => !/^https?:/i.test(a)) : [];
  if (desiredRelPaths.length === 0) return;

  // If product already has assets and counts match, skip
  let current: any = existing;
  if (!current) {
    current = await productService.findOne(adminCtx as any, productId) as any;
  }
  const existingAssetNames = (current?.assets || []).map((a: any) => a.source?.split('/').pop()).filter(Boolean);
  const toUpload = desiredRelPaths.filter(rel => {
    const base = path.basename(rel);
    return !existingAssetNames.includes(base);
  });
  if (toUpload.length === 0) return;

  const createdAssetIds: string[] = [];
  for (const rel of toUpload) {
    try {
      const abs = path.join(__dirname, '../../static/assets', rel.replace(/^\/+/, ''));
      if (!fs.existsSync(abs)) {
        console.log('   ⚠️ Local asset not found, skipping', rel);
        continue;
      }
      // Flatten path for remote storage: Vendure/Cloudinary pipeline seems to strip subfolders when reading back
      // which caused 404s (e.g. uploaded under seed/ but later fetched without seed/). Use base filename only.
      const filename = path.basename(abs); // e.g. baby-bow-necklace-1.jpg
      if (rel.includes('/') && !rel.startsWith('seed/')) {
        console.log('   ℹ️ Normalizing asset path', rel, '->', filename);
      }
      const mimeType = detectMime(filename);
      console.log('   ⬆️ Uploading asset', rel);
      let assetResult: any;
      if (typeof (assetService as any).create === 'function') {
        assetResult = await (assetService as any).create(adminCtx, {
          file: {
            createReadStream: () => fs.createReadStream(abs),
            filename, // provide flattened filename so identifier matches subsequent reads
            mimetype: mimeType,
          },
        });
      } else if (typeof (assetService as any).createFromFileStream === 'function') {
        // As a last resort try createFromFileStream using safest assumed signature
        const stream = fs.createReadStream(abs);
        try {
          assetResult = await (assetService as any).createFromFileStream(adminCtx, stream, filename, mimeType, {});
        } catch (sigErr: any) {
          console.log('   ⚠️ createFromFileStream failed, skipping method for this asset:', sigErr?.message || sigErr);
          continue;
        }
      } else {
        console.log('   ⚠️ No usable asset creation method found');
        continue;
      }
      if (assetResult?.id) createdAssetIds.push(assetResult.id);
    } catch (ae: any) {
      console.log('   ⚠️ Asset upload failed (continuing):', ae?.message || ae);
    }
  }
  if (createdAssetIds.length) {
    try {
      await productService.update(adminCtx as any, {
        id: productId,
        // @ts-ignore
        assetIds: [...(current?.assets?.map((a: any) => a.id) || []), ...createdAssetIds],
        // @ts-ignore
        featuredAssetId: (current?.featuredAsset?.id) || createdAssetIds[0],
      } as any);
      console.log(`   🖼️ Attached ${createdAssetIds.length} new asset(s)`);
    } catch (ue: any) {
      console.log('   ⚠️ Failed attaching assets:', ue?.message || ue);
    }
  }
}

if (require.main === module) {
  run().catch(e => { console.error(e); process.exit(1); });
}
