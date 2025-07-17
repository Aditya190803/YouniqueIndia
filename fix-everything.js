const { Client } = require('pg');
const https = require('https');
const http = require('http');

console.log('🔧 Fixing everything...\n');

// Database connection
const client = new Client({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'youniqueindia',
    user: process.env.DB_USERNAME || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
});

async function checkDatabaseConnection() {
    try {
        await client.connect();
        console.log('✅ Database connection successful');
        return true;
    } catch (error) {
        console.log('❌ Database connection failed:', error.message);
        return false;
    }
}

async function checkAssets() {
    try {
        const result = await client.query(`
            SELECT 
                id,
                name,
                type,
                mime_type,
                width,
                height,
                file_size,
                source,
                preview,
                created_at
            FROM asset 
            ORDER BY created_at DESC
        `);

        console.log(`📊 Found ${result.rows.length} assets in database:`);
        
        if (result.rows.length === 0) {
            console.log('⚠️  No assets found in database');
            return false;
        }

        result.rows.forEach((asset, index) => {
            console.log(`\n${index + 1}. ${asset.name || 'Unnamed Asset'}`);
            console.log(`   ID: ${asset.id}`);
            console.log(`   Source: ${asset.source}`);
            console.log(`   Type: ${asset.type}`);
            console.log(`   Size: ${asset.width}x${asset.height} (${asset.file_size} bytes)`);
            console.log(`   Created: ${asset.created_at}`);
        });

        return true;
    } catch (error) {
        console.log('❌ Error checking assets:', error.message);
        return false;
    }
}

async function testAssetUrls() {
    try {
        const result = await client.query('SELECT id, source FROM asset LIMIT 3');
        
        console.log('\n🧪 Testing asset URLs...');
        
        for (const asset of result.rows) {
            if (asset.source && asset.source.startsWith('http')) {
                try {
                    const response = await new Promise((resolve, reject) => {
                        https.get(asset.source, (res) => {
                            resolve(res.statusCode);
                        }).on('error', reject);
                    });
                    
                    if (response === 200) {
                        console.log(`✅ Asset ${asset.id}: ${asset.source} - Accessible`);
                    } else {
                        console.log(`⚠️  Asset ${asset.id}: ${asset.source} - Status ${response}`);
                    }
                } catch (error) {
                    console.log(`❌ Asset ${asset.id}: ${asset.source} - Error: ${error.message}`);
                }
            } else {
                console.log(`⚠️  Asset ${asset.id}: Invalid URL - ${asset.source}`);
            }
        }
    } catch (error) {
        console.log('❌ Error testing asset URLs:', error.message);
    }
}

async function checkServerHealth() {
    return new Promise((resolve) => {
        http.get('http://localhost:3000/health', (res) => {
            if (res.statusCode === 200) {
                console.log('✅ Server is running and healthy');
                resolve(true);
            } else {
                console.log(`❌ Server health check failed: ${res.statusCode}`);
                resolve(false);
            }
        }).on('error', () => {
            console.log('❌ Server is not running on port 3000');
            resolve(false);
        });
    });
}

async function checkAdminAPI() {
    return new Promise((resolve) => {
        const options = {
            hostname: 'localhost',
            port: 3000,
            path: '/admin-api',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            }
        };

        const req = http.request(options, (res) => {
            if (res.statusCode === 400) {
                console.log('✅ Admin API is accessible (400 is expected for empty query)');
                resolve(true);
            } else {
                console.log(`⚠️  Admin API response: ${res.statusCode}`);
                resolve(false);
            }
        });

        req.on('error', () => {
            console.log('❌ Admin API is not accessible');
            resolve(false);
        });

        req.end();
    });
}

function checkEnvironmentVariables() {
    console.log('\n🔍 Checking environment variables...');
    
    const requiredVars = [
        'DB_HOST', 'DB_NAME', 'DB_USERNAME', 'DB_PASSWORD',
        'SUPERADMIN_USERNAME', 'SUPERADMIN_PASSWORD', 'COOKIE_SECRET'
    ];
    
    const cloudinaryVars = [
        'CLOUDINARY_CLOUD_NAME', 'CLOUDINARY_API_KEY', 'CLOUDINARY_API_SECRET'
    ];
    
    let allRequiredPresent = true;
    let cloudinaryPresent = true;
    
    console.log('Required variables:');
    requiredVars.forEach(varName => {
        const value = process.env[varName];
        if (value) {
            console.log(`   ✅ ${varName}: ${value.substring(0, 10)}...`);
        } else {
            console.log(`   ❌ ${varName}: Missing`);
            allRequiredPresent = false;
        }
    });
    
    console.log('\nCloudinary variables:');
    cloudinaryVars.forEach(varName => {
        const value = process.env[varName];
        if (value) {
            console.log(`   ✅ ${varName}: ${value.substring(0, 10)}...`);
        } else {
            console.log(`   ❌ ${varName}: Missing`);
            cloudinaryPresent = false;
        }
    });
    
    return { allRequiredPresent, cloudinaryPresent };
}

async function regenerateAssets() {
    console.log('\n🔄 Regenerating assets...');
    
    try {
        // Delete all existing assets
        await client.query('DELETE FROM asset');
        console.log('✅ Cleared existing assets');
        
        // Reset asset sequence
        await client.query('ALTER SEQUENCE asset_id_seq RESTART WITH 1');
        console.log('✅ Reset asset sequence');
        
        console.log('💡 Now run: npm run seed-db');
        
    } catch (error) {
        console.log('❌ Error regenerating assets:', error.message);
    }
}

async function main() {
    console.log('🚀 Starting comprehensive fix...\n');
    
    // Check environment variables
    const envCheck = checkEnvironmentVariables();
    
    // Check database connection
    const dbConnected = await checkDatabaseConnection();
    if (!dbConnected) {
        console.log('\n❌ Cannot proceed without database connection');
        return;
    }
    
    // Check server health
    const serverHealthy = await checkServerHealth();
    if (!serverHealthy) {
        console.log('\n💡 Start the server with: npm run dev:server');
    }
    
    // Check admin API
    if (serverHealthy) {
        await checkAdminAPI();
    }
    
    // Check assets
    const assetsExist = await checkAssets();
    
    // Test asset URLs if assets exist
    if (assetsExist) {
        await testAssetUrls();
    }
    
    // Provide recommendations
    console.log('\n📋 Summary & Recommendations:');
    console.log('🌐 Admin UI: http://localhost:3000/admin');
    console.log('🔧 Admin API: http://localhost:3000/admin-api');
    console.log('📁 Asset Server: http://localhost:3000/assets');
    
    if (!envCheck.cloudinaryPresent) {
        console.log('\n⚠️  Cloudinary not configured - assets will not upload to Cloudinary');
        console.log('   Set CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET in your .env file');
    }
    
    if (!assetsExist) {
        console.log('\n💡 No assets found - run: npm run seed-db');
    }
    
    if (!serverHealthy) {
        console.log('\n💡 Server not running - run: npm run dev:server');
    }
    
    console.log('\n🔧 If you want to regenerate all assets:');
    console.log('   1. Stop the server (Ctrl+C)');
    console.log('   2. Run: npm run clean-db');
    console.log('   3. Run: npm run seed-db');
    console.log('   4. Run: npm run dev:server');
    
    await client.end();
}

// Set default environment variables if not present
if (!process.env.DB_HOST) {
    process.env.DB_HOST = 'localhost';
    process.env.DB_PORT = '5432';
    process.env.DB_NAME = 'youniqueindia';
    process.env.DB_USERNAME = 'postgres';
    process.env.DB_PASSWORD = 'postgres';
    process.env.SUPERADMIN_USERNAME = 'superadmin';
    process.env.SUPERADMIN_PASSWORD = 'superadmin123';
    process.env.COOKIE_SECRET = 'your-secret-key-here';
}

main().catch(console.error); 