import { bootstrap, ChannelService, CountryService, TaxCategoryService, ZoneService, ShippingMethodService, PaymentMethodService, RequestContext, TransactionalConnection, LanguageCode, CurrencyCode } from '@vendure/core';
import { config } from '../vendure-config';

/**
 * Sets up basic data required for the store to function
 */
async function setupBasicData() {
    console.log('🚀 Setting up basic store data...');
    
    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);
        
        await connection.withTransaction(async ctx => {
            const channelService = app.get(ChannelService);
            const countryService = app.get(CountryService);
            const zoneService = app.get(ZoneService);
            const taxCategoryService = app.get(TaxCategoryService);
            const shippingMethodService = app.get(ShippingMethodService);
            const paymentMethodService = app.get(PaymentMethodService);
            
            console.log('🌍 Setting up countries...');
            
            // Create India as the only country (India-only shipping)
            const india = await countryService.create(ctx, {
                code: 'IN',
                translations: [
                    {
                        languageCode: LanguageCode.en,
                        name: 'India'
                    }
                ],
                enabled: true
            });
            
            console.log('🗺️  Setting up zones...');
            
            // Create India zone (only zone needed)
            const indiaZone = await zoneService.create(ctx, {
                name: 'India',
                memberIds: [india.id]
            });
            
            console.log('💰 Setting up tax categories...');
            
            // Create tax-free category (no tax)
            const noTax = await taxCategoryService.create(ctx, {
                name: 'Tax Free',
                isDefault: true
            });
            
            console.log('🚚 Setting up shipping methods...');
            
            // Create free shipping for India only
            await shippingMethodService.create(ctx, {
                code: 'free-shipping-india',
                translations: [
                    {
                        languageCode: LanguageCode.en,
                        name: 'Free Shipping',
                        description: 'Free shipping across India (5-7 business days)'
                    }
                ],
                fulfillmentHandler: 'manual-fulfillment',
                checker: {
                    code: 'default-shipping-eligibility-checker',
                    arguments: []
                },
                calculator: {
                    code: 'default-shipping-calculator',
                    arguments: [
                        { name: 'rate', value: '0' }, // Free shipping
                        { name: 'includesTax', value: 'exclude' },
                        { name: 'taxRate', value: '0' }
                    ]
                }
            });
            
            console.log('💳 Setting up Razorpay payment method...');
            await paymentMethodService.create(ctx, {
                code: 'razorpay',
                translations: [
                    {
                        languageCode: LanguageCode.en,
                        name: 'Razorpay',
                        description: 'Pay with Razorpay (UPI, Cards, Net Banking, Wallets)'
                    }
                ],
                handler: {
                    code: 'razorpay',
                    arguments: [
                        { name: 'razorpayKeyId', value: process.env.key_id || '' },
                        { name: 'razorpayKeySecret', value: process.env.key_secret || '' },
                    ]
                },
                enabled: true,
            });
            
            console.log('💱 Setting up INR currency...');
            
            // Update the default channel to use INR currency
            const defaultChannel = await channelService.getDefaultChannel(ctx);
            if (defaultChannel) {
                await channelService.update(ctx, {
                    id: defaultChannel.id,
                    defaultCurrencyCode: CurrencyCode.INR,
                    availableCurrencyCodes: [CurrencyCode.INR]
                });
                console.log('✅ Set INR as default currency');
            }
            
            console.log('✅ Basic store setup completed successfully!');
        });
        
        await app.close();
        
    } catch (error) {
        console.error('❌ Error during basic setup:', error);
        process.exit(1);
    }
}

// Run the script
if (require.main === module) {
    setupBasicData();
}
