import { bootstrap } from '@vendure/core';
import { config } from '../vendure-config';
import { GoogleAuthenticationStrategy } from '../plugins/authentication/google-authentication-strategy';

/**
 * Test script for Google Authentication
 * This script helps verify that the Google authentication strategy is properly configured
 */

async function testGoogleAuth() {
    console.log('🧪 Testing Google Authentication Setup...\n');

    try {
        // Start the Vendure server
        const app = await bootstrap(config);
        console.log('✅ Vendure server started successfully');

        // Check if Google authentication strategy is registered
        const authStrategies = config.authOptions?.shopAuthenticationStrategy;
        if (!authStrategies) {
            console.log('❌ Shop authentication strategies are not configured');
            return;
        }
        
        const googleStrategy = authStrategies.find((strategy: any) => strategy.name === 'google');

        if (googleStrategy) {
            console.log('✅ Google authentication strategy is registered');
        } else {
            console.log('❌ Google authentication strategy is NOT registered');
            return;
        }

        // Check environment variables
        const googleClientId = process.env.GOOGLE_CLIENT_ID;
        if (googleClientId) {
            console.log('✅ GOOGLE_CLIENT_ID environment variable is set');
        } else {
            console.log('❌ GOOGLE_CLIENT_ID environment variable is NOT set');
            console.log('   Please add GOOGLE_CLIENT_ID to your .env file');
            return;
        }

        // Check custom fields configuration
        const customFields = config.customFields?.Customer;
        if (!customFields) {
            console.log('❌ Customer custom fields are not configured');
            return;
        }
        
        const googleIdField = customFields.find((field: any) => field.name === 'googleId');

        if (googleIdField) {
            console.log('✅ Custom fields for Google authentication are configured');
        } else {
            console.log('❌ Custom fields for Google authentication are NOT configured');
            return;
        }

        console.log('\n🎉 Google Authentication Setup Verification Complete!');
        console.log('\n📋 Next Steps:');
        console.log('1. Set up your Google Cloud Console OAuth credentials');
        console.log('2. Add your frontend domain to authorized origins');
        console.log('3. Implement the Google Sign-In button in your storefront');
        console.log('4. Test the complete authentication flow');
        console.log('\n📖 See GOOGLE_AUTH_SETUP.md for detailed instructions');

    } catch (error) {
        console.error('❌ Error during Google authentication test:', error);
    }
}

// Run the test if this file is executed directly
if (require.main === module) {
    testGoogleAuth()
        .then(() => {
            console.log('\n✅ Test completed');
            process.exit(0);
        })
        .catch((error) => {
            console.error('\n❌ Test failed:', error);
            process.exit(1);
        });
} 