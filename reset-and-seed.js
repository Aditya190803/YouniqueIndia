const { spawn } = require('child_process');
const path = require('path');

console.log('🚀 Starting database reset and seed process...');

// Function to run a TypeScript script
function runScript(scriptPath, description) {
    return new Promise((resolve, reject) => {
        console.log(`\n📋 Running: ${description}`);
        console.log(`📍 Script: ${scriptPath}`);
        
        const child = spawn('npx', ['ts-node', scriptPath], {
            stdio: 'inherit',
            cwd: __dirname,
            env: { ...process.env, NODE_ENV: 'development' }
        });

        child.on('close', (code) => {
            if (code === 0) {
                console.log(`✅ ${description} completed successfully`);
                resolve();
            } else {
                console.error(`❌ ${description} failed with code ${code}`);
                reject(new Error(`${description} failed with code ${code}`));
            }
        });

        child.on('error', (error) => {
            console.error(`❌ Error running ${description}:`, error);
            reject(error);
        });
    });
}

async function main() {
    try {
        // Step 1: Clean the database
        await runScript(
            path.join(__dirname, 'src/scripts/clean-database.ts'),
            'Database cleanup'
        );

        // Step 2: Run the seed script
        await runScript(
            path.join(__dirname, 'src/scripts/seed-jewelry-final.ts'),
            'Database seeding'
        );

        console.log('\n🎉 Database reset and seeding completed successfully!');
        console.log('💡 Your Vendure application is now ready with fresh data.');
        
    } catch (error) {
        console.error('\n💥 Error during database reset and seeding:', error.message);
        process.exit(1);
    }
}

// Check if required environment variables are set
const requiredEnvVars = [
    'DB_HOST',
    'DB_NAME', 
    'DB_USERNAME',
    'DB_PASSWORD',
    'SUPERADMIN_USERNAME',
    'SUPERADMIN_PASSWORD',
    'COOKIE_SECRET'
];

const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);

if (missingVars.length > 0) {
    console.error('❌ Missing required environment variables:');
    missingVars.forEach(varName => console.error(`   - ${varName}`));
    console.error('\n💡 Please set these environment variables before running the script.');
    console.error('   You can create a .env file or set them in your environment.');
    process.exit(1);
}

main(); 