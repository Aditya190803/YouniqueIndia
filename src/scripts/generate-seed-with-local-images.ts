import fs from 'fs';
import path from 'path';

interface JsonAsset {
  source?: string | null;
  preview?: string | null;
}

interface JsonVariant {
  id?: string | number;
  sku?: string | null;
  price?: number | string | null;
  options?: Array<{ name?: string | null } | string>;
}

interface JsonFacetValue {
  id?: string;
  code?: string;
  name?: string;
  facet?: {
    id?: string;
    code?: string;
    name?: string;
  };
}

interface JsonCollection {
  id?: string;
  name?: string;
  slug?: string;
}

interface JsonProduct {
  id?: string | number;
  name?: string | null;
  slug?: string | null;
  description?: string | null;
  featuredAsset?: JsonAsset | null;
  assets?: JsonAsset[];
  variants?: JsonVariant[];
  facetValues?: JsonFacetValue[];
  collections?: JsonCollection[];
}

interface JsonRoot {
  exportedAt?: string;
  source?: string;
  totalItems?: number;
  products?: JsonProduct[];
}

export interface SeedVariant {
  sku: string;
  price: number;
  options: string[];
  assets: string[];
}

export interface SeedProduct {
  slug: string;
  name: string;
  description: string;
  variants: SeedVariant[];
  assetIds: string[];
  featuredAsset?: string;
  categories?: string[];
  collections?: string[];
}

interface GenerateOptions {
  jsonPath: string;
  outputPath: string;
  assetsDir: string;
  limit?: number;
}

async function main() {
  const options = resolveOptions();
  
  if (!fs.existsSync(options.jsonPath)) {
    throw new Error(`JSON dump not found at ${options.jsonPath}`);
  }
  
  if (!fs.existsSync(options.assetsDir)) {
    throw new Error(`Assets directory not found at ${options.assetsDir}`);
  }

  ensureDir(path.dirname(options.outputPath));

  // Read available local images
  const availableImages = new Set<string>(fs.readdirSync(options.assetsDir));
  console.log(`📁 Found ${availableImages.size} images in assets directory`);

  // Parse JSON data
  const raw = await fs.promises.readFile(options.jsonPath, 'utf8');
  const parsed: JsonRoot = JSON.parse(raw);
  const products = Array.isArray(parsed.products) ? parsed.products : [];
  
  if (products.length === 0) {
    throw new Error('No products found in dump.');
  }

  const limitedProducts = typeof options.limit === 'number' ? products.slice(0, options.limit) : products;
  console.log(`🔍 Processing ${limitedProducts.length} products...`);

  const slugCounts = new Map<string, number>();
  const seedProducts: SeedProduct[] = [];
  let productsWithImages = 0;
  let productsWithoutImages = 0;

  for (const product of limitedProducts) {
    const name = (product.name || '').trim() || 'Untitled Product';
    const baseSlug = product.slug || name;
    const slug = uniqueSlug(slugify(baseSlug), slugCounts);
    const description = normalizeDescription(product.description || '');

    const variants = buildVariants(product, slug);
    const categories = extractCategories(product);
    const collections = extractCollections(product);

    // Try to match with available local images
    const matchedImages = findMatchingImages(slug, name, availableImages);
    const assetIds = matchedImages.map(img => `seed/${img}`);
    const featuredAsset = assetIds.length > 0 ? assetIds[0] : undefined;

    if (assetIds.length > 0) {
      productsWithImages++;
      console.log(`✅ ${name} -> matched ${assetIds.length} image(s)`);
    } else {
      productsWithoutImages++;
      console.log(`⚠️  ${name} -> no matching images found`);
    }

    seedProducts.push({
      slug,
      name,
      description,
      variants,
      assetIds,
      featuredAsset,
      categories,
      collections,
    });
  }

  await writeSeedFile(options.outputPath, seedProducts);

  console.log('\n✅ Seed generation complete');
  console.log(`   Source dump: ${path.relative(process.cwd(), options.jsonPath)}`);
  console.log(`   Products processed: ${seedProducts.length}`);
  console.log(`   Products with images: ${productsWithImages}`);
  console.log(`   Products without images: ${productsWithoutImages}`);
  console.log(`   Assets directory: ${path.relative(process.cwd(), options.assetsDir)}`);
  console.log(`   Output file: ${path.relative(process.cwd(), options.outputPath)}`);
}

function resolveOptions(): GenerateOptions {
  const args = process.argv.slice(2);
  const getValue = (flag: string): string | undefined => {
    const index = args.findIndex(arg => arg === flag || arg.startsWith(`${flag}=`));
    if (index === -1) return undefined;
    const value = args[index].includes('=') ? args[index].split('=')[1] : args[index + 1];
    return value;
  };

  const jsonPath = getValue('--json') || path.join(__dirname, '../../data-dumps/shop-products/shop-products-full-data-without-images.json');
  const outputPath = getValue('--out') || path.join(__dirname, '2-seed-products-with-local-images.generated.ts');
  const assetsDir = getValue('--assets-dir') || path.join(__dirname, '../../static/assets/seed');
  const limitParam = getValue('--limit');
  const limit = limitParam ? Number.parseInt(limitParam, 10) : undefined;

  return {
    jsonPath: path.isAbsolute(jsonPath) ? jsonPath : path.join(process.cwd(), jsonPath),
    outputPath: path.isAbsolute(outputPath) ? outputPath : path.join(process.cwd(), outputPath),
    assetsDir: path.isAbsolute(assetsDir) ? assetsDir : path.join(process.cwd(), assetsDir),
    limit: Number.isFinite(limit) ? limit : undefined,
  };
}

function slugify(input: string): string {
  return input
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '')
    .trim();
}

function uniqueSlug(base: string, counts: Map<string, number>): string {
  const slug = base || 'product';
  const current = counts.get(slug) || 0;
  counts.set(slug, current + 1);
  if (current === 0) {
    return slug;
  }
  return `${slug}-${current + 1}`;
}

function normalizeDescription(input: string): string {
  if (!input) return '';
  const replaced = input
    .replace(/<\/?br\s*\/?\s*>/gi, '\n')
    .replace(/<\/?p[^>]*>/gi, '\n')
    .replace(/<\/?li[^>]*>/gi, '\n• ')
    .replace(/<[^>]*>/g, ' ')
    .replace(/&nbsp;/gi, ' ')
    .replace(/&amp;/gi, '&')
    .replace(/&quot;/gi, '"')
    .replace(/&#39;/gi, "'");
  return replaced
    .split('\n')
    .map(line => line.trim())
    .filter(Boolean)
    .join('\n');
}

function buildVariants(product: JsonProduct, slug: string): SeedVariant[] {
  const variants = Array.isArray(product.variants) ? product.variants : [];
  if (variants.length === 0) {
    return [{ sku: `${slug}-SKU`, price: 0, options: [], assets: [] }];
  }
  return variants.map((variant, index) => {
    const rawSku = typeof variant.sku === 'string' ? variant.sku.trim() : '';
    const sku = rawSku || `${slug}-${index + 1}`;
    const price = typeof variant.price === 'number'
      ? variant.price
      : (typeof variant.price === 'string' ? Number.parseInt(variant.price, 10) : 0);
    const options = Array.isArray(variant.options)
      ? variant.options
          .map(opt => typeof opt === 'string' ? opt : (opt?.name ?? ''))
          .map(opt => opt.trim())
          .filter(Boolean)
      : [];
    return {
      sku,
      price: Number.isFinite(price) ? price : 0,
      options,
      assets: [],
    };
  });
}

function extractCategories(product: JsonProduct): string[] {
  if (!Array.isArray(product.facetValues)) return [];
  
  return product.facetValues
    .filter(fv => fv.facet?.code === 'category')
    .map(fv => fv.name || '')
    .filter(Boolean);
}

function extractCollections(product: JsonProduct): string[] {
  if (!Array.isArray(product.collections)) return [];
  
  return product.collections
    .map(col => col.name || '')
    .filter(Boolean);
}

function findMatchingImages(slug: string, name: string, availableImages: Set<string>): string[] {
  const matches: string[] = [];
  
  // Clean and normalize slug for matching
  const cleanSlug = slug.toLowerCase().replace(/-+$/, '');
  
  // Generate possible image names to look for
  const possibleNames = [
    `${cleanSlug}-1.jpg`,
    `${cleanSlug}-1.png`,
    `${cleanSlug}-1.jpeg`,
    `${cleanSlug}-1.webp`,
    `${cleanSlug}.jpg`,
    `${cleanSlug}.png`,
    `${cleanSlug}.jpeg`,
    `${cleanSlug}.webp`,
  ];

  // Check for exact matches first
  for (const imageName of possibleNames) {
    if (availableImages.has(imageName)) {
      matches.push(imageName);
      break; // Only take the first match
    }
  }

  // If no exact match, try partial matching
  if (matches.length === 0) {
    const nameTokens = cleanSlug.split('-').filter(Boolean);
    
    for (const imageName of Array.from(availableImages)) {
      const imageNameLower = imageName.toLowerCase();
      
      // Check if the image name contains key tokens from the product slug
      let matchCount = 0;
      for (const token of nameTokens) {
        if (token.length >= 3 && imageNameLower.includes(token)) {
          matchCount++;
        }
      }
      
      // If at least half the tokens match, consider it a match
      if (matchCount >= Math.ceil(nameTokens.length / 2) && matchCount >= 1) {
        matches.push(imageName);
        break; // Only take the first match
      }
    }
  }

  return matches;
}

function ensureDir(dir: string) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

async function writeSeedFile(outputPath: string, data: SeedProduct[]) {
  const serialized = JSON.stringify(data, null, 2);
  const lines = [
    "// Auto-generated using src/scripts/generate-seed-with-local-images.ts",
    "// Do not edit manually.",
    '',
    "import fs from 'fs';",
    "import path from 'path';",
    '',
    'export interface SeedVariant { sku: string; price: number; options: string[]; assets: string[] }',
    'export interface SeedProduct { slug: string; name: string; description: string; variants: SeedVariant[]; assetIds: string[]; featuredAsset?: string; categories?: string[]; collections?: string[] }',
    '',
    `export const SEED_PRODUCTS: SeedProduct[] = ${serialized};`,
    '',
    '// Post-process SEED_PRODUCTS to ensure asset paths are correct',
    '(() => {',
    '  try {',
    "    const seedDir = path.join(__dirname, '../../static/assets/seed');",
    '    if (!fs.existsSync(seedDir)) return;',
    '    const fileLookup = new Map(fs.readdirSync(seedDir).map((f: string) => [f.toLowerCase(), f]));',
    '    ',
    '    for (const product of SEED_PRODUCTS) {',
    '      product.assetIds = (product.assetIds || []).map(asset => {',
    '        if (!asset || /^https?:/i.test(asset)) return asset;',
    "        const relative = asset.replace(/^seed\\//i, '');",
    '        const matched = fileLookup.get(relative.toLowerCase());',
    "        return matched ? `seed/${matched}` : asset;",
    '      }).filter(Boolean);',
    '      ',
    '      if (product.assetIds.length > 0 && !product.featuredAsset) {',
    '        product.featuredAsset = product.assetIds[0];',
    '      }',
    '    }',
    '  } catch (err) {',
    "    console.warn('Seed asset normalization failed:', (err as any)?.message || err);",
    '  }',
    '})();',
    '',
  ];
  await fs.promises.writeFile(outputPath, `${lines.join('\n')}\n`, 'utf8');
}

void main().catch(err => {
  console.error('❌ Seed generation failed:', err?.message || err);
  process.exitCode = 1;
});