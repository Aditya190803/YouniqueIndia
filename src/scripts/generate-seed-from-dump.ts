import fs from 'fs';
import path from 'path';
import { fetch } from 'undici';

interface DumpAsset {
  source?: string | null;
  preview?: string | null;
}

interface DumpVariant {
  id?: string | number;
  sku?: string | null;
  price?: number | string | null;
  options?: Array<{ name?: string | null } | string>;
}

interface DumpProduct {
  id?: string | number;
  name?: string | null;
  slug?: string | null;
  description?: string | null;
  featuredAsset?: DumpAsset | null;
  assets?: DumpAsset[];
  variants?: DumpVariant[];
}

interface DumpRoot {
  exportedAt?: string;
  source?: string;
  totalItems?: number;
  products?: DumpProduct[];
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
}

interface GenerateOptions {
  jsonPath: string;
  outputPath: string;
  assetsDir: string;
  skipDownload: boolean;
  cleanAssets: boolean;
  limit?: number;
}

async function main() {
  const options = resolveOptions();
  if (!fs.existsSync(options.jsonPath)) {
    throw new Error(`JSON dump not found at ${options.jsonPath}`);
  }
  ensureDir(path.dirname(options.outputPath));
  ensureDir(options.assetsDir);

  if (options.cleanAssets) {
    await cleanDirectory(options.assetsDir);
  }

  const raw = await fs.promises.readFile(options.jsonPath, 'utf8');
  const parsed: DumpRoot = JSON.parse(raw);
  const products = Array.isArray(parsed.products) ? parsed.products : [];
  if (products.length === 0) {
    throw new Error('No products found in dump.');
  }
  const limitedProducts = typeof options.limit === 'number' ? products.slice(0, options.limit) : products;

  const slugCounts = new Map<string, number>();
  const seedProducts: SeedProduct[] = [];
  let downloaded = 0;
  let skippedDownloads = 0;

  for (const product of limitedProducts) {
    const name = (product.name || '').trim() || 'Untitled Product';
    const baseSlug = product.slug || name;
    const slug = uniqueSlug(slugify(baseSlug), slugCounts);
    const description = normalizeDescription(product.description || '');

    const variants = buildVariants(product, slug);
    const assetSources = collectAssetSources(product);
    const assetIds: string[] = [];

    let assetIndex = 1;
    for (const assetUrl of assetSources) {
      const ext = pickExtension(assetUrl);
      const filename = `${slug}-${assetIndex}${ext}`;
      const destPath = path.join(options.assetsDir, filename);
      let downloadedThis = false;
      if (options.skipDownload && fs.existsSync(destPath)) {
        skippedDownloads++;
        downloadedThis = true;
      } else {
        downloadedThis = await downloadAsset(assetUrl, destPath);
        if (downloadedThis) {
          downloaded++;
        }
      }
      if (downloadedThis || fs.existsSync(destPath)) {
        assetIds.push(`seed/${filename}`);
      }
      assetIndex++;
    }

    const featuredAsset = assetIds[0];
    seedProducts.push({
      slug,
      name,
      description,
      variants,
      assetIds,
      featuredAsset,
    });
  }

  await writeSeedFile(options.outputPath, seedProducts);

  console.log('✅ Seed generation complete');
  console.log(`   Source dump: ${path.relative(process.cwd(), options.jsonPath)}`);
  console.log(`   Products processed: ${seedProducts.length}`);
  console.log(`   Assets directory: ${path.relative(process.cwd(), options.assetsDir)}`);
  console.log(`   Assets downloaded: ${downloaded}`);
  if (options.skipDownload) {
    console.log(`   Assets skipped (existing): ${skippedDownloads}`);
  }
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

  const root = path.join(__dirname, '../../data-dumps/shop-products');
  const latestDump = findLatestJson(root);
  const jsonPath = getValue('--json') || latestDump || path.join(root, 'shop-products.json');
  const outputPath = getValue('--out') || path.join(__dirname, '2-seed-products.generated.ts');
  const assetsDir = getValue('--assets-dir') || path.join(__dirname, '../../static/assets/seed');
  const skipDownload = args.includes('--skip-download');
  const cleanAssets = args.includes('--clean-assets');
  const limitParam = getValue('--limit');
  const limit = limitParam ? Number.parseInt(limitParam, 10) : undefined;

  return {
    jsonPath: path.isAbsolute(jsonPath) ? jsonPath : path.join(process.cwd(), jsonPath),
    outputPath: path.isAbsolute(outputPath) ? outputPath : path.join(process.cwd(), outputPath),
    assetsDir: path.isAbsolute(assetsDir) ? assetsDir : path.join(process.cwd(), assetsDir),
    skipDownload,
    cleanAssets,
    limit: Number.isFinite(limit) ? limit : undefined,
  };
}

function findLatestJson(dir: string): string | undefined {
  try {
    const files = fs.readdirSync(dir)
      .filter((f: string) => f.toLowerCase().endsWith('.json'))
      .map((f: string) => ({ file: f, full: path.join(dir, f) }))
      .sort((a: { file: string; full: string }, b: { file: string; full: string }) => b.file.localeCompare(a.file));
    return files[0]?.full;
  } catch {
    return undefined;
  }
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

function buildVariants(product: DumpProduct, slug: string): SeedVariant[] {
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

function collectAssetSources(product: DumpProduct): string[] {
  const urls = new Set<string>();
  const add = (asset?: DumpAsset | null) => {
    if (!asset) return;
    const source = asset.source || asset.preview;
    if (!source) return;
    urls.add(source);
  };
  add(product.featuredAsset || null);
  if (Array.isArray(product.assets)) {
    for (const asset of product.assets) {
      add(asset);
    }
  }
  return Array.from(urls);
}

function pickExtension(url: string): string {
  try {
    const parsed = new URL(url);
    const pathname = parsed.pathname || '';
    const ext = path.extname(pathname).toLowerCase();
    if (ext && ext.length <= 5) {
      return ext;
    }
  } catch {
    // ignore
  }
  return '.jpg';
}

async function downloadAsset(url: string, destFile: string): Promise<boolean> {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      console.warn(`   ⚠️ Failed to download ${url}: HTTP ${response.status}`);
      return false;
    }
    const arrayBuffer = await response.arrayBuffer();
    await fs.promises.writeFile(destFile, Buffer.from(arrayBuffer));
    console.log(`   📥 Downloaded ${path.basename(destFile)}`);
    return true;
  } catch (err: any) {
    console.warn(`   ⚠️ Download error for ${url}: ${err?.message || err}`);
    return false;
  }
}

async function cleanDirectory(dir: string) {
  const entries = await fs.promises.readdir(dir, { withFileTypes: true });
  await Promise.all(entries.map(async (entry: fs.Dirent) => {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      await fs.promises.rm(full, { recursive: true, force: true });
    } else {
      await fs.promises.unlink(full);
    }
  }));
}

function ensureDir(dir: string) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

async function writeSeedFile(outputPath: string, data: SeedProduct[]) {
  const serialized = JSON.stringify(data, null, 2);
  const lines = [
    "// Auto-generated using src/scripts/generate-seed-from-dump.ts",
    "// Do not edit manually.",
    '',
    "import fs from 'fs';",
    "import path from 'path';",
    '',
    'export interface SeedVariant { sku: string; price: number; options: string[]; assets: string[] }',
    'export interface SeedProduct { slug: string; name: string; description: string; variants: SeedVariant[]; assetIds: string[]; featuredAsset?: string }',
    '',
    `export const SEED_PRODUCTS: SeedProduct[] = ${serialized};`,
    '',
    '(() => {',
    '  try {',
    "    const seedDir = path.join(__dirname, '../../static/assets/seed');",
    '    if (!fs.existsSync(seedDir)) return;',
    '    const fileLookup = new Map(fs.readdirSync(seedDir).map((f: string) => [f.toLowerCase(), f]));',
    '    for (const product of SEED_PRODUCTS) {',
    '      product.assetIds = (product.assetIds || []).map(asset => {',
    '        if (!asset || /^https?:/i.test(asset)) return asset;',
    "        const relative = asset.replace(/^seed\\//i, '');",
    '        const matched = fileLookup.get(relative.toLowerCase());',
    "        return matched ? `seed/${matched}` : asset;",
    '      });',
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
