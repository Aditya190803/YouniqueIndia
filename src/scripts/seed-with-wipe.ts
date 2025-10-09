import 'dotenv/config';
import { bootstrap, ProductService, ProductVariantService, TransactionalConnection, LanguageCode, RequestContextService, ChannelService, AssetService } from '@vendure/core';
import path from 'path';
import fs from 'fs';
import { config as vendureConfig } from '../vendure-config';
import { SEED_PRODUCTS } from './2-seed-products-with-local-images.generated';
import AppDataSource from '../data-source';

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

async function wipeDatabase() {
  console.log('⚠️  WIPING DATABASE SCHEMA – ALL DATA WILL BE LOST');
  const schema = process.env.DB_SCHEMA || 'public';
  const ds = AppDataSource;
  await ds.initialize();
  const qr = ds.createQueryRunner();
  try {
    await qr.query(`DROP SCHEMA IF EXISTS "${schema}" CASCADE;`);
    await qr.query(`CREATE SCHEMA "${schema}";`);
    console.log('✅ Database schema wiped and recreated');
  } catch (e: any) {
    console.error('❌ Failed wiping schema:', e.message || e);
    throw e;
  } finally {
    await qr.release();
    await ds.destroy();
  }
}

async function setupVendure() {
  console.log('🛠️ Setting up Vendure initial configuration...');
  
  // Use child process to run the setup script
  const { spawn } = await import('child_process');
  
  return new Promise<void>((resolve, reject) => {
    const setupProcess = spawn('npm', ['run', 'setup'], {
      stdio: 'inherit',
      cwd: process.cwd()
    });

    setupProcess.on('close', (code) => {
      if (code === 0) {
        console.log('✅ Vendure setup complete');
        resolve();
      } else {
        reject(new Error(`Setup process exited with code ${code}`));
      }
    });

    setupProcess.on('error', (error) => {
      reject(error);
    });
  });
}

async function importSeedProducts() {
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
  await ensureDefaultTaxSetup(tx, adminCtx);

  // FORCE DELETE ALL EXISTING PRODUCTS
  console.log('🗑️  Force deleting all existing products...');
  const allProducts = await productService.findAll(adminCtx, { take: 1000 });
  for (const product of allProducts.items) {
    try {
      await productService.softDelete(adminCtx, product.id);
      console.log(`🗑️  Deleted existing product: ${product.name}`);
    } catch (err: any) {
      console.warn(`⚠️  Failed to delete product ${product.name}:`, err.message);
    }
  }

  let imported = 0;
  let skipped = 0;
  
  for (const seedProduct of SEED_PRODUCTS) {
    try {
      // Handle assets FIRST
      const assetIds: string[] = [];
      if (seedProduct.assetIds && seedProduct.assetIds.length > 0) {
        console.log(`🖼️  Processing ${seedProduct.assetIds.length} assets for: ${seedProduct.name}`);
        for (const assetPath of seedProduct.assetIds) {
          try {
            const asset = await attachLocalAsset(assetPath, assetService, adminCtx);
            if (asset && 'id' in asset) {
              assetIds.push(String(asset.id));
              console.log(`✅ Asset attached: ${assetPath}`);
            } else {
              console.warn(`⚠️  Asset creation failed for: ${assetPath}`);
            }
          } catch (err: any) {
            console.warn(`⚠️  Failed to attach asset ${assetPath}:`, err.message);
          }
        }
      }

      // Create product with assets
      const product = await productService.create(adminCtx, {
        translations: [{
          languageCode: LanguageCode.en,
          name: seedProduct.name,
          slug: seedProduct.slug,
          description: seedProduct.description || '',
        }],
        assetIds,
        featuredAssetId: assetIds.length > 0 ? assetIds[0] : undefined,
      });

      // Create variants
      for (const seedVariant of seedProduct.variants) {
        await variantService.create(adminCtx, [{
          productId: product.id,
          sku: seedVariant.sku,
          price: seedVariant.price,
          translations: [{
            languageCode: LanguageCode.en,
            name: `${seedProduct.name}`,
          }],
        }]);
      }

      const imageStatus = assetIds.length > 0 ? `✅ with ${assetIds.length} image(s)` : '⚠️  without images';
      console.log(`✅ Imported: ${seedProduct.name} ${imageStatus}`);
      imported++;
    } catch (err: any) {
      console.error(`❌ Failed to import ${seedProduct.name}:`, err.message || err);
    }
  }

  console.log(`\n🎉 Import complete!`);
  console.log(`   Products imported: ${imported}`);
  console.log(`   Products skipped: ${skipped}`);
  console.log(`   Total products: ${SEED_PRODUCTS.length}`);

  await app.close();
}

async function attachLocalAsset(assetPath: string, assetService: AssetService, ctx: any) {
  if (!assetPath.startsWith('seed/')) {
    return null;
  }

  const filename = assetPath.replace('seed/', '');
  const fullPath = path.join(__dirname, '../../static/assets/seed', filename);
  
  if (!fs.existsSync(fullPath)) {
    console.warn(`⚠️  Asset file not found: ${fullPath}`);
    return null;
  }

  const mimeType = getMimeType(filename);
  
  try {
    // Use the same method as the existing import script
    let assetResult: any;
    if (typeof (assetService as any).create === 'function') {
      assetResult = await (assetService as any).create(ctx, {
        file: {
          createReadStream: () => fs.createReadStream(fullPath),
          filename,
          mimetype: mimeType,
        },
      });
    } else if (typeof (assetService as any).createFromFileStream === 'function') {
      const stream = fs.createReadStream(fullPath);
      assetResult = await (assetService as any).createFromFileStream(ctx, stream, filename, mimeType, {});
    } else {
      console.warn('⚠️  No usable asset creation method found');
      return null;
    }
    
    return assetResult;
  } catch (err: any) {
    console.warn(`⚠️  Failed to create asset ${filename}:`, err.message);
    return null;
  }
}

function getMimeType(filename: string): string {
  const ext = path.extname(filename).toLowerCase();
  switch (ext) {
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.png':
      return 'image/png';
    case '.gif':
      return 'image/gif';
    case '.webp':
      return 'image/webp';
    default:
      return 'application/octet-stream';
  }
}

async function ensureDefaultTaxSetup(tx: TransactionalConnection, ctx: any) {
  try {
    // Check if we have any tax zones
    const zones = await tx.rawConnection.query('SELECT COUNT(*) as count FROM zone');
    if (zones[0]?.count > 0) {
      return; // Already have zones, assume tax is set up
    }

    console.log('🔧 Setting up default tax configuration...');
    
    // Create a default tax zone and category
    await tx.rawConnection.query(`
      INSERT INTO zone (id, name, "createdAt", "updatedAt") 
      VALUES ('1', 'Default Zone', NOW(), NOW()) 
      ON CONFLICT (id) DO NOTHING
    `);
    
    await tx.rawConnection.query(`
      INSERT INTO tax_category (id, name, "isDefault", "createdAt", "updatedAt") 
      VALUES ('1', 'Standard', true, NOW(), NOW()) 
      ON CONFLICT (id) DO NOTHING
    `);
    
    await tx.rawConnection.query(`
      INSERT INTO tax_rate (id, name, value, enabled, "categoryId", "zoneId", "createdAt", "updatedAt") 
      VALUES ('1', 'Standard Rate', 0, true, '1', '1', NOW(), NOW()) 
      ON CONFLICT (id) DO NOTHING
    `);

    console.log('✅ Default tax configuration created');
  } catch (err: any) {
    console.warn('⚠️  Tax setup warning (continuing):', err.message);
  }
}

async function run() {
  try {
    console.log('🚀 Starting complete database reset and seeding process...\n');
    
    // Step 1: Wipe database
    await wipeDatabase();
    
    // Step 2: Setup Vendure
    await setupVendure();
    
    // Step 3: Import seed products
    await importSeedProducts();
    
    console.log('\n🎉 Complete process finished successfully!');
  } catch (err: any) {
    console.error('❌ Process failed:', err.message || err);
    process.exit(1);
  }
}

if (require.main === module) {
  run();
}

export { run as runCompleteSeeding };