import { bootstrap, PaymentMethodService, TransactionalConnection, LanguageCode } from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Setup script to create payment methods for UPI, Card, and Cash/COD
 * Run with: npm run ts-node src/scripts/setup-payment-methods.ts
 */
async function setupPaymentMethods() {
    console.log('🚀 Setting up payment methods (UPI, Card, Cash/COD)...');
    
    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);
        
        await connection.withTransaction(async (ctx: any) => {
            const paymentMethodService = app.get(PaymentMethodService);
            
            // Create UPI Payment Method
            try {
                const existingUpi = await (paymentMethodService as any)
                    .findAll?.(ctx)
                    .then((r: any) => r.items?.find((pm: any) => pm.code === 'upi-payment'));
                
                if (!existingUpi) {
                    await paymentMethodService.create(ctx, {
                        code: 'upi-payment',
                        translations: [
                            {
                                languageCode: LanguageCode.en,
                                name: 'UPI Payment',
                                description: 'Pay via UPI (PhonePe, Google Pay, Paytm, etc.)',
                            },
                        ],
                        handler: {
                            code: 'upi-payment',
                            arguments: [],
                        },
                        enabled: true,
                    } as any);
                    console.log('✅ Created UPI Payment method');
                } else {
                    console.log('ℹ️  UPI Payment method already exists');
                }
            } catch (e: any) {
                console.log('⚠️  Could not create UPI Payment method:', e?.message);
            }

            // Create Card Payment Method
            try {
                const existingCard = await (paymentMethodService as any)
                    .findAll?.(ctx)
                    .then((r: any) => r.items?.find((pm: any) => pm.code === 'card-payment'));
                
                if (!existingCard) {
                    await paymentMethodService.create(ctx, {
                        code: 'card-payment',
                        translations: [
                            {
                                languageCode: LanguageCode.en,
                                name: 'Card Payment',
                                description: 'Pay via Credit or Debit Card',
                            },
                        ],
                        handler: {
                            code: 'card-payment',
                            arguments: [],
                        },
                        enabled: true,
                    } as any);
                    console.log('✅ Created Card Payment method');
                } else {
                    console.log('ℹ️  Card Payment method already exists');
                }
            } catch (e: any) {
                console.log('⚠️  Could not create Card Payment method:', e?.message);
            }

            // Create Cash/COD Payment Method
            try {
                const existingCash = await (paymentMethodService as any)
                    .findAll?.(ctx)
                    .then((r: any) => r.items?.find((pm: any) => pm.code === 'cash-payment'));
                
                if (!existingCash) {
                    await paymentMethodService.create(ctx, {
                        code: 'cash-payment',
                        translations: [
                            {
                                languageCode: LanguageCode.en,
                                name: 'Cash / COD',
                                description: 'Cash on Delivery or Direct Cash Payment',
                            },
                        ],
                        handler: {
                            code: 'cash-payment',
                            arguments: [],
                        },
                        enabled: true,
                    } as any);
                    console.log('✅ Created Cash/COD Payment method');
                } else {
                    console.log('ℹ️  Cash/COD Payment method already exists');
                }
            } catch (e: any) {
                console.log('⚠️  Could not create Cash/COD Payment method:', e?.message);
            }

            console.log('✅ Payment methods setup complete!');
            console.log('\n📝 Note: These payment methods are now available in the Admin UI.');
            console.log('   Go to: Settings > Payment Methods to view and configure them.');
        });
        
        await app.close();
    } catch (error) {
        console.error('❌ Error setting up payment methods:', error);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    setupPaymentMethods();
}
