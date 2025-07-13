import { bootstrap, TransactionalConnection } from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Script to fix the column type issue for customFieldsRazorpay_order_id
 */
async function fixColumnType() {
    console.log('🔧 Fixing column type for customFieldsRazorpay_order_id...');
    
    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);
        
        console.log('✅ Database connection successful');
        
        // Check the current column type
        const columnInfo = await connection.rawConnection.query(`
            SELECT data_type, character_maximum_length, is_nullable
            FROM information_schema.columns 
            WHERE table_name = 'order' 
            AND column_name = 'customFieldsRazorpay_order_id'
        `);
        
        // pg returns rows as columnInfo[0] if using query, or columnInfo.rows if using pool
        const rows = columnInfo.rows || columnInfo;
        if (rows && rows.length > 0) {
            const column = rows[0];
            console.log(`Current column type: ${column.data_type}(${column.character_maximum_length})`);
            
            if (column.character_maximum_length !== 255) {
                console.log('⚠️  Column type needs to be updated to character varying(255)');
                // Update the column type
                await connection.rawConnection.query(`
                    ALTER TABLE "order" 
                    ALTER COLUMN "customFieldsRazorpay_order_id" TYPE character varying(255)
                `);
                console.log('✅ Column type updated successfully');
            } else {
                console.log('✅ Column already has the correct type');
            }
        } else {
            console.log('⚠️  Column does not exist, creating it...');
            try {
                await connection.rawConnection.query(`
                    ALTER TABLE "order" 
                    ADD COLUMN "customFieldsRazorpay_order_id" character varying(255)
                `);
                console.log('✅ Column created with correct type');
            } catch (error: any) {
                if (error.code === '42701') {
                    console.log('✅ Column already exists (caught duplicate error)');
                } else {
                    throw error;
                }
            }
        }
        
        await app.close();
        console.log('✅ Column type fix completed successfully');
        
    } catch (error) {
        console.error('❌ Error fixing column type:', error);
        process.exit(1);
    }
}

// Run the fix if this script is executed directly
if (require.main === module) {
    fixColumnType();
} 