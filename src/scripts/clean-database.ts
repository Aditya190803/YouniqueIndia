import { 
    bootstrap, 
    TransactionalConnection,
} from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Completely cleans the database of all catalog data
 * Use this script when you want to start fresh
 */
async function cleanDatabase() {
    console.log('🧹 Starting complete database cleanup...');

    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);

        // Helper function to safely delete from table if it exists
        const safeDelete = async (tableName: string) => {
            try {
                const result = await connection.rawConnection.query(`DELETE FROM ${tableName}`);
                console.log(`✅ Cleaned ${tableName} (${result.affectedRows || 'unknown'} rows)`);
            } catch (error: any) {
                console.log(`⚠️  Table ${tableName} doesn't exist or already empty: ${error.message}`);
            }
        };

        // Helper function to safely truncate table and reset sequence
        const safeTruncate = async (tableName: string) => {
            try {
                await connection.rawConnection.query(`TRUNCATE TABLE ${tableName} RESTART IDENTITY CASCADE`);
                console.log(`✅ Truncated ${tableName} with cascade`);
            } catch (error: any) {
                console.log(`⚠️  Could not truncate ${tableName}: ${error.message}`);
                await safeDelete(tableName);
            }
        };

        // Helper function to reset ID sequences more thoroughly
        const resetSequenceThorough = async (tableName: string, sequenceName: string) => {
            try {
                // Get the current max ID in the table
                const result = await connection.rawConnection.query(`SELECT MAX(id) as max_id FROM ${tableName}`);
                const maxId = result[0]?.max_id || 0;
                
                if (maxId > 0) {
                    console.log(`⚠️  Table ${tableName} still has data (max ID: ${maxId}), clearing and resetting...`);
                    await safeDelete(tableName);
                }
                
                await connection.rawConnection.query(`ALTER SEQUENCE ${sequenceName} RESTART WITH 1`);
                console.log(`✅ Reset sequence for ${tableName} to start at 1`);
            } catch (error: any) {
                console.log(`⚠️  Could not reset sequence for ${tableName}: ${error.message}`);
            }
        };

        // Get all foreign key constraints that might interfere
        console.log('🔍 Checking foreign key constraints...');
        try {
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
                    AND (tc.table_name LIKE '%facet%' OR tc.table_name LIKE '%product%' OR tc.table_name LIKE '%collection%' OR tc.table_name LIKE '%asset%')
                ORDER BY tc.table_name, tc.constraint_name
            `);
            
            console.log(`Found ${constraints.length} foreign key constraints to consider`);
        } catch (error) {
            console.log('⚠️  Could not query foreign key constraints, proceeding anyway');
        }

        // Delete in very specific order to handle all foreign key dependencies
        console.log('🗑️  Starting deletion process...');
        
        // 1. First, clean all junction/relationship tables
        await safeDelete('product_variant_facet_values_facet_value');
        await safeDelete('product_facet_values_facet_value'); 
        await safeDelete('product_variant_facet_value');
        await safeDelete('product_facet_value');
        await safeDelete('collection_product');
        await safeDelete('collection_asset');
        await safeDelete('product_asset');
        await safeDelete('product_variant_asset');
        await safeDelete('product_variant_option');
        await safeDelete('product_option_group_option');
        
        // 2. Then clean dependent entities (with additional cleanup for orphaned data)
        await safeDelete('stock_movement'); // Clean stock movements first
        await safeDelete('product_variant');
        await safeDelete('product_option');
        await safeDelete('product_option_group');
        await safeDelete('product');
        await safeDelete('collection');
        await safeDelete('asset');
        
        // 3. Finally clean facets (after all references are gone)
        await safeDelete('facet_value');
        await safeDelete('facet');
        
        // 4. Clean other catalog-related tables
        await safeDelete('product_variant_price');
        await safeDelete('product_variant_translation');
        await safeDelete('product_translation');
        await safeDelete('collection_translation');
        await safeDelete('facet_translation');
        await safeDelete('facet_value_translation');
        
        console.log('🔄 Resetting ID sequences...');
        
        // Reset all sequences to start from 1
        await resetSequenceThorough('facet', 'facet_id_seq');
        await resetSequenceThorough('facet_value', 'facet_value_id_seq');
        await resetSequenceThorough('product', 'product_id_seq');
        await resetSequenceThorough('product_variant', 'product_variant_id_seq');
        await resetSequenceThorough('product_option', 'product_option_id_seq');
        await resetSequenceThorough('product_option_group', 'product_option_group_id_seq');
        await resetSequenceThorough('collection', 'collection_id_seq');
        await resetSequenceThorough('asset', 'asset_id_seq');

        console.log('✅ Database cleanup completed successfully!');
        console.log('💡 You can now run the seeding script to populate fresh data');
        
        await app.close();
        
    } catch (error) {
        console.error('❌ Error during database cleanup:', error);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    cleanDatabase();
}
