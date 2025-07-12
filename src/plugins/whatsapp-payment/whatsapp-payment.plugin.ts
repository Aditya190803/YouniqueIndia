import { PluginCommonModule, VendurePlugin } from '@vendure/core';
import { WhatsAppPaymentHandler } from './whatsapp-payment-handler';

@VendurePlugin({
    imports: [PluginCommonModule],
    configuration: config => {
        config.paymentOptions.paymentMethodHandlers.push(WhatsAppPaymentHandler);
        return config;
    },
})
export class WhatsAppPaymentPlugin {}
