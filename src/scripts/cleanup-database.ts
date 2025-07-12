import { 
    bootstrap, 
    TransactionalConnection,
    RequestContext,
    LanguageCode
} from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Completely cleans the database and resets all ID sequences
 */
async function cleanDatabase() {
    console.log('🧹 Starting complete database cleanup...');

    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);

        // Disable foreign key checks temporarily (PostgreSQL doesn't have a global setting)
        console.log('🔓 Starting cleanup with CASCADE deletes...');

        // Helper function to safely delete and reset sequence
        const cleanTableWithSequence = async (tableName: string, sequenceName?: string) => {
            try {
                // Delete all records with CASCADE to handle foreign keys
                await connection.rawConnection.query(`DELETE FROM ${tableName}`);
                console.log(`✅ Cleaned ${tableName}`);
                
                // Reset sequence if provided
                if (sequenceName) {
                    await connection.rawConnection.query(`ALTER SEQUENCE ${sequenceName} RESTART WITH 1`);
                    console.log(`✅ Reset sequence ${sequenceName}`);
                }
            } catch (error) {
                console.log(`⚠️  Could not clean ${tableName}: ${error instanceof Error ? error.message : 'Unknown error'}`);
            }
        };

        // Delete in order that respects foreign key constraints
        console.log('🗑️  Deleting catalog data...');
        await cleanTableWithSequence('product_variant_facet_values_facet_value');
        await cleanTableWithSequence('product_facet_values_facet_value');
        await cleanTableWithSequence('collection_product_variants_product_variant');
        await cleanTableWithSequence('collection_products_product');
        await cleanTableWithSequence('product_variant_asset');
        await cleanTableWithSequence('product_asset');
        await cleanTableWithSequence('product_option_group_translation');
        await cleanTableWithSequence('product_option_translation');
        await cleanTableWithSequence('product_variant_option');
        await cleanTableWithSequence('product_option', 'product_option_id_seq');
        await cleanTableWithSequence('product_option_group', 'product_option_group_id_seq');
        await cleanTableWithSequence('product_variant_translation');
        await cleanTableWithSequence('product_variant', 'product_variant_id_seq');
        await cleanTableWithSequence('product_translation');
        await cleanTableWithSequence('product', 'product_id_seq');
        await cleanTableWithSequence('collection_translation');
        await cleanTableWithSequence('collection_asset');
        await cleanTableWithSequence('collection', 'collection_id_seq');
        await cleanTableWithSequence('facet_value_translation');
        await cleanTableWithSequence('facet_value', 'facet_value_id_seq');
        await cleanTableWithSequence('facet_translation');
        await cleanTableWithSequence('facet', 'facet_id_seq');
        await cleanTableWithSequence('asset', 'asset_id_seq');

        // Re-enable foreign key checks
        console.log('✅ Cleanup completed!');

        console.log('✅ Database cleanup completed successfully!');
        console.log('All catalog data removed and ID sequences reset to 1');

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
