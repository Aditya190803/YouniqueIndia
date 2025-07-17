const https = require('https');
const http = require('http');

console.log('🧪 Testing asset server and Cloudinary assets...\n');

// Test 1: Check if the server is running
async function testServerHealth() {
    return new Promise((resolve) => {
        http.get('http://localhost:3000/health', (res) => {
            if (res.statusCode === 200) {
                console.log('✅ Server is running on port 3000');
                resolve(true);
            } else {
                console.log('❌ Server health check failed');
                resolve(false);
            }
        }).on('error', () => {
            console.log('❌ Server is not running on port 3000');
            resolve(false);
        });
    });
}

// Test 2: Check asset server endpoint
async function testAssetServer() {
    return new Promise((resolve) => {
        http.get('http://localhost:3000/assets', (res) => {
            console.log(`📁 Asset server response: ${res.statusCode}`);
            if (res.statusCode === 200 || res.statusCode === 404) {
                console.log('✅ Asset server endpoint is accessible');
                resolve(true);
            } else {
                console.log('❌ Asset server endpoint failed');
                resolve(false);
            }
        }).on('error', () => {
            console.log('❌ Asset server endpoint is not accessible');
            resolve(false);
        });
    });
}

// Test 3: Check admin API
async function testAdminAPI() {
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
            console.log(`🔧 Admin API response: ${res.statusCode}`);
            if (res.statusCode === 400) {
                // 400 is expected for GraphQL endpoint without proper query
                console.log('✅ Admin API is accessible (400 is expected for empty query)');
                resolve(true);
            } else {
                console.log('⚠️  Admin API response unexpected');
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

// Test 4: Check if Cloudinary is configured
function checkCloudinaryConfig() {
    const cloudName = process.env.CLOUDINARY_CLOUD_NAME;
    const apiKey = process.env.CLOUDINARY_API_KEY;
    const apiSecret = process.env.CLOUDINARY_API_SECRET;

    if (cloudName && apiKey && apiSecret) {
        console.log('✅ Cloudinary configuration found');
        return true;
    } else {
        console.log('⚠️  Cloudinary configuration missing:');
        console.log(`   CLOUDINARY_CLOUD_NAME: ${cloudName ? '✅' : '❌'}`);
        console.log(`   CLOUDINARY_API_KEY: ${apiKey ? '✅' : '❌'}`);
        console.log(`   CLOUDINARY_API_SECRET: ${apiSecret ? '✅' : '❌'}`);
        return false;
    }
}

async function main() {
    console.log('🔍 Running asset tests...\n');

    const serverRunning = await testServerHealth();
    if (!serverRunning) {
        console.log('\n💡 Start the server with: npm run dev:server');
        return;
    }

    await testAssetServer();
    await testAdminAPI();
    checkCloudinaryConfig();

    console.log('\n📋 Summary:');
    console.log('🌐 Admin UI: http://localhost:3000/admin');
    console.log('🔧 Admin API: http://localhost:3000/admin-api');
    console.log('📁 Asset Server: http://localhost:3000/assets');
    console.log('🏪 Shop API: http://localhost:3000/shop-api');
    
    console.log('\n💡 If assets are not showing in admin:');
    console.log('   1. Check Cloudinary configuration');
    console.log('   2. Make sure assets were uploaded during seeding');
    console.log('   3. Try accessing assets directly via their URLs');
}

main(); 