import { bootstrapWorker } from '@vendure/core';
import { config } from './vendure-config';

async function startWorker() {
    try {
        console.log('🔧 Starting Vendure worker...');
        
        const worker = await bootstrapWorker(config);
        console.log('✅ Worker bootstrapped successfully');
        
        await worker.startJobQueue();
        console.log('✅ Job queue started successfully');
        
        return worker;
    } catch (error) {
        console.error('❌ Failed to start worker:', error);
        
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

startWorker();
