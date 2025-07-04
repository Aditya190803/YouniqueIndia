import { Injectable } from '@nestjs/common';
import { CurrencyCode } from '@vendure/common/lib/generated-types';

@Injectable()
export class CurrencyService {
    private readonly defaultCurrency: CurrencyCode = CurrencyCode.INR;
    private readonly availableCurrencies: CurrencyCode[] = [CurrencyCode.INR];
    private readonly currencySymbol = '₹';
    private readonly precision = 2;

    /**
     * Get the default currency code
     */
    getDefaultCurrency(): CurrencyCode {
        return this.defaultCurrency;
    }

    /**
     * Get all available currencies
     */
    getAvailableCurrencies(): CurrencyCode[] {
        return this.availableCurrencies;
    }

    /**
     * Get the currency symbol
     */
    getCurrencySymbol(): string {
        return this.currencySymbol;
    }

    /**
     * Get the currency precision (decimal places)
     */
    getCurrencyPrecision(): number {
        return this.precision;
    }

    /**
     * Format a price in INR
     */
    formatPrice(price: number): string {
        return `${this.currencySymbol}${price.toFixed(this.precision)}`;
    }

    /**
     * Check if a currency code is supported
     */
    isCurrencySupported(currencyCode: CurrencyCode): boolean {
        return this.availableCurrencies.includes(currencyCode);
    }
}
