import { createConnection, Connection } from 'typeorm';
import { config } from '../vendure-config';

async function addJewelryData() {
    console.log('Connecting to database...');
    
    let connection: Connection | undefined;
    try {
        connection = await createConnection(config.dbConnectionOptions);
        console.log('Database connected successfully');
        
        // Get the default channel ID
        const defaultChannel = await connection.query(`
            SELECT "id" FROM "channel" WHERE "code" = 'default' OR "id" = 1 LIMIT 1
        `);
        const channelId = defaultChannel[0]?.id || 1;
        
        // Get the default tax category ID
        const defaultTaxCategory = await connection.query(`
            SELECT "id" FROM "tax_category" LIMIT 1
        `);
        const taxCategoryId = defaultTaxCategory[0]?.id || 1;
        
        console.log(`Using channel ID: ${channelId}, tax category ID: ${taxCategoryId}`);
        
        // Add jewelry collections
        console.log('\n=== ADDING JEWELRY COLLECTIONS ===');
        
        const jewelryCollections = [
            { name: 'Necklace', slug: 'necklace', description: 'Beautiful necklaces for every occasion' },
            { name: 'Bracelet', slug: 'bracelet', description: 'Elegant bracelets and bangles' },
            { name: 'Earring', slug: 'earring', description: 'Stunning earrings to complement your style' },
            { name: 'Ring', slug: 'ring', description: 'Exquisite rings for special moments' },
            { name: 'Anklets', slug: 'anklets', description: 'Graceful anklets for traditional and modern wear' },
            { name: 'Hair Accessories', slug: 'hair-accessories', description: 'Beautiful hair accessories and jewelry' },
            { name: "Men's Jewellery", slug: 'mens-jewellery', description: 'Stylish jewelry for men' },
            { name: 'Gifts', slug: 'gifts', description: 'Perfect jewelry gifts for loved ones' },
        ];
        
        const collectionIds: { [key: string]: number } = {};
        
        for (const collection of jewelryCollections) {
            try {
                // Check if collection already exists
                const existingCollection = await connection.query(`
                    SELECT c.id FROM "collection" c
                    JOIN "collection_translation" ct ON c.id = ct.id
                    WHERE ct.slug = $1
                `, [collection.slug]);
                
                if (existingCollection.length > 0) {
                    console.log(`⚠️  Collection already exists: ${collection.name}`);
                    collectionIds[collection.slug] = existingCollection[0].id;
                    continue;
                }
                
                // Insert into collection table
                const result = await connection.query(`
                    INSERT INTO "collection" ("createdAt", "updatedAt", "isRoot", "position", "isPrivate", "filters", "inheritFilters")
                    VALUES (NOW(), NOW(), false, 0, false, '[]', true)
                    RETURNING "id"
                `);
                
                const collectionId = result[0].id;
                collectionIds[collection.slug] = collectionId;
                
                // Insert into collection_translation table
                await connection.query(`
                    INSERT INTO "collection_translation" ("createdAt", "updatedAt", "languageCode", "name", "slug", "description", "id")
                    VALUES (NOW(), NOW(), 'en', $1, $2, $3, $4)
                `, [collection.name, collection.slug, collection.description, collectionId]);
                
                // Add collection to channel
                await connection.query(`
                    INSERT INTO "collection_channels_channel" ("collectionId", "channelId")
                    VALUES ($1, $2)
                `, [collectionId, channelId]);
                
                console.log(`✓ Added collection: ${collection.name}`);
            } catch (error) {
                console.log(`❌ Error adding collection ${collection.name}:`, error instanceof Error ? error.message : String(error));
            }
        }
        
        // Add jewelry products
        console.log('\n=== ADDING JEWELRY PRODUCTS ===');
        
        const jewelryProducts = [
            { name: 'Gold Chain Necklace', slug: 'gold-chain-necklace', description: 'Elegant 18k gold chain necklace', price: 250000, sku: 'GCN001', collection: 'necklace' },
            { name: 'Pearl Strand Necklace', slug: 'pearl-strand-necklace', description: 'Classic pearl strand necklace', price: 180000, sku: 'PSN001', collection: 'necklace' },
            { name: 'Diamond Pendant Necklace', slug: 'diamond-pendant-necklace', description: 'Beautiful diamond pendant with chain', price: 550000, sku: 'DPN001', collection: 'necklace' },
            { name: 'Gold Bangle Set', slug: 'gold-bangle-set', description: 'Traditional gold bangle set of 4', price: 320000, sku: 'GBS001', collection: 'bracelet' },
            { name: 'Silver Charm Bracelet', slug: 'silver-charm-bracelet', description: 'Sterling silver charm bracelet', price: 120000, sku: 'SCB001', collection: 'bracelet' },
            { name: 'Gold Stud Earrings', slug: 'gold-stud-earrings', description: 'Simple gold stud earrings', price: 80000, sku: 'GSE001', collection: 'earring' },
            { name: 'Pearl Drop Earrings', slug: 'pearl-drop-earrings', description: 'Elegant pearl drop earrings', price: 150000, sku: 'PDE001', collection: 'earring' },
            { name: 'Gold Band Ring', slug: 'gold-band-ring', description: 'Classic gold band ring', price: 120000, sku: 'GBR001', collection: 'ring' },
            { name: 'Silver Statement Ring', slug: 'silver-statement-ring', description: 'Bold silver statement ring', price: 90000, sku: 'SSR001', collection: 'ring' },
            { name: 'Gold Anklet Chain', slug: 'gold-anklet-chain', description: 'Delicate gold anklet chain', price: 110000, sku: 'GAC001', collection: 'anklets' },
            { name: 'Gold Hair Pin Set', slug: 'gold-hair-pin-set', description: 'Elegant gold hair pin set', price: 65000, sku: 'GHP001', collection: 'hair-accessories' },
            { name: 'Gold Chain for Men', slug: 'gold-chain-men', description: 'Masculine gold chain for men', price: 350000, sku: 'GCM001', collection: 'mens-jewellery' },
            { name: 'Jewelry Gift Set', slug: 'jewelry-gift-set', description: 'Complete jewelry gift set', price: 450000, sku: 'JGS001', collection: 'gifts' },
        ];
        
        for (const product of jewelryProducts) {
            try {
                // Check if product already exists
                const existingProduct = await connection.query(`
                    SELECT p.id FROM "product" p
                    JOIN "product_translation" pt ON p.id = pt.id
                    WHERE pt.slug = $1
                `, [product.slug]);
                
                if (existingProduct.length > 0) {
                    console.log(`⚠️  Product already exists: ${product.name}`);
                    continue;
                }
                
                // Insert into product table
                const productResult = await connection.query(`
                    INSERT INTO "product" ("createdAt", "updatedAt", "deletedAt", "enabled")
                    VALUES (NOW(), NOW(), NULL, true)
                    RETURNING "id"
                `);
                
                const productId = productResult[0].id;
                
                // Insert into product_translation table
                await connection.query(`
                    INSERT INTO "product_translation" ("createdAt", "updatedAt", "languageCode", "name", "slug", "description", "id")
                    VALUES (NOW(), NOW(), 'en', $1, $2, $3, $4)
                `, [product.name, product.slug, product.description, productId]);
                
                // Add product to channel
                await connection.query(`
                    INSERT INTO "product_channels_channel" ("productId", "channelId")
                    VALUES ($1, $2)
                `, [productId, channelId]);
                
                // Create product variant
                const variantResult = await connection.query(`
                    INSERT INTO "product_variant" ("createdAt", "updatedAt", "deletedAt", "enabled", "sku", "outOfStockThreshold", "useGlobalOutOfStockThreshold", "trackInventory", "taxCategoryId", "productId")
                    VALUES (NOW(), NOW(), NULL, true, $1, 0, true, 'INHERIT', $2, $3)
                    RETURNING "id"
                `, [product.sku, taxCategoryId, productId]);
                
                const variantId = variantResult[0].id;
                
                // Insert variant translation
                await connection.query(`
                    INSERT INTO "product_variant_translation" ("createdAt", "updatedAt", "languageCode", "name", "id")
                    VALUES (NOW(), NOW(), 'en', $1, $2)
                `, [product.name, variantId]);
                
                // Add variant to channel
                await connection.query(`
                    INSERT INTO "product_variant_channels_channel" ("productVariantId", "channelId")
                    VALUES ($1, $2)
                `, [variantId, channelId]);
                
                // Add variant price
                await connection.query(`
                    INSERT INTO "product_variant_price" ("createdAt", "updatedAt", "price", "currencyCode", "channelId", "variant")
                    VALUES (NOW(), NOW(), $1, 'INR', $2, $3)
                `, [product.price, channelId, variantId]);
                
                // Add to collection if exists
                if (collectionIds[product.collection]) {
                    await connection.query(`
                        INSERT INTO "collection_product_variants_product_variant" ("collectionId", "productVariantId")
                        VALUES ($1, $2)
                    `, [collectionIds[product.collection], variantId]);
                }
                
                // Add to stock level
                const defaultStockLocation = await connection.query(`
                    SELECT "id" FROM "stock_location" LIMIT 1
                `);
                if (defaultStockLocation.length > 0) {
                    await connection.query(`
                        INSERT INTO "stock_level" ("createdAt", "updatedAt", "stockOnHand", "stockAllocated", "stockLocationId", "productVariantId")
                        VALUES (NOW(), NOW(), 100, 0, $1, $2)
                    `, [defaultStockLocation[0].id, variantId]);
                }
                
                console.log(`✓ Added product: ${product.name} (₹${product.price / 100})`);
            } catch (error) {
                console.log(`❌ Error adding product ${product.name}:`, error instanceof Error ? error.message : String(error));
            }
        }
        
        // Add promotions
        console.log('\n=== ADDING PROMOTIONS ===');
        
        const promotions = [
            {
                name: 'Free Shipping',
                description: 'Free shipping on all orders',
                couponCode: null,
                actions: '[{"code": "order_free_shipping", "arguments": []}]',
                conditions: '[]'
            },
            {
                name: '5% Off Above 999',
                description: '5% off on orders above ₹999',
                couponCode: 'SAVE5',
                actions: '[{"code": "order_percentage_discount", "arguments": [{"name": "discount", "value": "5"}]}]',
                conditions: '[{"code": "min_order_amount", "arguments": [{"name": "amount", "value": "99900"}, {"name": "taxInclusive", "value": "true"}]}]'
            }
        ];
        
        for (const promotion of promotions) {
            try {
                // Check if promotion already exists
                const existingPromotion = await connection.query(`
                    SELECT p.id FROM "promotion" p
                    JOIN "promotion_translation" pt ON p.id = pt.id
                    WHERE pt.name = $1
                `, [promotion.name]);
                
                if (existingPromotion.length > 0) {
                    console.log(`⚠️  Promotion already exists: ${promotion.name}`);
                    continue;
                }
                
                // Insert promotion
                const promoResult = await connection.query(`
                    INSERT INTO "promotion" ("createdAt", "updatedAt", "enabled", "startsAt", "endsAt", "couponCode", "actions", "conditions", "priorityScore")
                    VALUES (NOW(), NOW(), true, NOW(), NULL, $1, $2, $3, 0)
                    RETURNING "id"
                `, [promotion.couponCode, promotion.actions, promotion.conditions]);
                
                const promoId = promoResult[0].id;
                
                // Add promotion translation
                await connection.query(`
                    INSERT INTO "promotion_translation" ("createdAt", "updatedAt", "languageCode", "name", "description", "id")
                    VALUES (NOW(), NOW(), 'en', $1, $2, $3)
                `, [promotion.name, promotion.description, promoId]);
                
                // Add promotion to channel
                await connection.query(`
                    INSERT INTO "promotion_channels_channel" ("promotionId", "channelId")
                    VALUES ($1, $2)
                `, [promoId, channelId]);
                
                console.log(`✓ Added promotion: ${promotion.name}`);
            } catch (error) {
                console.log(`❌ Error adding promotion ${promotion.name}:`, error instanceof Error ? error.message : String(error));
            }
        }
        
        console.log('\n=== JEWELRY DATA SEEDING COMPLETED SUCCESSFULLY! ===');
        
    } catch (error) {
        console.error('Error:', error instanceof Error ? error.message : String(error));
    } finally {
        if (connection) {
            await connection.close();
            console.log('Database connection closed');
        }
    }
}

// Run the seeding
if (require.main === module) {
    addJewelryData();
}

export { addJewelryData };
