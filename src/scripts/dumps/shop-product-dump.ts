import 'dotenv/config';
import path from 'path';
import { mkdir, writeFile } from 'fs/promises';
import { fetch } from 'undici';

interface GraphQLResponse<T> {
  data?: T;
  errors?: Array<{ message: string }>;
}

interface ProductListResult {
  products: {
    totalItems: number;
    items: Array<Record<string, unknown>>;
  };
}

const DEFAULT_SHOP_API_URL = 'http://localhost:10000/shop-api';
const SHOP_API_URL = process.env.SHOP_API_URL ?? DEFAULT_SHOP_API_URL;
const OUTPUT_ROOT = path.resolve(process.cwd(), 'data-dumps', 'shop-products');
const PAGE_SIZE = Number.parseInt(process.env.SHOP_API_PAGE_SIZE ?? '', 10) || 50;

const PRODUCTS_QUERY = /* GraphQL */ `
  query ShopProducts($options: ProductListOptions) {
    products(options: $options) {
      totalItems
      items {
        id
        createdAt
        updatedAt
        name
        slug
        description
        featuredAsset {
          id
          preview
          source
          focalPoint {
            x
            y
          }
        }
        assets {
          id
          preview
          source
          focalPoint {
            x
            y
          }
        }
        optionGroups {
          id
          code
          name
          options {
            id
            code
            name
          }
        }
        facetValues {
          id
          code
          name
          facet {
            id
            code
            name
          }
        }
        collections {
          id
          name
          slug
        }
        variants {
          id
          createdAt
          updatedAt
          name
          sku
          price
          priceWithTax
          currencyCode
          stockLevel
          featuredAsset {
            id
            preview
            source
            focalPoint {
              x
              y
            }
          }
          assets {
            id
            preview
            source
            focalPoint {
              x
              y
            }
          }
          options {
            id
            code
            name
          }
          facetValues {
            id
            code
            name
            facet {
              id
              code
              name
            }
          }
          customFields
        }
        customFields
      }
    }
  }
`;

async function executeGraphQL<T>(query: string, variables: Record<string, unknown>): Promise<T> {
  const res = await fetch(SHOP_API_URL, {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
    },
    body: JSON.stringify({ query, variables }),
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`HTTP ${res.status}: ${res.statusText}\n${body}`);
  }

  const json = (await res.json()) as GraphQLResponse<T>;
  if (json.errors?.length) {
    const message = json.errors.map(err => err.message).join('; ');
    throw new Error(`GraphQL error(s): ${message}`);
  }

  if (!json.data) {
    throw new Error('No data returned from GraphQL response.');
  }

  return json.data;
}

async function fetchAllProducts(): Promise<Array<Record<string, unknown>>> {
  const collected: Array<Record<string, unknown>> = [];
  let totalItems = Infinity;
  let skip = 0;

  while (skip < totalItems) {
    const data = await executeGraphQL<ProductListResult>(PRODUCTS_QUERY, {
      options: {
        skip,
        take: PAGE_SIZE,
        sort: { createdAt: 'ASC' },
      },
    });

    const { products } = data;
    totalItems = products.totalItems;
    const batch = products.items ?? [];
    collected.push(...batch);
    skip += batch.length;

    console.log(`Fetched ${collected.length}/${totalItems} products`);

    if (batch.length === 0) {
      break;
    }
  }

  return collected;
}

async function main() {
  console.log(`Using Shop API endpoint: ${SHOP_API_URL}`);
  const products = await fetchAllProducts();

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `shop-products-${timestamp}.json`;
  const destinationDir = path.join(OUTPUT_ROOT);
  const destination = path.join(destinationDir, filename);

  await mkdir(destinationDir, { recursive: true });
  const payload = {
    exportedAt: new Date().toISOString(),
    source: SHOP_API_URL,
    totalItems: products.length,
    products,
  };

  await writeFile(destination, JSON.stringify(payload, null, 2), 'utf8');
  console.log(`Saved ${products.length} products to ${destination}`);
}

main().catch(err => {
  console.error('Failed to export products:', err);
  process.exit(1);
});
