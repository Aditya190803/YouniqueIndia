import { bootstrap, ChannelService, CountryService, TaxCategoryService, ZoneService, ShippingMethodService, PaymentMethodService, TransactionalConnection, LanguageCode, CurrencyCode } from '@vendure/core';
import { alwaysFreeShippingEligibilityChecker } from '../plugins/shipping/always-free-shipping-checker';
import { config } from '../vendure-config';

/**
 * Sets up basic data required for the store to function
 */
async function setupBasicData() {
    console.log('🚀 Setting up basic store data...');
    
    try {
        const app = await bootstrap(config);
        const connection = app.get(TransactionalConnection);
        
    await connection.withTransaction(async (ctx: any) => {
            const channelService = app.get(ChannelService);
            const countryService = app.get(CountryService);
            const zoneService = app.get(ZoneService);
            const taxCategoryService = app.get(TaxCategoryService);
            const shippingMethodService = app.get(ShippingMethodService);
            const paymentMethodService = app.get(PaymentMethodService);
            
            let india: any = null;
            let indiaZone: any = null;
            try {
                console.log('🌍 Setting up countries...');
                try {
                    india = await (countryService as any).findOneByCode?.(ctx, 'IN');
                } catch (e:any) {
                    // treat as not found/unsupported; continue
                    india = null;
                }
                if (!india) {
                    try {
                        india = await countryService.create(ctx, {
                            code: 'IN',
                            translations: [ { languageCode: LanguageCode.en, name: 'India' } ],
                            enabled: true,
                        });
                        console.log('✅ Created country India');
                    } catch (e:any) {
                        console.log('⚠️  Could not create country India (continuing):', e?.message);
                    }
                } else {
                    console.log('ℹ️ Country India already exists');
                }
                console.log('🗺️  Setting up zones...');
                if (india?.id) {
                    try {
                        indiaZone = await (zoneService as any).findAll?.(ctx).then((r:any)=> r.items.find((z:any)=> z.name==='India'));
                        if (!indiaZone) {
                            try {
                                indiaZone = await zoneService.create(ctx, { name: 'India', memberIds: [india.id] });
                                console.log('✅ Created zone India');
                            } catch (e:any) {
                                indiaZone = await (zoneService as any).findAll?.(ctx).then((r:any)=> r.items.find((z:any)=> z.name==='India'));
                            }
                        } else {
                            console.log('ℹ️ Zone India already exists');
                        }
                    } catch (e:any) {
                        console.log('⚠️  Could not set up India zone (continuing):', e?.message);
                    }
                } else {
                    console.log('⚠️  Skipping zone creation (no India country)');
                }
            } catch (outer:any) {
                console.log('⚠️  Country/zone setup skipped due to error:', outer?.message);
            }
            
            console.log('💰 Setting up tax categories...');
            
            // Ensure tax-free category exists (idempotent)
            let noTax = await (taxCategoryService as any).findAll?.(ctx).then((r:any)=> r.items.find((c:any)=> c.name==='Tax Free'));
            if (!noTax) {
                try {
                    noTax = await taxCategoryService.create(ctx, { name: 'Tax Free', isDefault: true });
                    console.log('✅ Created Tax Free category');
                } catch (e:any) {
                    noTax = await (taxCategoryService as any).findAll?.(ctx).then((r:any)=> r.items.find((c:any)=> c.name==='Tax Free'));
                }
            } else {
                console.log('ℹ️ Tax Free category already exists');
            }
            
            console.log('🚚 Ensuring universal free shipping method exists...');
            try {
                await shippingMethodService.create(ctx, {
                    code: 'free-shipping',
                    translations: [
                        {
                            languageCode: LanguageCode.en,
                            name: 'Free Shipping',
                            description: 'Shipping cost included in product price'
                        }
                    ],
                    fulfillmentHandler: 'india-manual-fulfillment',
                    checker: {
                        code: alwaysFreeShippingEligibilityChecker.code,
                        arguments: []
                    },
                    calculator: {
                        code: 'default-shipping-calculator',
                        arguments: [
                            { name: 'rate', value: '0' },
                            { name: 'includesTax', value: 'exclude' },
                            { name: 'taxRate', value: '0' }
                        ]
                    },
                });
                console.log('✅ Free shipping method ensured (implicitly enabled by creation)');
                console.log('✅ Free shipping method created');
            } catch (e: any) {
                if (/(duplicate|unique)/i.test(e?.message || '')) {
                    console.log('ℹ️  Free shipping method already exists');
                } else {
                    throw e;
                }
            }

            // Optional: create a placeholder PaymentMethod using Pinelab's settleWithoutPaymentHandler
            try {
                const existing = await (paymentMethodService as any).findAll?.(ctx).then((r:any)=> r.items.find((pm:any)=> pm.code==='settle-without-payment'));
                if (!existing) {
                    await paymentMethodService.create(ctx, {
                        code: 'settle-without-payment',
                        translations: [
                            {
                                languageCode: LanguageCode.en,
                                name: 'Settle without payment',
                                description: 'For whitelisted customers/groups; settles immediately.'
                            }
                        ],
                        handler: {
                            // Use the handler code as registered by the plugin
                            code: 'settleWithoutPaymentHandler',
                            arguments: []
                        },
                        enabled: true,
                    } as any);
                    console.log('✅ Created "Settle without payment" PaymentMethod (configure eligibility in Admin)');
                } else {
                    console.log('ℹ️  "Settle without payment" PaymentMethod already exists');
                }
            } catch (e:any) {
                console.log('⚠️  Could not create default "Settle without payment" method (you can add it in Admin):', e?.message);
            }

            try {
                const defaultChannel = await channelService.getDefaultChannel(ctx);
                await channelService.update(ctx, {
                    id: defaultChannel.id,
                    defaultCurrencyCode: CurrencyCode.INR,
                    availableCurrencyCodes: [CurrencyCode.INR],
                    // @ts-ignore attempt to set zones; falls back silently if unsupported keys
                    defaultTaxZoneId: indiaZone?.id,
                    defaultShippingZoneId: indiaZone?.id,
                } as any);
                console.log('✅ Updated channel: INR currency & India as default tax/shipping zone');
            } catch (e:any) {
                console.log('⚠️  Channel update (currency/zones) partial/failed (continuing):', e?.message);
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
