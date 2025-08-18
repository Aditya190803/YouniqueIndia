import 'dotenv/config';
import { 
    bootstrap, 
    ProductService, 
    ProductVariantService, 
    TransactionalConnection, 
    LanguageCode, 
    RequestContextService, 
    ChannelService, 
    AssetService,
    CollectionService,
    FacetService,
    FacetValueService
} from '@vendure/core';
import path from 'path';
import fs from 'fs';
import { config as vendureConfig } from '../vendure-config';

// Auto-updated to local asset paths (rewrite-seed-to-local.ts)
export interface SeedVariant { sku: string; price: number; options: string[]; assets: string[]; }
export interface SeedProduct { slug: string; name: string; description: string; variants: SeedVariant[]; assetIds: string[]; featuredAsset?: string; }

/**
 * Categories for YouniqueIndia jewelry store
 */
const CATEGORIES = [
    {
        name: 'Necklaces',
        slug: 'necklaces',
        description: 'Beautiful necklaces for every occasion'
    },
    {
        name: 'Bracelets', 
        slug: 'bracelets',
        description: 'Elegant bracelets and bangles'
    },
    {
        name: 'Earrings',
        slug: 'earrings', 
        description: 'Stunning earrings and hoops'
    },
    {
        name: 'Rings',
        slug: 'rings',
        description: 'Beautiful rings for all occasions'
    },
    {
        name: 'Anklets',
        slug: 'anklets',
        description: 'Delicate anklets and ankle jewelry'
    },
    {
        name: 'Hair Accessories',
        slug: 'hair-accessories',
        description: 'Hair clips, pins and jewelry accessories'
    },
    {
        name: "Men's Jewellery",
        slug: 'mens-jewellery',
        description: 'Sophisticated jewelry designed for men'
    },
    {
        name: 'Gifts',
        slug: 'gifts',
        description: 'Perfect gifts for your loved ones'
    }
];

/**
 * Facets for filtering products
 */
const FACETS = [
    {
        name: 'Material',
        code: 'material',
        values: ['18k Gold Plated', 'Rose Gold', 'White Gold', 'Silver', 'Stainless Steel']
    },
    {
        name: 'Features',
        code: 'features', 
        values: ['Anti Tarnish', 'Waterproof', 'Hypoallergenic', 'Adjustable']
    },
    {
        name: 'Style',
        code: 'style',
        values: ['Minimalist', 'Statement', 'Vintage', 'Modern', 'Bohemian', 'Classic']
    },
    {
        name: 'Occasion',
        code: 'occasion',
        values: ['Daily Wear', 'Party', 'Wedding', 'Festive', 'Office', 'Casual']
    },
    {
        name: 'Price Range',
        code: 'price-range',
        values: ['Under ₹200', '₹200-₹300', '₹300-₹400', 'Above ₹400']
    },
    {
        name: 'Color',
        code: 'color',
        values: ['Gold', 'Silver', 'Rose Gold', 'Black', 'Multi-Color']
    }
];

/**
 * Product category mapping based on product names/types
 */
const PRODUCT_CATEGORY_MAPPING: { [key: string]: string[] } = {
    'necklaces': [
        'hexa-heart-necklace-', 'tangled-heart-necklace', 'baby-bow-necklace', 
        'reversible-clover-necklace-', 'mini-bow-necklace', 'rozel-necklace',
        'rozel-gold', 'reversible-baby-heart-necklace', 'sunny-necklace',
        'diamor-necklace', 'sunlette-studded-necklace', '2in1-magnetic-heart-necklace',
        'green-stone-necklace', 'cherry-necklace', 'daisy-necklace', 'moonmist',
        'ribbon-bow-necklace', 'grace-flower-necklace', 'golden-squeeze',
        'adore-mini-necklace', 'droplet-necklace', '1111-manifest-necklace',
        '1111-heart-manifest-necklace', 'rosy-necklace', 'hearty-necklace',
        'autumn-necklace', 'teddy-bow-necklace', 'studded-teddy-necklace',
        'tangled-star-necklace', 'crescent-moon-stone-necklace', 'sea-charms-necklace',
        'snake-chain'
    ],
    'bracelets': [
        'bamboo-bracelet', 'knot-cuff-bracelet', 'bangle-bracelet', 'wavy-bracelet',
        'aurelia-link-bracelet', 'silver-bracelet', 'star-kada-bracelet',
        'roman-bracelet', 'tennis-bracelet', 'gold-clover-bracelet',
        'reversible-clover-bracelet', 'love-band-bracelet', 'flower-bracelet',
        'baby-size-bracelet-1', 'baby-size-bracelet-4', 'baby-size-bracelet-6',
        'aura-bracelet', 'white-gold-clover-bracelet', 'italian-bracelet-vintage-gold',
        'baby-size-bracelet-2', 'baby-size-bracelet-7', 'evil-eye-bracelet',
        'luxe-diamond-bracelet', 'baby-size-bracelet-3', 'baby-size-bracelet-5'
    ],
    'earrings': [
        'spiral-hoops', 'spiral-earrings', 'puffy-hearts', 'textured-square-earring',
        'bow-tiful-earrings', 'hexa-heart-studs', 'hearty-hoops', 'flora-mini-studs',
        'hampered-hoops', 'dual-tone-hoop', 'bamboo-earrings', 'round-hoops',
        'spiral-hoops-2', 'flora-earrings'
    ],
    'rings': [
        'moon-star-ring', 'bang-ring-rose-gold-size-7-'
    ]
};

// Suppress noisy post-import connection termination errors
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
export const SEED_PRODUCTS: SeedProduct[] = [
  {
    "slug": "hexa-heart-necklace-",
    "name": "Hexa Heart Necklace ",
    "description": "<p>18k gold plated </p><p>Anti tarnish </p><p>Waterproof </p>",
    "variants": [
      {
        "sku": "HN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/hexa-heart-necklace-1.jpg"
    ],
    "featuredAsset": "seed/hexa-heart-necklace-1.jpg"
  },
  {
    "slug": "tangled-heart-necklace",
    "name": "Tangled Heart necklace",
    "description": "",
    "variants": [
      {
        "sku": "",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/tangled-heart-necklace-1.jpg"
    ],
    "featuredAsset": "seed/tangled-heart-necklace-1.jpg"
  },
  {
    "slug": "baby-bow-necklace",
    "name": "Baby bow necklace",
    "description": "",
    "variants": [
      {
        "sku": "BBN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-bow-necklace-1.jpg"
    ],
    "featuredAsset": "seed/baby-bow-necklace-1.jpg"
  },
  {
    "slug": "reversible-clover-necklace-",
    "name": "Reversible Clover Necklace ",
    "description": "<p>18k gold plated </p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "RCN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/reversible-clover-necklace-1.jpg"
    ],
    "featuredAsset": "seed/reversible-clover-necklace-1.jpg"
  },
  {
    "slug": "spiral-hoops",
    "name": "Spiral Hoops",
    "description": "<p>18k gold plated </p><p>Anti tarnish</p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/spiral-hoops-1.jpg"
    ],
    "featuredAsset": "seed/spiral-hoops-1.jpg"
  },
  {
    "slug": "mini-bow-necklace",
    "name": "Mini Bow Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "MBN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/mini-bow-necklace-1.png"
    ],
    "featuredAsset": "seed/mini-bow-necklace-1.png"
  },
  {
    "slug": "bamboo-bracelet",
    "name": "Bamboo Bracelet",
    "description": "<p>18k gold plated</p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "BB",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/bamboo-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/bamboo-bracelet-1.jpg"
  },
  {
    "slug": "knot-cuff-bracelet",
    "name": "Knot Cuff Bracelet",
    "description": "<p>18k gold plated</p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "KCB",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/knot-cuff-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/knot-cuff-bracelet-1.jpg"
  },
  {
    "slug": "rozel-necklace",
    "name": "Rozel Necklace",
    "description": "<p>18k gold plated</p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "RN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/rozel-necklace-1.jpg"
    ],
    "featuredAsset": "seed/rozel-necklace-1.jpg"
  },
  {
    "slug": "rozel-gold",
    "name": "Rozel Gold",
    "description": "<p>18k gold plated </p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "RGN",
        "price": 32900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/rozel-gold-1.jpg"
    ],
    "featuredAsset": "seed/rozel-gold-1.jpg"
  },
  {
    "slug": "spiral-earrings",
    "name": "Spiral Earrings",
    "description": "<p>18k gold plated</p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "SE",
        "price": 27900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/spiral-earrings-1.png"
    ],
    "featuredAsset": "seed/spiral-earrings-1.png"
  },
  {
    "slug": "puffy-hearts",
    "name": "Puffy Hearts",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "PHE",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/puffy-hearts-1.jpg"
    ],
    "featuredAsset": "seed/puffy-hearts-1.jpg"
  },
  {
    "slug": "reversible-baby-heart-necklace",
    "name": "Reversible Baby heart Necklace",
    "description": "<p>18k gold plated </p><p>Waterproof</p><p>Anti tarnish </p>",
    "variants": [
      {
        "sku": "RBHN",
        "price": 32900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/reversible-baby-heart-necklace-1.jpg"
    ],
    "featuredAsset": "seed/reversible-baby-heart-necklace-1.jpg"
  },
  {
    "slug": "sunny-necklace",
    "name": "Sunny Necklace",
    "description": "<p>18k gold plated </p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "SN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/sunny-necklace-1.jpg"
    ],
    "featuredAsset": "seed/sunny-necklace-1.jpg"
  },
  {
    "slug": "diamor-necklace",
    "name": "Diamor Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "DN",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/diamor-necklace-1.jpg"
    ],
    "featuredAsset": "seed/diamor-necklace-1.jpg"
  },
  {
    "slug": "bangle-bracelet",
    "name": "Bangle Bracelet",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BB",
        "price": 39900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/bangle-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/bangle-bracelet-1.jpg"
  },
  {
    "slug": "wavy-bracelet",
    "name": "Wavy Bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "WB",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/wavy-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/wavy-bracelet-1.jpg"
  },
  {
    "slug": "textured-square-earring",
    "name": "Textured Square Earring",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "TSE",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/textured-square-earring-1.jpg"
    ],
    "featuredAsset": "seed/textured-square-earring-1.jpg"
  },
  {
    "slug": "sunlette-studded-necklace",
    "name": "Sunlette studded Necklace",
    "description": "",
    "variants": [
      {
        "sku": "SSN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/sunlette-studded-necklace-1.jpg"
    ],
    "featuredAsset": "seed/sunlette-studded-necklace-1.jpg"
  },
  {
    "slug": "2in1-magnetic-heart-necklace",
    "name": "2in1 Magnetic Heart Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "MHN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/2in1-magnetic-heart-necklace-1.jpg",
      "seed/2in1-magnetic-heart-necklace-2.jpg"
    ],
    "featuredAsset": "seed/2in1-magnetic-heart-necklace-1.jpg"
  },
  {
    "slug": "green-stone-necklace",
    "name": "Green stone necklace",
    "description": "<p>18k gold plated</p><p>Anti tarnish</p><p>Waterproof z</p>",
    "variants": [
      {
        "sku": "GSN",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/green-stone-necklace-1.jpg"
    ],
    "featuredAsset": "seed/green-stone-necklace-1.jpg"
  },
  {
    "slug": "silver-bracelet",
    "name": "Silver Bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "SK",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/silver-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/silver-bracelet-1.jpg"
  },
  {
    "slug": "cherry-necklace",
    "name": "Cherry necklace",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "CN",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/cherry-necklace-1.jpg"
    ],
    "featuredAsset": "seed/cherry-necklace-1.jpg"
  },
  {
    "slug": "aurelia-link-bracelet",
    "name": "Aurelia Link Bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "ALB",
        "price": 36500,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/aurelia-link-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/aurelia-link-bracelet-1.jpg"
  },
  {
    "slug": "daisy-necklace",
    "name": "Daisy Necklace",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "DN",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/daisy-necklace-1.jpg"
    ],
    "featuredAsset": "seed/daisy-necklace-1.jpg"
  },
  {
    "slug": "bow-tiful-earrings",
    "name": "Bow-tiful Earrings",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BHE",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/bow-tiful-earrings-1.jpg"
    ],
    "featuredAsset": "seed/bow-tiful-earrings-1.jpg"
  },
  {
    "slug": "hexa-heart-studs",
    "name": "Hexa Heart studs",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "HHS",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/hexa-heart-studs-1.jpg"
    ],
    "featuredAsset": "seed/hexa-heart-studs-1.jpg"
  },
  {
    "slug": "hearty-hoops",
    "name": "Hearty Hoops",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "HH",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/hearty-hoops-1.jpg"
    ],
    "featuredAsset": "seed/hearty-hoops-1.jpg"
  },
  {
    "slug": "flora-mini-studs",
    "name": "Flora mini studs",
    "description": "<p>18k gold plated </p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "FMS",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/flora-mini-studs-1.jpg",
      "seed/flora-mini-studs-2.jpg"
    ],
    "featuredAsset": "seed/flora-mini-studs-1.jpg"
  },
  {
    "slug": "moonmist",
    "name": "Moonmist",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "MMN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/moonmist-1.jpg"
    ],
    "featuredAsset": "seed/moonmist-1.jpg"
  },
  {
    "slug": "ribbon-bow-necklace",
    "name": "Ribbon Bow Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "RBN",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/ribbon-bow-necklace-1.jpg"
    ],
    "featuredAsset": "seed/ribbon-bow-necklace-1.jpg"
  },
  {
    "slug": "grace-flower-necklace",
    "name": "Grace Flower Necklace",
    "description": "",
    "variants": [
      {
        "sku": "GFN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/grace-flower-necklace-1.jpg"
    ],
    "featuredAsset": "seed/grace-flower-necklace-1.jpg"
  },
  {
    "slug": "golden-squeeze",
    "name": "Golden Squeeze",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "THN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/golden-squeeze-1.jpg"
    ],
    "featuredAsset": "seed/golden-squeeze-1.jpg"
  },
  {
    "slug": "adore-mini-necklace",
    "name": "Adore mini Necklace",
    "description": "<p>18k gold plated</p><p>Anti tarnish </p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "AMN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/adore-mini-necklace-1.jpg"
    ],
    "featuredAsset": "seed/adore-mini-necklace-1.jpg"
  },
  {
    "slug": "star-kada-bracelet",
    "name": "Star kada Bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "SKB",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/star-kada-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/star-kada-bracelet-1.jpg"
  },
  {
    "slug": "roman-bracelet",
    "name": "Roman Bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "RB",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/roman-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/roman-bracelet-1.jpg"
  },
  {
    "slug": "droplet-necklace",
    "name": "Droplet Necklace",
    "description": "<p>Anti tarnish</p><p>Waterproof </p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "DLN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/droplet-necklace-1.jpg"
    ],
    "featuredAsset": "seed/droplet-necklace-1.jpg"
  },
  {
    "slug": "1111-manifest-necklace",
    "name": "11:11 Manifest Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "MN",
        "price": 32900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/1111-manifest-necklace-1.jpg"
    ],
    "featuredAsset": "seed/1111-manifest-necklace-1.jpg"
  },
  {
    "slug": "1111-heart-manifest-necklace",
    "name": "11:11 Heart Manifest Necklace",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p><p></p>",
    "variants": [
      {
        "sku": "MHNz",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/1111-heart-manifest-necklace-1.jpg"
    ],
    "featuredAsset": "seed/1111-heart-manifest-necklace-1.jpg"
  },
  {
    "slug": "rosy-necklace",
    "name": "Rosy Necklace",
    "description": "<p>Anti tarnish</p><p>Waterproof </p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "R",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/rosy-necklace-1.jpg"
    ],
    "featuredAsset": "seed/rosy-necklace-1.jpg"
  },
  {
    "slug": "hearty-necklace",
    "name": "Hearty Necklace",
    "description": "<p>18k gold plated</p><p>Anti tarnish</p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "HN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/hearty-necklace-1.jpg"
    ],
    "featuredAsset": "seed/hearty-necklace-1.jpg"
  },
  {
    "slug": "tennis-bracelet",
    "name": "Tennis Bracelet",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "TB",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/tennis-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/tennis-bracelet-1.jpg"
  },
  {
    "slug": "autumn-necklace",
    "name": "Autumn Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "AN",
        "price": 27900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/autumn-necklace-1.jpg"
    ],
    "featuredAsset": "seed/autumn-necklace-1.jpg"
  },
  {
    "slug": "gold-clover-bracelet",
    "name": "Gold clover Bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "GCB",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/gold-clover-bracelet-1.jpg",
      "seed/gold-clover-bracelet-2.jpg"
    ],
    "featuredAsset": "seed/gold-clover-bracelet-1.jpg"
  },
  {
    "slug": "reversible-clover-bracelet",
    "name": "Reversible Clover Bracelet",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic </p>",
    "variants": [
      {
        "sku": "RCB",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/reversible-clover-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/reversible-clover-bracelet-1.jpg"
  },
  {
    "slug": "teddy-bow-necklace",
    "name": "Teddy bow Necklace",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic z</p>",
    "variants": [
      {
        "sku": "TBN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/teddy-bow-necklace-1.jpg"
    ],
    "featuredAsset": "seed/teddy-bow-necklace-1.jpg"
  },
  {
    "slug": "studded-teddy-necklace",
    "name": "Studded Teddy Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "STN",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/studded-teddy-necklace-1.jpg"
    ],
    "featuredAsset": "seed/studded-teddy-necklace-1.jpg"
  },
  {
    "slug": "tangled-star-necklace",
    "name": "Tangled Star Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "TS",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/tangled-star-necklace-1.jpg"
    ],
    "featuredAsset": "seed/tangled-star-necklace-1.jpg"
  },
  {
    "slug": "love-band-bracelet",
    "name": "Love Band Bracelet",
    "description": "",
    "variants": [
      {
        "sku": "LBB",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/love-band-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/love-band-bracelet-1.jpg"
  },
  {
    "slug": "crescent-moon-stone-necklace",
    "name": "Crescent Moon Stone Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "CMN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/crescent-moon-stone-necklace-1.jpg"
    ],
    "featuredAsset": "seed/crescent-moon-stone-necklace-1.jpg"
  },
  {
    "slug": "hampered-hoops",
    "name": "Hampered Hoops",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "HH",
        "price": 19900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/hampered-hoops-1.jpg"
    ],
    "featuredAsset": "seed/hampered-hoops-1.jpg"
  },
  {
    "slug": "flower-bracelet",
    "name": "Flower bracelet",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/flower-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/flower-bracelet-1.jpg"
  },
  {
    "slug": "baby-size-bracelet-1",
    "name": "Baby size bracelet -1",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BB1",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-size-bracelet-1-1.jpg"
    ],
    "featuredAsset": "seed/baby-size-bracelet-1-1.jpg"
  },
  {
    "slug": "baby-size-bracelet-4",
    "name": "Baby size bracelet -4",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic </p>",
    "variants": [
      {
        "sku": "BB4",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-size-bracelet-4-1.jpg"
    ],
    "featuredAsset": "seed/baby-size-bracelet-4-1.jpg"
  },
  {
    "slug": "baby-size-bracelet-6",
    "name": "Baby size bracelet -6",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BB6",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-size-bracelet-6-1.jpg"
    ],
    "featuredAsset": "seed/baby-size-bracelet-6-1.jpg"
  },
  {
    "slug": "dual-tone-hoop",
    "name": "Dual Tone Hoop",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "DTH",
        "price": 24900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/dual-tone-hoop-1.jpg"
    ],
    "featuredAsset": "seed/dual-tone-hoop-1.jpg"
  },
  {
    "slug": "moon-star-ring",
    "name": "Moon Star ring",
    "description": "<p>Adjustable</p><p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "MSR",
        "price": 22900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/moon-star-ring-1.jpg"
    ],
    "featuredAsset": "seed/moon-star-ring-1.jpg"
  },
  {
    "slug": "bang-ring-rose-gold-size-7-",
    "name": "Bang Ring - Rose Gold size 7 ",
    "description": "<p>Size 7 </p><p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "RGR",
        "price": 19900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/bang-ring-rose-gold-size-7-1.jpg"
    ],
    "featuredAsset": "seed/bang-ring-rose-gold-size-7-1.jpg"
  },
  {
    "slug": "aura-bracelet",
    "name": "Aura Bracelet",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "AK",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/aura-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/aura-bracelet-1.jpg"
  },
  {
    "slug": "bamboo-earrings",
    "name": "Bamboo Earrings",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BH",
        "price": 19900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/bamboo-earrings-1.jpg"
    ],
    "featuredAsset": "seed/bamboo-earrings-1.jpg"
  },
  {
    "slug": "round-hoops",
    "name": "Round hoops",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "RH",
        "price": 19900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/round-hoops-1.jpg"
    ],
    "featuredAsset": "seed/round-hoops-1.jpg"
  },
  {
    "slug": "white-gold-clover-bracelet",
    "name": "White Gold Clover Bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "WCB",
        "price": 31900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/white-gold-clover-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/white-gold-clover-bracelet-1.jpg"
  },
  {
    "slug": "italian-bracelet-vintage-gold",
    "name": "Italian Bracelet - Vintage Gold",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "IB",
        "price": 37900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/italian-bracelet-vintage-gold-1.jpg"
    ],
    "featuredAsset": "seed/italian-bracelet-vintage-gold-1.jpg"
  },
  {
    "slug": "snake-chain",
    "name": "Snake chain",
    "description": "<p>18k gold plated </p><p>Anti tarnish </p><p>Waterproof</p>",
    "variants": [
      {
        "sku": "MSC",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/snake-chain-1.jpg"
    ],
    "featuredAsset": "seed/snake-chain-1.jpg"
  },
  {
    "slug": "baby-size-bracelet-2",
    "name": "Baby size bracelet -2",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BB2",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-size-bracelet-2-1.jpg"
    ],
    "featuredAsset": "seed/baby-size-bracelet-2-1.jpg"
  },
  {
    "slug": "baby-size-bracelet-7",
    "name": "Baby size bracelet -7",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BB7",
        "price": 34900,
        "options": [
          "349",
          "349"
        ],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-size-bracelet-7-1.jpg"
    ],
    "featuredAsset": "seed/baby-size-bracelet-7-1.jpg"
  },
  {
    "slug": "spiral-hoops-2",
    "name": "Spiral Hoops",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "SH",
        "price": 19900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/spiral-hoops-2-1.jpg"
    ],
    "featuredAsset": "seed/spiral-hoops-2-1.jpg"
  },
  {
    "slug": "evil-eye-bracelet",
    "name": "Evil eye bracelet",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "EEB",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/evil-eye-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/evil-eye-bracelet-1.jpg"
  },
  {
    "slug": "sea-charms-necklace",
    "name": "Sea Charms Necklace",
    "description": "<p>Anti tarnish </p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "SCN",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/sea-charms-necklace-1.jpg"
    ],
    "featuredAsset": "seed/sea-charms-necklace-1.jpg"
  },
  {
    "slug": "luxe-diamond-bracelet",
    "name": "Luxe diamond bracelet",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "LDB",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/luxe-diamond-bracelet-1.jpg"
    ],
    "featuredAsset": "seed/luxe-diamond-bracelet-1.jpg"
  },
  {
    "slug": "baby-size-bracelet-3",
    "name": "Baby size bracelet -3",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BB3",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-size-bracelet-3-1.jpg"
    ],
    "featuredAsset": "seed/baby-size-bracelet-3-1.jpg"
  },
  {
    "slug": "baby-size-bracelet-5",
    "name": "Baby size bracelet -5",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "BB5",
        "price": 34900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/baby-size-bracelet-5-1.jpg"
    ],
    "featuredAsset": "seed/baby-size-bracelet-5-1.jpg"
  },
  {
    "slug": "flora-earrings",
    "name": "Flora Earrings",
    "description": "<p>Anti tarnish</p><p>Waterproof</p><p>Hypoallergenic</p>",
    "variants": [
      {
        "sku": "FEz",
        "price": 29900,
        "options": [],
        "assets": []
      }
    ],
    "assetIds": [
      "seed/flora-earrings-1.jpg"
    ],
    "featuredAsset": "seed/flora-earrings-1.jpg"
  }
];

/**
 * Determine category for a product based on its slug
 */
function getProductCategory(productSlug: string): string | null {
    for (const [category, slugs] of Object.entries(PRODUCT_CATEGORY_MAPPING)) {
        if (slugs.includes(productSlug)) {
            return category;
        }
    }
    return null;
}

/**
 * Extract facet values from product description and name
 */
function extractFacetValues(product: any): { [facetCode: string]: string[] } {
    const facetValues: { [facetCode: string]: string[] } = {};
    const description = product.description?.toLowerCase() || '';
    const name = product.name?.toLowerCase() || '';
    const content = `${description} ${name}`;
    
    // Material facet
    if (content.includes('18k gold plated')) facetValues.material = ['18k-gold-plated'];
    else if (content.includes('rose gold')) facetValues.material = ['rose-gold'];
    else if (content.includes('white gold')) facetValues.material = ['white-gold'];
    else if (content.includes('silver')) facetValues.material = ['silver'];
    
    // Features facet
    const features = [];
    if (content.includes('anti tarnish')) features.push('anti-tarnish');
    if (content.includes('waterproof')) features.push('waterproof');
    if (content.includes('hypoallergenic')) features.push('hypoallergenic');
    if (content.includes('adjustable')) features.push('adjustable');
    if (features.length > 0) facetValues.features = features;
    
    // Style facet (based on name patterns)
    if (name.includes('mini') || name.includes('baby')) facetValues.style = ['minimalist'];
    else if (name.includes('luxe') || name.includes('statement')) facetValues.style = ['statement'];
    else if (name.includes('vintage') || name.includes('roman')) facetValues.style = ['vintage'];
    else facetValues.style = ['modern'];
    
    // Price range facet (based on price)
    const price = product.variants?.[0]?.price || 0;
    if (price < 20000) facetValues['price-range'] = ['under-200'];
    else if (price < 30000) facetValues['price-range'] = ['200-300'];
    else if (price < 40000) facetValues['price-range'] = ['300-400'];
    else facetValues['price-range'] = ['above-400'];
    
    // Color facet
    if (content.includes('gold') && !content.includes('rose') && !content.includes('white')) {
        facetValues.color = ['gold'];
    } else if (content.includes('rose gold')) {
        facetValues.color = ['rose-gold'];
    } else if (content.includes('silver') || content.includes('white')) {
        facetValues.color = ['silver'];
    }
    
    return facetValues;
}

/**
 * Setup facets and categories, then import all products
 */
async function setupAndSeedProducts() {
    console.log('🏷️ Setting up categories, facets, and seeding products...');
    
    try {
        const app = await bootstrap(vendureConfig);
        const connection = app.get(TransactionalConnection);
        
        await connection.withTransaction(async ctx => {
            // Get services
            const collectionService = app.get(CollectionService);
            const facetService = app.get(FacetService);
            const facetValueService = app.get(FacetValueService);
            const productService = app.get(ProductService);
            const variantService = app.get(ProductVariantService);
            const assetService = app.get(AssetService);
            const requestContextService = app.get(RequestContextService);
            const channelService = app.get(ChannelService);

            const defaultChannel = await channelService.getDefaultChannel();
            const adminCtx = await requestContextService.create({
                apiType: 'admin',
                channelOrToken: defaultChannel,
                languageCode: LanguageCode.en,
                isAuthorized: true,
            } as any);

            // Step 1: Create facets and facet values (sequentially to avoid race conditions)
            console.log('🎯 Creating facets sequentially...');
            const createdFacets: { [key: string]: any } = {};
            const facetValuesMap = new Map<string, any>();
            
            for (const facetData of FACETS) {
                try {
                    // Check if facet already exists
                    const existingFacets = await facetService.findAll(ctx);
                    let facet = existingFacets.items.find(f => f.code === facetData.code);
                    
                    if (!facet) {
                        facet = await facetService.create(ctx, {
                            code: facetData.code,
                            isPrivate: false,
                            translations: [
                                {
                                    languageCode: LanguageCode.en,
                                    name: facetData.name
                                }
                            ],
                            values: facetData.values.map(value => ({
                                code: value.toLowerCase().replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-'),
                                translations: [
                                    {
                                        languageCode: LanguageCode.en,
                                        name: value
                                    }
                                ]
                            }))
                        });
                        console.log(`✅ Created facet: ${facetData.name}`);
                    } else {
                        console.log(`ℹ️ Facet already exists: ${facetData.name}`);
                        // For existing facets, we need to fetch the full facet with relations
                        facet = await facetService.findOne(ctx, facet.id, ['values']);
                    }
                    
                    // Verify facet has ID before proceeding
                    if (!facet || !facet.id) {
                        console.error(`❌ Facet creation failed - no ID returned for ${facetData.name}`);
                        continue; // Skip this facet and continue with the next one
                    }
                    
                    // Store facet values for later use
                    if (facet.values && Array.isArray(facet.values)) {
                        facet.values.forEach((fv: any) => {
                            if (fv && fv.code) {
                                facetValuesMap.set(fv.code, fv);
                            }
                        });
                        createdFacets[facetData.code] = facet;
                    } else {
                        console.warn(`⚠️ Facet values not populated for: ${facetData.name}`);
                        createdFacets[facetData.code] = facet;
                    }
                } catch (error: any) {
                    console.error(`❌ Error creating facet ${facetData.name}:`, error.message);
                    // Continue with next facet instead of stopping the process
                    continue;
                }
            }
            
            // Step 2: Create collections (categories) in parallel
            console.log('📂 Creating collections in parallel...');
            const collectionsMap = new Map();
            
            const collectionPromises = CATEGORIES.map(async (categoryData) => {
                try {
                    // Check if collection already exists
                    const existingCollections = await collectionService.findAll(ctx);
                    let collection = existingCollections.items.find(c => 
                        c.slug === categoryData.slug || 
                        c.translations.some(t => t.name === categoryData.name)
                    );
                    
                    if (!collection) {
                        collection = await collectionService.create(ctx, {
                            translations: [
                                {
                                    languageCode: LanguageCode.en,
                                    name: categoryData.name,
                                    slug: categoryData.slug,
                                    description: categoryData.description || ''
                                }
                            ],
                            filters: [
                                {
                                    code: 'facet-value-filter',
                                    arguments: [
                                        {
                                            name: 'facetValueIds',
                                            value: '[]'
                                        },
                                        {
                                            name: 'containsAny',
                                            value: 'false'
                                        }
                                    ]
                                }
                            ]
                        });
                        console.log(`✅ Created collection: ${categoryData.name}`);
                    } else {
                        console.log(`ℹ️ Collection already exists: ${categoryData.name}`);
                    }
                    
                    collectionsMap.set(categoryData.slug, collection);
                    return { success: true, categoryData, collection };
                } catch (error: any) {
                    console.error(`❌ Error creating collection ${categoryData.name}:`, error.message);
                    return { success: false, categoryData, error };
                }
            });

            await Promise.all(collectionPromises);

            // Step 3: Import products in batches (parallel processing)
            console.log(`📥 Importing ${SEED_PRODUCTS.length} products in parallel batches...`);
            const BATCH_SIZE = 5; // Process 5 products at a time to avoid overwhelming the system
            let successCount = 0;
            let errorCount = 0;

            for (let i = 0; i < SEED_PRODUCTS.length; i += BATCH_SIZE) {
                const batch = SEED_PRODUCTS.slice(i, i + BATCH_SIZE);
                console.log(`\n🔄 Processing batch ${Math.floor(i/BATCH_SIZE) + 1}/${Math.ceil(SEED_PRODUCTS.length/BATCH_SIZE)} (${batch.length} products)...`);
                
                const productPromises = batch.map(async (productData, batchIndex) => {
                    const globalIndex = i + batchIndex;
                    try {
                        console.log(`🔍 Processing product ${globalIndex + 1}/${SEED_PRODUCTS.length}: ${productData.name}`);
                        
                        // Check if product already exists
                        const existing = await productService.findAll(adminCtx, {
                            filter: { slug: { eq: productData.slug } }
                        });

                        if (existing.items.length > 0) {
                            console.log(`ℹ️ Product already exists: ${productData.name}`);
                            return { success: true, skipped: true, productData };
                        }

                        // Determine category and facets
                        const categorySlug = getProductCategory(productData.slug);
                        const productFacetValues = extractFacetValues(productData);
                        const facetValueIds: string[] = [];
                        
                        // Map facet values to IDs
                        for (const [facetCode, values] of Object.entries(productFacetValues)) {
                            for (const value of values) {
                                const facetValue = facetValuesMap.get(value);
                                if (facetValue) {
                                    facetValueIds.push(facetValue.id);
                                }
                            }
                        }

                        // Create product
                        const product = await productService.create(adminCtx, {
                            translations: [
                                {
                                    languageCode: LanguageCode.en,
                                    name: productData.name,
                                    slug: productData.slug,
                                    description: productData.description || ''
                                }
                            ],
                            facetValueIds: facetValueIds
                        });

                        console.log(`✅ Created product: ${productData.name}`);
                        if (categorySlug) {
                            console.log(`📂 Category: ${categorySlug}`);
                        }
                        if (facetValueIds.length > 0) {
                            console.log(`🎯 Applied ${facetValueIds.length} facet values`);
                        }

                        // Add assets
                        await attachLocalAssets({
                            adminCtx,
                            assetService,
                            productService,
                            productId: String(product.id),
                            seed: productData
                        });

                        // Create variants
                        for (const [variantIndex, variantData] of productData.variants.entries()) {
                            const variant = await variantService.create(adminCtx, [
                                {
                                    productId: product.id,
                                    sku: variantData.sku || `${productData.slug}-${variantIndex + 1}`,
                                    price: variantData.price,
                                    translations: [
                                        {
                                            languageCode: LanguageCode.en,
                                            name: productData.name
                                        }
                                    ],
                                    assetIds: variantData.assets || [],
                                    stockOnHand: 100
                                }
                            ]);
                            console.log(`✅ Created variant: ${variantData.sku || 'default'} - ₹${variantData.price / 100}`);
                        }

                        return { success: true, productData };

                    } catch (error: any) {
                        console.error(`❌ Error creating product ${productData.name}:`, error.message);
                        return { success: false, productData, error };
                    }
                });

                // Wait for all products in this batch to complete
                const batchResults = await Promise.all(productPromises);
                
                // Count results
                batchResults.forEach(result => {
                    if (result.success) {
                        if (!result.skipped) successCount++;
                    } else {
                        errorCount++;
                    }
                });

                console.log(`✅ Batch ${Math.floor(i/BATCH_SIZE) + 1} completed: ${batchResults.filter(r => r.success).length}/${batch.length} successful`);
            }

            console.log(`\n🎉 Setup and import completed!`);
            console.log(`📊 Summary:`);
            console.log(`   • ${Object.keys(createdFacets).length} facets processed`);
            console.log(`   • ${collectionsMap.size} collections processed`);
            console.log(`   • ${successCount} products imported successfully`);
            console.log(`   • ${errorCount} products failed to import`);
        });
        
        await app.close();
        
    } catch (error) {
        console.error('❌ Error during setup and seeding:', error);
        process.exit(1);
    }
}

/**
 * Detect MIME type from file extension
 */
function detectMime(filename: string): string {
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

/**
 * Attach local assets to a product
 */
async function attachLocalAssets(args: { 
    adminCtx: any; 
    assetService: AssetService; 
    productService: ProductService; 
    productId: string; 
    seed: any; 
}) {
    const { adminCtx, assetService, productService, productId, seed } = args;
    const desiredRelPaths: string[] = Array.isArray(seed.assetIds) ? seed.assetIds.filter((a: string) => !/^https?:/i.test(a)) : [];
    if (desiredRelPaths.length === 0) return;

    const createdAssetIds: string[] = [];
    for (const rel of desiredRelPaths) {
        try {
            const abs = path.join(__dirname, '../../static/assets', rel.replace(/^\/+/, ''));
            if (!fs.existsSync(abs)) {
                console.log('   ⚠️ Local asset not found, skipping', rel);
                continue;
            }
            const filename = path.basename(abs);
            const mimeType = detectMime(filename);
            console.log('   ⬆️ Uploading asset', rel);
            
            const assetResult = await (assetService as any).create(adminCtx, {
                file: {
                    createReadStream: () => fs.createReadStream(abs),
                    filename,
                    mimetype: mimeType,
                },
            });
            
            if (assetResult?.id) createdAssetIds.push(assetResult.id);
        } catch (ae: any) {
            console.log('   ⚠️ Asset upload failed (continuing):', ae?.message || ae);
        }
    }
    
    if (createdAssetIds.length) {
        try {
            await productService.update(adminCtx, {
                id: productId,
                assetIds: createdAssetIds,
                featuredAssetId: createdAssetIds[0],
            } as any);
            console.log(`   🖼️ Attached ${createdAssetIds.length} asset(s)`);
        } catch (ue: any) {
            console.log('   ⚠️ Failed attaching assets:', ue?.message || ue);
        }
    }
}

// Run the script
if (require.main === module) {
    setupAndSeedProducts();
}
