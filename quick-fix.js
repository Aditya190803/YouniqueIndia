const { spawn } = require('child_process');

console.log('🚀 Quick fix - Running everything with your environment...\n');

// Function to run a command and show output
function runCommand(command, description) {
    return new Promise((resolve, reject) => {
        console.log(`\n📋 Running: ${description}`);
        console.log(`📍 Command: ${command}`);
        
        const [cmd, ...args] = command.split(' ');
        const child = spawn(cmd, args, {
            stdio: 'inherit',
            cwd: process.cwd(),
            env: { ...process.env }
        });

        child.on('close', (code) => {
            if (code === 0) {
                console.log(`✅ ${description} completed successfully`);
                resolve();
            } else {
                console.log(`❌ ${description} failed with code ${code}`);
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
        console.log('🔧 Step 1: Cleaning database...');
        await runCommand('npm run clean-db', 'Database cleanup');
        
        console.log('\n🔧 Step 2: Seeding database...');
        await runCommand('npm run seed-db', 'Database seeding');
        
        console.log('\n🔧 Step 3: Starting server...');
        console.log('💡 The server will start in the background');
        console.log('💡 You can access the admin at: http://localhost:3000/admin');
        console.log('💡 Asset server at: http://localhost:3000/assets');
        
        // Start the server in the background
        const serverProcess = spawn('npm', ['run', 'dev:server'], {
            stdio: 'inherit',
            cwd: process.cwd(),
            env: { ...process.env }
        });
        
        console.log('\n🎉 Everything is set up!');
        console.log('📋 Summary:');
        console.log('   ✅ Database cleaned');
        console.log('   ✅ Database seeded with jewelry data');
        console.log('   ✅ Server starting...');
        console.log('\n🌐 Access your application:');
        console.log('   Admin UI: http://localhost:3000/admin');
        console.log('   Shop API: http://localhost:3000/shop-api');
        console.log('   Asset Server: http://localhost:3000/assets');
        
        // Keep the process running
        serverProcess.on('close', (code) => {
            console.log(`\n🔄 Server stopped with code ${code}`);
        });
        
    } catch (error) {
        console.error('\n💥 Error during setup:', error.message);
        console.log('\n💡 If you get database connection errors:');
        console.log('   1. Make sure your database is running');
        console.log('   2. Check your .env file has correct database credentials');
        console.log('   3. Try running the commands manually:');
        console.log('      npm run clean-db');
        console.log('      npm run seed-db');
        console.log('      npm run dev:server');
    }
}

main(); 