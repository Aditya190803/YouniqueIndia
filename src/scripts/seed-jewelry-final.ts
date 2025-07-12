import { 
    bootstrap, 
    FacetService, 
    FacetValueService, 
    ProductService, 
    ProductVariantService,
    CollectionService,
    AssetService,
    RequestContext,
    TransactionalConnection,
    LanguageCode,
    Permission,
    User,
    TaxCategoryService,
    Administrator,
    Asset,
    ZoneService,
    TaxRateService,
    CountryService,
    ChannelService,
    ProductOptionService,
    ProductOptionGroupService
} from '@vendure/core';
import { config } from '../vendure-config';
import * as https from 'https';
import * as fs from 'fs';
import * as path from 'path';

/**
 * Seeds the database with jewelry products, collections, and facets
 */
async function seedJewelryData() {
    console.log('💎 Seeding jewelry data...');

    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);

        // --- HARD RESET: Delete all existing data (products, variants, collections, facets, facet values, assets, etc.) ---
        // WARNING: This will remove all data from the main catalog tables. Adjust as needed for your use case.
        // Order of deletion matters due to foreign key constraints.
        console.log('🧹 Cleaning existing data...');
        
        // Helper function to safely delete from table if it exists
        const safeDelete = async (tableName: string) => {
            try {
                await connection.rawConnection.query(`DELETE FROM ${tableName}`);
                console.log(`✅ Cleaned ${tableName}`);
            } catch (error) {
                console.log(`⚠️  Table ${tableName} doesn't exist or already empty`);
            }
        };
        
        // Helper function to safely truncate table and reset sequence
        const safeTruncate = async (tableName: string) => {
            try {
                await connection.rawConnection.query(`TRUNCATE TABLE ${tableName} RESTART IDENTITY CASCADE`);
                console.log(`✅ Truncated ${tableName} with cascade`);
            } catch (error) {
                console.log(`⚠️  Could not truncate ${tableName}, trying DELETE instead`);
                await safeDelete(tableName);
            }
        };
        
        // Helper function to disable foreign key checks temporarily
        const disableForeignKeyChecks = async () => {
            try {
                // Get all foreign key constraints
                const constraints = await connection.rawConnection.query(`
                    SELECT 
                        tc.constraint_name, 
                        tc.table_name, 
                        kcu.column_name, 
                        ccu.table_name AS foreign_table_name,
                        ccu.column_name AS foreign_column_name 
                    FROM 
                        information_schema.table_constraints AS tc 
                        JOIN information_schema.key_column_usage AS kcu
                          ON tc.constraint_name = kcu.constraint_name
                        JOIN information_schema.constraint_column_usage AS ccu
                          ON ccu.constraint_name = tc.constraint_name
                    WHERE constraint_type = 'FOREIGN KEY' AND tc.table_schema='public'
                        AND tc.table_name IN ('facet_value', 'product_variant_facet_values_facet_value', 'product_facet_values_facet_value')
                `);
                
                // Drop foreign key constraints temporarily
                for (const constraint of constraints) {
                    try {
                        await connection.rawConnection.query(
                            `ALTER TABLE ${constraint.table_name} DROP CONSTRAINT IF EXISTS ${constraint.constraint_name}`
                        );
                        console.log(`🔓 Dropped constraint ${constraint.constraint_name}`);
                    } catch (error) {
                        console.log(`⚠️  Could not drop constraint ${constraint.constraint_name}`);
                    }
                }
            } catch (error) {
                console.log('⚠️  Could not disable foreign key checks, proceeding with normal deletion');
            }
        };
        
        // Helper function to reset ID sequences
        const resetSequence = async (tableName: string, sequenceName: string) => {
            try {
                await connection.rawConnection.query(`ALTER SEQUENCE ${sequenceName} RESTART WITH 1`);
                console.log(`✅ Reset sequence for ${tableName}`);
            } catch (error) {
                console.log(`⚠️  Could not reset sequence for ${tableName}`);
            }
        };
        
        // Temporarily disable foreign key checks for thorough cleanup
        await disableForeignKeyChecks();
        
        // Delete in correct order to avoid foreign key constraint issues
        // Start with junction tables first
        await safeDelete('product_variant_facet_values_facet_value');
        await safeDelete('product_facet_values_facet_value');
        await safeDelete('product_variant_facet_value');
        await safeDelete('product_facet_value');
        await safeDelete('collection_product');
        await safeDelete('collection_asset');
        await safeDelete('product_asset');
        
        // Then delete the main entities
        await safeDelete('product_variant');
        await safeDelete('product');
        await safeDelete('collection');
        await safeDelete('asset');
        await safeDelete('facet_value');
        await safeDelete('facet');
        
        // Reset ID sequences to start from 1
        await resetSequence('facet', 'facet_id_seq');
        await resetSequence('facet_value', 'facet_value_id_seq');
        await resetSequence('product', 'product_id_seq');
        await resetSequence('product_variant', 'product_variant_id_seq');
        await resetSequence('collection', 'collection_id_seq');
        await resetSequence('asset', 'asset_id_seq');

        console.log('🧹 Database cleaning completed.');

        // --- Ensure Tax Zone and Tax Rate exist and are assigned to the default channel ---
        const zoneService = app.get(ZoneService);
        const taxRateService = app.get(TaxRateService);
        const countryService = app.get(CountryService);
        const channelService = app.get(ChannelService);

        // Create a temporary context for initial setup
        const tempCtx = await createSuperAdminContext(connection);

        // Find or create India country
        let india = await countryService.findOneByCode(tempCtx, 'IN');
        if (!india) {
            india = await countryService.create(tempCtx, {
                code: 'IN',
                enabled: true,
                translations: [{ languageCode: LanguageCode.en, name: 'India' }],
            });
        }

        // Find or create "India" zone
        let indiaZone = (await zoneService.findAll(tempCtx, { filter: { name: { eq: 'India' } } })).items[0];
        if (!indiaZone) {
            indiaZone = await zoneService.create(tempCtx, {
                name: 'India',
                memberIds: [india.id],
            });
        }

        // Find or create a default tax rate for India
        // Use the taxCategoryService already declared below for consistency
        const allTaxCategories = await app.get(TaxCategoryService).findAll(tempCtx);
        const defaultTaxCategoryId = allTaxCategories.items[0]?.id;
        let indiaTaxRate = (await taxRateService.findAll(tempCtx, { filter: { name: { eq: 'GST 18%' } } })).items[0];
        if (!indiaTaxRate) {
            indiaTaxRate = await taxRateService.create(tempCtx, {
                name: 'GST 18%',
                enabled: true,
                value: 18,
                categoryId: defaultTaxCategoryId,
                zoneId: indiaZone.id,
                customerGroupId: undefined,
            });
        }

        // Assign India zone as default tax zone to the default channel
        const channelRepo = connection.getRepository('Channel');
        const defaultChannel = await channelRepo.findOne({ where: { code: '__default_channel__' } });
        if (defaultChannel) {
            defaultChannel.defaultTaxZoneId = indiaZone.id;
            await channelRepo.save(defaultChannel);
            console.log('✅ Assigned India tax zone to default channel');
            
            // Also ensure the channel has the zone in its availableZones
            const channelZoneRepo = connection.getRepository('channel_available_zones_zone');
            try {
                await channelZoneRepo.save({
                    channelId: defaultChannel.id,
                    zoneId: indiaZone.id
                });
                console.log('✅ Added India zone to channel available zones');
            } catch (error) {
                // Might already exist, that's fine
                console.log('ℹ️  India zone already in channel available zones');
            }
        }

        // --- End Tax Zone/Rate setup ---

        // Create a superadmin context for operations (after tax zone setup)
        const ctx = await createSuperAdminContext(connection);

        const facetService = app.get(FacetService);
        const facetValueService = app.get(FacetValueService);
        const productService = app.get(ProductService);
        const productVariantService = app.get(ProductVariantService);
        const collectionService = app.get(CollectionService);
        const taxCategoryService = app.get(TaxCategoryService);
        const assetService = app.get(AssetService);

        console.log('📸 Downloading product images...');
        const downloadedImages = await downloadJewelryImages();
            
        console.log('🏷️  Creating jewelry facets...');

        // Create Material facet
        const materialFacet = await facetService.create(ctx, {
            code: 'material',
            isPrivate: false,
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Material'
                }
            ]
        });
        
        console.log('✅ Created material facet:', materialFacet.id);
        
        // Create material values
        const goldValue = await facetValueService.create(ctx, materialFacet, {
            code: 'gold',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Gold'
                }
            ]
        });
        
        const silverValue = await facetValueService.create(ctx, materialFacet, {
            code: 'silver',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Silver'
                }
            ]
        });
        
        const platinumValue = await facetValueService.create(ctx, materialFacet, {
            code: 'platinum',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Platinum'
                }
            ]
        });
        
        // Create Gemstone facet
        const gemstoneFacet = await facetService.create(ctx, {
            code: 'gemstone',
            isPrivate: false,
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Gemstone'
                }
            ]
        });
        
        console.log('✅ Created gemstone facet:', gemstoneFacet.id);
        
        // Create gemstone values
        const diamondValue = await facetValueService.create(ctx, gemstoneFacet, {
            code: 'diamond',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Diamond'
                }
            ]
        });
        
        const rubyValue = await facetValueService.create(ctx, gemstoneFacet, {
            code: 'ruby',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Ruby'
                }
            ]
        });
        
        const emeraldValue = await facetValueService.create(ctx, gemstoneFacet, {
            code: 'emerald',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Emerald'
                }
            ]
        });
        
        const sapphireValue = await facetValueService.create(ctx, gemstoneFacet, {
            code: 'sapphire',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Sapphire'
                }
            ]
        });
        
        // Create Category facet
        const categoryFacet = await facetService.create(ctx, {
            code: 'category',
            isPrivate: false,
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Category'
                }
            ]
        });
        
        console.log('✅ Created category facet:', categoryFacet.id);
        
        // Create category values
        const necklaceValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'necklace',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Necklace'
                }
            ]
        });
        
        const braceletValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'bracelet',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Bracelet'
                }
            ]
        });
        
        const earringValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'earring',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Earring'
                }
            ]
        });
        
        const ringValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'ring',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Ring'
                }
            ]
        });
        
        const ankletsValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'anklets',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Anklets'
                }
            ]
        });
        
        const hairAccessoriesValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'hair-accessories',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Hair Accessories'
                }
            ]
        });
        
        const mensJewelleryValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'mens-jewellery',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Mens Jewellery'
                }
            ]
        });
        
        const giftsValue = await facetValueService.create(ctx, categoryFacet, {
            code: 'gifts',
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Gifts'
                }
            ]
        });
        
        console.log('🏪 Creating jewelry collections...');
        
        // Create main collections for each category
        const necklaceCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Necklaces',
                    slug: 'necklaces',
                    description: 'Beautiful necklaces for every occasion'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${necklaceValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        const braceletCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Bracelets',
                    slug: 'bracelets',
                    description: 'Elegant bracelets for every style'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${braceletValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        const earringCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Earrings',
                    slug: 'earrings',
                    description: 'Stunning earrings for every occasion'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${earringValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        const ringCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Rings',
                    slug: 'rings',
                    description: 'Beautiful rings for every occasion'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${ringValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        const ankletsCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Anklets',
                    slug: 'anklets',
                    description: 'Traditional and modern anklets'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${ankletsValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        const hairAccessoriesCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Hair Accessories',
                    slug: 'hair-accessories',
                    description: 'Beautiful hair accessories and jewelry'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${hairAccessoriesValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        const mensJewelleryCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Mens Jewellery',
                    slug: 'mens-jewellery',
                    description: 'Stylish jewelry for men'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${mensJewelleryValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        const giftsCollection = await collectionService.create(ctx, {
            translations: [
                {
                    languageCode: LanguageCode.en,
                    name: 'Gifts',
                    slug: 'gifts',
                    description: 'Perfect jewelry gifts for special occasions'
                }
            ],
            filters: [
                {
                    code: 'facet-value-filter',
                    arguments: [
                        { name: 'facetValueIds', value: `["${giftsValue.id}"]` }
                    ]
                }
            ],
            isPrivate: false,
            featuredAssetId: undefined
        });
        
        console.log('� Creating more jewelry collections...');
        
        // Create additional collections
        const goldJewelryCollection = await collectionService.create(ctx, {
                translations: [
                    {
                        languageCode: LanguageCode.en,
                        name: 'Gold Jewelry',
                        slug: 'gold-jewelry',
                        description: 'Exquisite gold jewelry collection featuring traditional and contemporary designs'
                    }
                ],
                filters: [
                    {
                        code: 'facet-value-filter',
                        arguments: [
                            {
                                name: 'facetValueIds',
                                value: `["${goldValue.id}"]`
                            },
                            {
                                name: 'containsAny',
                                value: 'false'
                            }
                        ]
                    }
                ],
                isPrivate: false
            });
            
            const diamondCollection = await collectionService.create(ctx, {
                translations: [
                    {
                        languageCode: LanguageCode.en,
                        name: 'Diamond Jewelry',
                        slug: 'diamond-jewelry',
                        description: 'Stunning diamond jewelry collection with certified diamonds'
                    }
                ],
                filters: [
                    {
                        code: 'facet-value-filter',
                        arguments: [
                            {
                                name: 'facetValueIds',
                                value: `["${diamondValue.id}"]`
                            },
                            {
                                name: 'containsAny',
                                value: 'false'
                            }
                        ]
                    }
                ],
                isPrivate: false
            });
            
            console.log('💍 Creating jewelry products...');
            
            // Get tax category
            const taxCategories = await taxCategoryService.findAll(ctx);
            const defaultTaxCategory = taxCategories.items[0];
            
            // Create comprehensive jewelry products for all categories
            const products = [
                // RINGS
                {
                    name: 'Classic Gold Diamond Ring',
                    slug: 'classic-gold-diamond-ring',
                    description: 'A timeless classic gold ring featuring a brilliant cut diamond. Perfect for engagements and special occasions.',
                    price: 7500000, // ₹75,000 in cents
                    sku: 'GDR001',
                    facetValues: [goldValue.id, diamondValue.id, ringValue.id]
                },
                {
                    name: 'Traditional Gold Wedding Ring Set',
                    slug: 'traditional-gold-wedding-ring-set',
                    description: 'Beautiful traditional gold wedding ring set for couples. Crafted with intricate Indian designs.',
                    price: 4500000, // ₹45,000 in cents
                    sku: 'GWR001',
                    facetValues: [goldValue.id, ringValue.id]
                },
                {
                    name: 'Silver Statement Ring',
                    slug: 'silver-statement-ring',
                    description: 'Bold silver statement ring with contemporary design. Perfect for modern style.',
                    price: 1800000, // ₹18,000 in cents
                    sku: 'SSR001',
                    facetValues: [silverValue.id, ringValue.id]
                },
                
                // NECKLACES
                {
                    name: 'Elegant Silver Ruby Necklace',
                    slug: 'elegant-silver-ruby-necklace',
                    description: 'An elegant silver necklace adorned with genuine rubies. A perfect statement piece for any outfit.',
                    price: 3500000, // ₹35,000 in cents
                    sku: 'SRN001',
                    facetValues: [silverValue.id, rubyValue.id, necklaceValue.id]
                },
                {
                    name: 'Gold Pendant Necklace',
                    slug: 'gold-pendant-necklace',
                    description: 'Elegant gold pendant necklace with intricate design. Perfect for daily wear and special occasions.',
                    price: 2800000, // ₹28,000 in cents
                    sku: 'GPN001',
                    facetValues: [goldValue.id, necklaceValue.id]
                },
                {
                    name: 'Diamond Tennis Necklace',
                    slug: 'diamond-tennis-necklace',
                    description: 'Luxurious diamond tennis necklace with brilliant cut diamonds. The epitome of elegance.',
                    price: 15000000, // ₹150,000 in cents
                    sku: 'DTN001',
                    facetValues: [goldValue.id, diamondValue.id, necklaceValue.id]
                },
                {
                    name: 'Traditional Gold Chain',
                    slug: 'traditional-gold-chain',
                    description: 'Classic gold chain with traditional Indian craftsmanship. Versatile for daily wear.',
                    price: 3200000, // ₹32,000 in cents
                    sku: 'TGC001',
                    facetValues: [goldValue.id, necklaceValue.id]
                },
                
                // EARRINGS
                {
                    name: 'Platinum Emerald Earrings',
                    slug: 'platinum-emerald-earrings',
                    description: 'Sophisticated platinum earrings featuring emerald gemstones. Luxury and elegance combined.',
                    price: 12500000, // ₹125,000 in cents
                    sku: 'PEE001',
                    facetValues: [platinumValue.id, emeraldValue.id, earringValue.id]
                },
                {
                    name: 'Silver Diamond Stud Earrings',
                    slug: 'silver-diamond-stud-earrings',
                    description: 'Classic silver stud earrings with sparkling diamonds. Perfect for everyday elegance.',
                    price: 2500000, // ₹25,000 in cents
                    sku: 'SDE001',
                    facetValues: [silverValue.id, diamondValue.id, earringValue.id]
                },
                {
                    name: 'Gold Hoop Earrings',
                    slug: 'gold-hoop-earrings',
                    description: 'Classic gold hoop earrings with a modern twist. Versatile and stylish for any occasion.',
                    price: 1500000, // ₹15,000 in cents
                    sku: 'GHE001',
                    facetValues: [goldValue.id, earringValue.id]
                },
                {
                    name: 'Traditional Jhumka Earrings',
                    slug: 'traditional-jhumka-earrings',
                    description: 'Beautiful traditional jhumka earrings with intricate Indian designs and gold finish.',
                    price: 2200000, // ₹22,000 in cents
                    sku: 'TJE001',
                    facetValues: [goldValue.id, earringValue.id]
                },
                
                // BRACELETS
                {
                    name: 'Gold Sapphire Tennis Bracelet',
                    slug: 'gold-sapphire-tennis-bracelet',
                    description: 'A stunning gold tennis bracelet with blue sapphires. Perfect for special occasions.',
                    price: 8500000, // ₹85,000 in cents
                    sku: 'GSB001',
                    facetValues: [goldValue.id, sapphireValue.id, braceletValue.id]
                },
                {
                    name: 'Silver Charm Bracelet',
                    slug: 'silver-charm-bracelet',
                    description: 'Beautiful silver charm bracelet with multiple decorative charms. A perfect gift for loved ones.',
                    price: 1800000, // ₹18,000 in cents
                    sku: 'SCB001',
                    facetValues: [silverValue.id, braceletValue.id]
                },
                {
                    name: 'Gold Kada Bracelet',
                    slug: 'gold-kada-bracelet',
                    description: 'Traditional gold kada bracelet with ethnic Indian patterns. Symbol of strength and style.',
                    price: 4500000, // ₹45,000 in cents
                    sku: 'GKB001',
                    facetValues: [goldValue.id, braceletValue.id]
                },
                
                // ANKLETS
                {
                    name: 'Silver Anklet Chain',
                    slug: 'silver-anklet-chain',
                    description: 'Delicate silver anklet chain with traditional bell charms. Perfect for festivals and celebrations.',
                    price: 1200000, // ₹12,000 in cents
                    sku: 'SAC001',
                    facetValues: [silverValue.id, ankletsValue.id]
                },
                {
                    name: 'Gold Payal Anklet',
                    slug: 'gold-payal-anklet',
                    description: 'Traditional gold payal anklet with intricate designs. Classic Indian jewelry piece.',
                    price: 2800000, // ₹28,000 in cents
                    sku: 'GPA001',
                    facetValues: [goldValue.id, ankletsValue.id]
                },
                {
                    name: 'Beaded Anklet',
                    slug: 'beaded-anklet',
                    description: 'Beautiful beaded anklet with colorful stones and silver accents. Bohemian style.',
                    price: 800000, // ₹8,000 in cents
                    sku: 'BA001',
                    facetValues: [silverValue.id, ankletsValue.id]
                },
                
                // HAIR ACCESSORIES
                {
                    name: 'Gold Hair Pin Set',
                    slug: 'gold-hair-pin-set',
                    description: 'Elegant gold hair pin set with floral designs. Perfect for special occasions and weddings.',
                    price: 1500000, // ₹15,000 in cents
                    sku: 'GHPS001',
                    facetValues: [goldValue.id, hairAccessoriesValue.id]
                },
                {
                    name: 'Pearl Hair Comb',
                    slug: 'pearl-hair-comb',
                    description: 'Beautiful pearl hair comb with silver base. Adds elegance to any hairstyle.',
                    price: 1200000, // ₹12,000 in cents
                    sku: 'PHC001',
                    facetValues: [silverValue.id, hairAccessoriesValue.id]
                },
                {
                    name: 'Traditional Maang Tikka',
                    slug: 'traditional-maang-tikka',
                    description: 'Stunning traditional maang tikka with gold plating and precious stones.',
                    price: 3500000, // ₹35,000 in cents
                    sku: 'TMT001',
                    facetValues: [goldValue.id, hairAccessoriesValue.id]
                },
                
                // MENS JEWELLERY
                {
                    name: 'Gold Chain for Men',
                    slug: 'gold-chain-for-men',
                    description: 'Strong and stylish gold chain designed specifically for men. Perfect for daily wear.',
                    price: 4800000, // ₹48,000 in cents
                    sku: 'GCM001',
                    facetValues: [goldValue.id, mensJewelleryValue.id]
                },
                {
                    name: 'Silver Bracelet for Men',
                    slug: 'silver-bracelet-for-men',
                    description: 'Masculine silver bracelet with contemporary design. Ideal for modern men.',
                    price: 2200000, // ₹22,000 in cents
                    sku: 'SBM001',
                    facetValues: [silverValue.id, mensJewelleryValue.id]
                },
                {
                    name: 'Mens Gold Ring',
                    slug: 'mens-gold-ring',
                    description: 'Bold gold ring for men with geometric patterns. Symbol of strength and style.',
                    price: 3800000, // ₹38,000 in cents
                    sku: 'MGR001',
                    facetValues: [goldValue.id, mensJewelleryValue.id]
                },
                
                // GIFTS
                {
                    name: 'Gift Set - Pearl Earrings & Necklace',
                    slug: 'gift-set-pearl-earrings-necklace',
                    description: 'Beautiful gift set featuring pearl earrings and matching necklace. Perfect for special occasions.',
                    price: 4200000, // ₹42,000 in cents
                    sku: 'GS001',
                    facetValues: [silverValue.id, giftsValue.id]
                },
                {
                    name: 'Anniversary Ring Set',
                    slug: 'anniversary-ring-set',
                    description: 'Elegant anniversary ring set with diamonds. Perfect gift for celebrating love.',
                    price: 9500000, // ₹95,000 in cents
                    sku: 'ARS001',
                    facetValues: [goldValue.id, diamondValue.id, giftsValue.id]
                },
                {
                    name: 'Birthday Jewelry Box',
                    slug: 'birthday-jewelry-box',
                    description: 'Curated jewelry box with multiple pieces including earrings, necklace, and bracelet.',
                    price: 5800000, // ₹58,000 in cents
                    sku: 'BJB001',
                    facetValues: [goldValue.id, giftsValue.id]
                }
            ];
            
            for (const productData of products) {
                console.log(`Creating product: ${productData.name}`);
                
                const product = await productService.create(ctx, {
                    translations: [
                        {
                            languageCode: LanguageCode.en,
                            name: productData.name,
                            slug: productData.slug,
                            description: productData.description
                        }
                    ],
                    facetValueIds: productData.facetValues,
                    enabled: true
                });
                
                // Add product image if available
                const imagePath = downloadedImages[productData.slug];
                if (imagePath) {
                    console.log(`  📷 Adding image for ${productData.name}...`);
                    try {
                        const asset = await createAssetFromFile(
                            assetService, 
                            ctx, 
                            imagePath, 
                            `${productData.slug}.jpg`
                        );
                        
                        if (asset) {
                            await productService.update(ctx, {
                                id: product.id,
                                featuredAssetId: asset.id,
                                assetIds: [asset.id]
                            });
                            console.log(`  ✅ Image added successfully`);
                        }
                    } catch (error) {
                        console.log(`  ⚠️  Failed to add image: ${error}`);
                    }
                }
                
                // Create a single default variant for each product
                await productVariantService.create(ctx, [
                    {
                        productId: product.id,
                        translations: [
                            {
                                languageCode: LanguageCode.en,
                                name: productData.name
                            }
                        ],
                        sku: productData.sku,
                        price: productData.price,
                        taxCategoryId: defaultTaxCategory?.id,
                        stockOnHand: 10,
                        useGlobalOutOfStockThreshold: true,
                        outOfStockThreshold: 0,
                        facetValueIds: productData.facetValues
                    }
                ]);
                
                console.log(`  ✅ Created product variant for ${productData.name}`);
            }
            
            console.log('🧹 Cleaning up temporary files...');
            // Clean up downloaded images
            const tempDir = path.join(process.cwd(), 'temp-images');
            if (fs.existsSync(tempDir)) {
                const files = fs.readdirSync(tempDir);
                for (const file of files) {
                    try {
                        fs.unlinkSync(path.join(tempDir, file));
                    } catch (error) {
                        console.log(`⚠️  Could not delete ${file}`);
                    }
                }
                try {
                    fs.rmdirSync(tempDir);
                    console.log('✅ Temporary files cleaned up');
                } catch (error) {
                    console.log('⚠️  Could not remove temp directory');
                }
            }
            
            console.log('✅ Jewelry data seeded successfully!');
            console.log(`Created ${products.length} products across all categories`);
            console.log('Created 8 category collections: Necklaces, Bracelets, Earrings, Rings, Anklets, Hair Accessories, Mens Jewellery, Gifts');
            console.log('Created material collections: Gold Jewelry, Diamond Jewelry');
            console.log('Created facets: Material, Gemstone, Category');
        
        // Give a moment for any background processes to complete
        console.log('🔄 Waiting for background processes to complete...');
        await new Promise(resolve => setTimeout(resolve, 3000));
        
        console.log('🚪 Closing application...');
        await app.close();
        console.log('✅ Application closed successfully');
        
    } catch (error) {
        console.error('❌ Error during jewelry seeding:', error);
        process.exit(1);
    }
}

async function createSuperAdminContext(connection: TransactionalConnection): Promise<RequestContext> {
    // Get the default channel with proper currency configuration
    const channel = await connection.getRepository('Channel').findOne({
        where: { code: '__default_channel__' },
        relations: ['defaultTaxZone']
    });
    
    if (!channel) {
        throw new Error('Default channel not found');
    }
    
    console.log('Creating admin context with channel currency:', channel.defaultCurrencyCode);
    console.log('Channel tax zone:', channel.defaultTaxZone?.name || 'No tax zone assigned');
    
    // Create a basic request context for seeding operations
    return new RequestContext({
        apiType: 'admin',
        isAuthorized: true,
        authorizedAsOwnerOnly: false,
        languageCode: LanguageCode.en,
        channel: channel as any,
        session: {} as any,
        req: undefined
    });
}

/**
 * Downloads an image from a URL and saves it locally
 */
async function downloadImage(url: string, filepath: string): Promise<boolean> {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(filepath);
        
        https.get(url, (response) => {
            if (response.statusCode === 200) {
                response.pipe(file);
                file.on('finish', () => {
                    file.close();
                    resolve(true);
                });
            } else {
                file.close();
                fs.unlink(filepath, () => {}); // Delete the file async
                reject(new Error(`Failed to download image: ${response.statusCode}`));
            }
        }).on('error', (err) => {
            file.close();
            fs.unlink(filepath, () => {}); // Delete the file async
            reject(err);
        });
    });
}

/**
 * Creates an asset from a local image file
 */
async function createAssetFromFile(
    assetService: AssetService, 
    ctx: RequestContext, 
    filePath: string, 
    filename: string
): Promise<any | null> {
    try {
        if (!fs.existsSync(filePath)) {
            console.log(`⚠️  File not found: ${filePath}`);
            return null;
        }

        const fileBuffer = fs.readFileSync(filePath);
        const mimeType = filename.endsWith('.jpg') || filename.endsWith('.jpeg') ? 'image/jpeg' : 'image/png';
        
        const result = await assetService.create(ctx, {
            file: {
                filename,
                mimetype: mimeType,
                createReadStream: () => {
                    const { Readable } = require('stream');
                    const stream = new Readable();
                    stream.push(fileBuffer);
                    stream.push(null);
                    return stream;
                }
            } as any
        });
        
        return result;
    } catch (error) {
        console.error(`Failed to create asset from ${filePath}:`, error);
        return null;
    }
}

/**
 * Downloads jewelry images from Unsplash and creates assets
 */
async function downloadJewelryImages(): Promise<{ [key: string]: string }> {
    console.log('📸 Downloading jewelry images...');
    
    // Create temp directory for images
    const tempDir = path.join(process.cwd(), 'temp-images');
    if (!fs.existsSync(tempDir)) {
        fs.mkdirSync(tempDir, { recursive: true });
    }
    
    const jewelryImages = {
        // Rings
        'classic-gold-diamond-ring': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&h=600&fit=crop',
        'traditional-gold-wedding-ring-set': 'https://images.unsplash.com/photo-1544376664-80b17f09d399?w=800&h=600&fit=crop',
        'silver-statement-ring': 'https://images.unsplash.com/photo-1617038220319-276d3cfab638?w=800&h=600&fit=crop',
        'mens-gold-ring': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&h=600&fit=crop',
        'anniversary-ring-set': 'https://images.unsplash.com/photo-1544376664-80b17f09d399?w=800&h=600&fit=crop',
        
        // Necklaces
        'elegant-silver-ruby-necklace': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&h=600&fit=crop',
        'gold-pendant-necklace': 'https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=800&h=600&fit=crop',
        'diamond-tennis-necklace': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&h=600&fit=crop',
        'traditional-gold-chain': 'https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=800&h=600&fit=crop',
        'gold-chain-for-men': 'https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=800&h=600&fit=crop',
        'gift-set-pearl-earrings-necklace': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&h=600&fit=crop',
        
        // Earrings
        'platinum-emerald-earrings': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop',
        'silver-diamond-stud-earrings': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop',
        'gold-hoop-earrings': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop',
        'traditional-jhumka-earrings': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop',
        
        // Bracelets
        'gold-sapphire-tennis-bracelet': 'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=800&h=600&fit=crop',
        'silver-charm-bracelet': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&h=600&fit=crop',
        'gold-kada-bracelet': 'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=800&h=600&fit=crop',
        'silver-bracelet-for-men': 'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=800&h=600&fit=crop',
        
        // Anklets
        'silver-anklet-chain': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&h=600&fit=crop',
        'gold-payal-anklet': 'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=800&h=600&fit=crop',
        'beaded-anklet': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&h=600&fit=crop',
        
        // Hair Accessories
        'gold-hair-pin-set': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop',
        'pearl-hair-comb': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop',
        'traditional-maang-tikka': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop',
        
        // Gifts
        'birthday-jewelry-box': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&h=600&fit=crop'
    };
    
    const downloadedImages: { [key: string]: string } = {};
    
    for (const [productSlug, imageUrl] of Object.entries(jewelryImages)) {
        try {
            const filename = `${productSlug}.jpg`;
            const filepath = path.join(tempDir, filename);
            
            console.log(`Downloading image for ${productSlug}...`);
            await downloadImage(imageUrl, filepath);
            downloadedImages[productSlug] = filepath;
            console.log(`✅ Downloaded: ${filename}`);
        } catch (error) {
            console.log(`⚠️  Failed to download image for ${productSlug}:`, error);
        }
    }
    
    return downloadedImages;
}

// Run the script
if (require.main === module) {
    seedJewelryData();
}
