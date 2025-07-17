const { Client } = require('pg');

console.log('🔧 Setting up environment and testing database connection...\n');

// Test different database configurations
const dbConfigs = [
    {
        name: 'Default PostgreSQL',
        host: 'localhost',
        port: 5432,
        database: 'youniqueindia',
        user: 'postgres',
        password: 'postgres'
    },
    {
        name: 'Alternative PostgreSQL',
        host: 'localhost',
        port: 5432,
        database: 'youniqueindia',
        user: 'postgres',
        password: 'password'
    },
    {
        name: 'PostgreSQL with empty password',
        host: 'localhost',
        port: 5432,
        database: 'youniqueindia',
        user: 'postgres',
        password: ''
    }
];

async function testDatabaseConnection(config) {
    const client = new Client(config);
    
    try {
        await client.connect();
        console.log(`✅ ${config.name}: Connected successfully`);
        
        // Test a simple query
        const result = await client.query('SELECT version()');
        console.log(`   Database version: ${result.rows[0].version.split(' ')[0]}`);
        
        await client.end();
        return true;
    } catch (error) {
        console.log(`❌ ${config.name}: ${error.message}`);
        await client.end();
        return false;
    }
}

async function main() {
    console.log('🧪 Testing database connections...\n');
    
    let workingConfig = null;
    
    for (const config of dbConfigs) {
        const success = await testDatabaseConnection(config);
        if (success && !workingConfig) {
            workingConfig = config;
        }
    }
    
    if (workingConfig) {
        console.log(`\n✅ Found working database configuration: ${workingConfig.name}`);
        console.log('\n📝 Add these to your .env file:');
        console.log(`DB_HOST=${workingConfig.host}`);
        console.log(`DB_PORT=${workingConfig.port}`);
        console.log(`DB_NAME=${workingConfig.database}`);
        console.log(`DB_USERNAME=${workingConfig.user}`);
        console.log(`DB_PASSWORD=${workingConfig.password}`);
        
        console.log('\n🔧 For Cloudinary (optional):');
        console.log('CLOUDINARY_CLOUD_NAME=your_cloud_name');
        console.log('CLOUDINARY_API_KEY=your_api_key');
        console.log('CLOUDINARY_API_SECRET=your_api_secret');
        
        console.log('\n🔧 For authentication:');
        console.log('SUPERADMIN_USERNAME=superadmin');
        console.log('SUPERADMIN_PASSWORD=superadmin123');
        console.log('COOKIE_SECRET=your-secret-key-here');
        
    } else {
        console.log('\n❌ No working database configuration found');
        console.log('💡 Make sure PostgreSQL is running and accessible');
        console.log('💡 Check your database credentials');
    }
}

main().catch(console.error); 