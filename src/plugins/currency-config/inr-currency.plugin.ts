import { PluginCommonModule, VendurePlugin } from '@vendure/core';
import { CurrencyCode } from '@vendure/common/lib/generated-types';
import { CurrencyService } from './currency.service';

/**
 * Plugin to configure INR as the primary and only currency for the YouniqueIndia store
 */
@VendurePlugin({
    imports: [PluginCommonModule],
    providers: [CurrencyService],
    exports: [CurrencyService],
})
export class InrCurrencyPlugin {
    static options = {
        // INR currency configuration
        defaultCurrency: CurrencyCode.INR,
        availableCurrencies: [CurrencyCode.INR],
        symbol: '₹',
        precision: 2,
        // Enable currency conversion if needed (disabled by default for single currency)
        enableCurrencyConversion: false,
    };
}
