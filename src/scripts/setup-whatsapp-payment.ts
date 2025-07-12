import { bootstrap, PaymentMethodService, RequestContext, TransactionalConnection, LanguageCode } from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Sets up the WhatsApp payment method in the database
 */
async function setupWhatsAppPaymentMethod() {
    console.log('🚀 Setting up WhatsApp payment method...');
    
    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);
        const paymentMethodService = app.get(PaymentMethodService);
        
        // Create a super admin context
        const channel = await connection.getRepository('Channel').findOne({
            where: { code: '__default_channel__' }
        });
        
        if (!channel) {
            throw new Error('Default channel not found');
        }
        
        const ctx = new RequestContext({
            apiType: 'admin',
            isAuthorized: true,
            authorizedAsOwnerOnly: false,
            languageCode: LanguageCode.en,
            channel: channel as any,
            session: {} as any,
            req: undefined
        });
        
        // Check if WhatsApp payment method already exists
        const existingMethods = await paymentMethodService.findAll(ctx);
        const whatsappMethod = existingMethods.items.find(method => method.code === 'whatsapp-payment');
        
        if (whatsappMethod) {
            console.log('✅ WhatsApp payment method already exists');
        } else {
            // Create the WhatsApp payment method
            const paymentMethod = await paymentMethodService.create(ctx, {
                code: 'whatsapp-payment',
                enabled: true,
                handler: {
                    code: 'whatsapp-payment',
                    arguments: [
                        {
                            name: 'whatsappNumber',
                            value: '+918422039965', // Replace with your WhatsApp number
                        },
                        {
                            name: 'businessName',
                            value: 'YouniqueIndia',
                        },
                        {
                            name: 'customMessage',
                            value: '',
                        },
                    ],
                },
                translations: [
                    {
                        languageCode: LanguageCode.en,
                        name: 'WhatsApp Payment',
                        description: 'Pay via WhatsApp - We will send order details to WhatsApp for confirmation',
                    },
                ],
            });
            
            console.log('✅ WhatsApp payment method created successfully!');
            console.log(`Payment method ID: ${paymentMethod.id}`);
        }
        
        await app.close();
        
    } catch (error) {
        console.error('❌ Error setting up WhatsApp payment method:', error);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    setupWhatsAppPaymentMethod();
}
