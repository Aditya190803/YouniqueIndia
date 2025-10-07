import 'dotenv/config';
import { bootstrap, ProductService, ProductVariantService, TransactionalConnection, LanguageCode, RequestContextService, ChannelService, AssetService } from '@vendure/core';
import path from 'path';
import fs from 'fs';
import { config as vendureConfig } from '../vendure-config';
import { SEED_PRODUCTS } from './2-seed-products.generated';

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

  let defaultChannel = await channelService.getDefaultChannel();
  let adminCtx = await requestContextService.create({
    apiType: 'admin',
    channelOrToken: defaultChannel,
    languageCode: LanguageCode.en,
    isAuthorized: true,
  } as any);

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
  for (const seed of SEED_PRODUCTS) {
    const baseSlug = (seed.slug || seed.name || 'product')
      .toLowerCase()
      .replace(/[^a-z0-9-]+/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '');
    const slug = baseSlug || `product-${Date.now()}`;
    try {
      const existing = await productService.findOneBySlug(adminCtx, slug);
      let productId: string;
      if (!existing) {
        const variantsInput = (seed.variants && seed.variants.length > 0 ? seed.variants : [{ sku: `${slug}-SKU`, price: 0 }]).map(v => ({
          sku: (v as any).sku || `${slug}-SKU`,
          price: Number.isFinite((v as any).price) ? (v as any).price : 0,
          translations: [{ languageCode: LanguageCode.en, name: seed.name || slug }],
        }));
  const res: any = await productService.create(adminCtx as any, {
          translations: [{
            languageCode: LanguageCode.en,
            name: seed.name || slug,
            description: seed.description || '',
            slug,
          }],
          // @ts-ignore
          taxCategoryId,
        });
        if (res && res.__typename && res.__typename !== 'Product') {
          throw new Error('Create returned error result');
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
          try {
            await variantService.create(adminCtx as any, [{
              productId,
              sku: v.sku,
              price: v.price,
              translations: v.translations,
            }] as any);
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
                await variantService.create(adminCtx as any, [{
                  productId,
                  sku: v.sku,
                  price: v.price,
                  translations: v.translations,
                }] as any);
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
        }
      } else {
        productId = (existing as any).id;
        // Update translations (slug fixed) – ignore errors silently
        try {
          await productService.update(adminCtx as any, {
            id: productId,
            translations: [{
              languageCode: LanguageCode.en,
              name: seed.name || slug,
              description: seed.description || '',
              slug,
            }],
            // @ts-ignore
            taxCategoryId,
          } as any);
          updated++;
          console.log(`🔁 Updated ${slug}`);
        } catch (e) {
          console.log(`⚠️ Update skipped for ${slug}:`, (e as any)?.message);
        }

  // Ensure assets present for existing product too (in case first run failed or seed updated)
  await attachLocalAssets({ adminCtx, assetService, productService, productId, seed, existing });

  // Upsert variants (reuse adminCtx so channel & currency populate properly)
        const seedVariants = (seed.variants && seed.variants.length > 0) ? seed.variants : [{ sku: `${slug}-SKU`, price: 0 }];
        for (const v of seedVariants) {
          const sku = (v as any).sku || `${slug}-SKU`;
          const variantRepo = tx.getRepository(adminCtx, 'ProductVariant' as any);
          const existingVariant: any = await variantRepo.findOne({ where: { sku } as any });
          try {
            if (existingVariant) {
              const newPrice = Number.isFinite((v as any).price) ? (v as any).price : existingVariant.price;
              if (newPrice !== existingVariant.price) {
                await variantService.update(adminCtx as any, [{
                  id: existingVariant.id,
                  sku,
                  price: newPrice,
                  translations: [{ languageCode: LanguageCode.en, name: seed.name || slug }],
                }] as any);
                variantUpdated++;
                console.log(`   ↻ Variant price updated ${sku}`);
              }
            } else {
              await variantService.create(adminCtx as any, [{
                productId,
                sku,
                price: Number.isFinite((v as any).price) ? (v as any).price : 0,
                translations: [{ languageCode: LanguageCode.en, name: seed.name || slug }],
              }] as any);
              variantCreated++;
              console.log(`   ➕ Variant created ${sku}`);
            }
          } catch (ve: any) {
            if (/no[-\s]*active[-\s]*tax[-\s]*zone/i.test(ve?.message || '')) {
              console.log(`   ⚠️ No active tax zone for variant ${sku} — attempting to ensure default tax setup and retrying...`);
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
                await variantService.create(adminCtx as any, [{
                  productId,
                  sku,
                  price: Number.isFinite((v as any).price) ? (v as any).price : 0,
                  translations: [{ languageCode: LanguageCode.en, name: seed.name || slug }],
                }] as any);
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
    } catch (err: any) {
      console.error('❌ Failed', slug, '-', err?.message || err);
    }
  }
  console.log(`🎉 Done. Products created: ${created}, updated: ${updated}. Variants created: ${variantCreated}, updated: ${variantUpdated}. Total products in seed: ${SEED_PRODUCTS.length}`);
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
