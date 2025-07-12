import { bootstrap, OrderService, ProductService, RequestContext, TransactionalConnection, LanguageCode } from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Test script to create a test order with WhatsApp payment
 */
async function testWhatsAppPayment() {
    console.log('🧪 Testing WhatsApp payment method...');
    
    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);
        const orderService = app.get(OrderService);
        const productService = app.get(ProductService);
        
        // Create a shop context (simulating a customer)
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
        
        // Get first product for testing
        const products = await productService.findAll(ctx, { take: 1 });
        if (products.items.length === 0) {
            throw new Error('No products found. Please run the seed script first.');
        }
        
        const testProduct = products.items[0];
        console.log(`Found test product: ${testProduct.name}`);
        
        // Create a test order
        const order = await orderService.create(ctx, ctx.session?.user?.id);
        console.log(`Created test order: ${order.code}`);
        
        // Add product to order
        await orderService.addItemToOrder(ctx, order.id, testProduct.variants[0].id, 1);
        console.log(`Added product to order`);
        
        // Set billing address
        await orderService.setBillingAddress(ctx, order.id, {
            fullName: 'Test Customer',
            streetLine1: '123 Test Street',
            city: 'Mumbai',
            postalCode: '400001',
            countryCode: 'IN',
            phoneNumber: '+918422039965'
        });
        
        // Set shipping address (same as billing)
        await orderService.setShippingAddress(ctx, order.id, {
            fullName: 'Test Customer',
            streetLine1: '123 Test Street',
            city: 'Mumbai',
            postalCode: '400001',
            countryCode: 'IN',
            phoneNumber: '+918422039965'
        });
        
        // Get available payment methods
        const paymentMethods = await orderService.getEligiblePaymentMethods(ctx, order.id);
        const whatsappMethod = paymentMethods.find(method => method.code === 'whatsapp-payment');
        
        if (!whatsappMethod) {
            throw new Error('WhatsApp payment method not found in eligible methods');
        }
        
        console.log(`✅ WhatsApp payment method is available: ${whatsappMethod.name}`);
        
        // Try to add payment to order
        try {
            await orderService.addPaymentToOrder(ctx, order.id, {
                method: whatsappMethod.code,
                metadata: {
                    customerPhone: '+918422039965',
                    customerName: 'Test Customer'
                }
            });
            
            console.log('✅ WhatsApp payment processed successfully!');
            console.log('📱 Check your WhatsApp for the order details message.');
            
        } catch (paymentError) {
            console.log('⚠️  Payment processing result:', paymentError instanceof Error ? paymentError.message : paymentError);
        }
        
        await app.close();
        
    } catch (error) {
        console.error('❌ Error testing WhatsApp payment:', error);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    testWhatsAppPayment();
}
