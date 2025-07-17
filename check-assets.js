const { Client } = require('pg');
require('dotenv').config();

async function checkAssets() {
    const host = process.env.DB_HOST || 'localhost';
    const port = process.env.DB_PORT || 5432;
    const database = process.env.DB_NAME;
    const user = process.env.DB_USERNAME;
    const password = process.env.DB_PASSWORD;
    const ssl = process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false;

    if (!database || !user || !password) {
        console.log('❌ Missing DB credentials. Please set DB_NAME, DB_USERNAME, and DB_PASSWORD in your .env file.');
        return;
    }

    const client = new Client({ host, port, database, user, password, ssl });

    try {
        await client.connect();
        console.log('🔍 Checking first 10 assets in database...\n');
        const result = await client.query(`
            SELECT id, name, source, preview FROM asset ORDER BY id ASC LIMIT 10;
        `);
        if (result.rows.length === 0) {
            console.log('⚠️  No assets found in database');
            return;
        }
        result.rows.forEach((asset, index) => {
            console.log(`${index + 1}. ID: ${asset.id}`);
            console.log(`   Name: ${asset.name}`);
            console.log(`   Source: ${asset.source}`);
            console.log(`   Preview: ${asset.preview}`);
            console.log('');
        });
    } catch (error) {
        console.error('❌ Error checking assets:', error);
    } finally {
        await client.end();
    }
}

checkAssets(); 