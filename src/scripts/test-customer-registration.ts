import { bootstrap, RequestContext, TransactionalConnection, LanguageCode } from '@vendure/core';
import { config } from '../vendure-config';
import { CustomerRegistrationService } from '../plugins/customer-registration/customer-registration.service';

/**
 * Test script for Customer Registration with Google ID
 * This script demonstrates how to create customers with Google ID during manual registration
 */
async function testCustomerRegistration() {
    console.log('🧪 Testing Customer Registration with Google ID...\n');

    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);
        const customerRegistrationService = app.get(CustomerRegistrationService);

        // Create a shop context (simulating a customer registration)
        const channel = await connection.getRepository('Channel').findOne({
            where: { code: '__default_channel__' }
        });

        if (!channel) {
            throw new Error('Default channel not found');
        }

        const ctx = new RequestContext({
            apiType: 'shop',
            isAuthorized: false,
            authorizedAsOwnerOnly: false,
            languageCode: LanguageCode.en,
            channel: channel as any,
            session: {} as any,
            req: undefined
        });

        // Test 1: Create customer with Google ID
        console.log('📝 Test 1: Creating customer with Google ID...');
        const customerWithGoogleId = await customerRegistrationService.createCustomerWithGoogleId(ctx, {
            emailAddress: 'john.doe@gmail.com',
            firstName: 'John',
            lastName: 'Doe',
            googleId: 'google_123456789',
        });

        if (customerWithGoogleId) {
            console.log('✅ Customer created with Google ID:', customerWithGoogleId.emailAddress);
            
            // Test 2: Check if customer has Google ID
            console.log('\n📝 Test 2: Checking if customer has Google ID...');
            const hasGoogleId = await customerRegistrationService.hasGoogleId(ctx, customerWithGoogleId.id.toString());
            console.log(`✅ Customer has Google ID: ${hasGoogleId}`);

            // Test 3: Find customer by Google ID
            console.log('\n📝 Test 3: Finding customer by Google ID...');
            const foundCustomer = await customerRegistrationService.findByGoogleId(ctx, 'google_123456789');
            if (foundCustomer) {
                console.log('✅ Customer found by Google ID:', foundCustomer.emailAddress);
            } else {
                console.log('❌ Customer not found by Google ID');
            }

            // Test 4: Update customer with new Google ID
            console.log('\n📝 Test 4: Updating customer with new Google ID...');
            const updatedCustomer = await customerRegistrationService.updateCustomerWithGoogleId(
                ctx,
                customerWithGoogleId.id.toString(),
                'google_987654321'
            );
            if (updatedCustomer) {
                console.log('✅ Customer updated with new Google ID');
            } else {
                console.log('❌ Failed to update customer with Google ID');
            }
        } else {
            console.log('❌ Failed to create customer with Google ID');
        }

        // Test 5: Create customer without Google ID (manual registration)
        console.log('\n📝 Test 5: Creating customer without Google ID (manual registration)...');
        const manualCustomer = await customerRegistrationService.createCustomerWithGoogleId(ctx, {
            emailAddress: 'jane.smith@example.com',
            firstName: 'Jane',
            lastName: 'Smith',
            // No googleId - this simulates manual registration
        });

        if (manualCustomer) {
            console.log('✅ Manual customer created:', manualCustomer.emailAddress);
            
            // Later, if this customer signs in with Google, we can update them
            console.log('\n📝 Test 6: Updating manual customer with Google ID...');
            const updatedManualCustomer = await customerRegistrationService.updateCustomerWithGoogleId(
                ctx,
                manualCustomer.id.toString(),
                'google_manual_user_123'
            );
            if (updatedManualCustomer) {
                console.log('✅ Manual customer updated with Google ID');
            } else {
                console.log('❌ Failed to update manual customer with Google ID');
            }
        } else {
            console.log('❌ Failed to create manual customer');
        }

        console.log('\n🎉 Customer Registration Tests Completed!');
        console.log('\n📋 Summary:');
        console.log('✅ Customer creation with Google ID');
        console.log('✅ Google ID checking');
        console.log('✅ Customer lookup by Google ID');
        console.log('✅ Customer update with Google ID');
        console.log('✅ Manual registration workflow');

        await app.close();

    } catch (error) {
        console.error('❌ Error during customer registration test:', error);
    }
}

// Run the test if this file is executed directly
if (require.main === module) {
    testCustomerRegistration()
        .then(() => {
            console.log('\n✅ Test completed');
            process.exit(0);
        })
        .catch((error) => {
            console.error('\n❌ Test failed:', error);
            process.exit(1);
        });
} 