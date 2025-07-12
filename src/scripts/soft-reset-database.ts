import { bootstrap, TransactionalConnection, Connection } from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Alternative approach to reset database using migration rollback and rerun
 */
async function softResetDatabase() {
    console.log('🔄 Performing soft database reset using migrations...');
    
    try {
        const app = await bootstrap(config);
        const connection = app.get(Connection);
        const transactionalConnection = app.get(TransactionalConnection);

        console.log('📡 Connected to database');
        
        console.log('🧹 Clearing product variant facet values...');
        await transactionalConnection.withTransaction(async (ctx) => {
            // Disassociate all facet values from product variants to avoid foreign key constraints
            await transactionalConnection.getRepository(ctx, 'product_variant_facet_values_facet_value').query('DELETE FROM product_variant_facet_values_facet_value;');
        });
        console.log('✅ Cleared product variant facet values.');

        console.log('⏪ Rolling back all migrations...');
        
        // Revert all migrations
        await connection.undoLastMigration({ transaction: 'each' });
        
        console.log('🔄 Running migrations to recreate schema...');
        
        // Run migrations again to recreate the schema
        await connection.runMigrations();
        
        console.log('✅ Soft database reset completed successfully!');
        console.log('💡 Next steps:');
        console.log('   1. Run: npm run setup:basic');
        console.log('   2. Run: npm run seed:jewelry');
        
        await app.close();
        
    } catch (error) {
        console.error('❌ Error during soft database reset:', error);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    softResetDatabase();
}
