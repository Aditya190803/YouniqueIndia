import { bootstrap, runMigrations } from '@vendure/core';
import { config } from './vendure-config';

async function startServer() {
    try {
        console.log('🚀 Starting Vendure server...');
        
        // Run migrations first
        console.log('📦 Running database migrations...');
        await runMigrations(config);
        console.log('✅ Database migrations completed');
        
        // Bootstrap the application
        console.log('🔧 Bootstrapping application...');
        const app = await bootstrap(config);
        console.log('✅ Server started successfully');
        
        return app;
    } catch (error) {
        console.error('❌ Failed to start server:', error);
        
        // Log specific error details
        if (error instanceof Error) {
            console.error('Error message:', error.message);
            console.error('Stack trace:', error.stack);
        }
        
        // Exit with error code
        process.exit(1);
    }
}

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
    process.exit(1);
});

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
    process.exit(1);
});

startServer();
