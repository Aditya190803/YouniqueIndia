/**
 * Utility functions for formatting INR currency in the YouniqueIndia store
 */

/**
 * Format a monetary value in INR currency
 * @param value - The monetary value as an integer (minor units)
 * @param locale - The locale to use for formatting (defaults to 'en-IN')
 * @returns Formatted currency string
 */
export function formatInrCurrency(value: number, locale = 'en-IN'): string {
    // Convert from minor units (paise) to major units (rupees)
    const majorUnits = value / 100;
    
    try {
        return new Intl.NumberFormat(locale, {
            style: 'currency',
            currency: 'INR',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
        }).format(majorUnits);
    } catch (e) {
        // Fallback formatting if Intl.NumberFormat fails
        return `₹${majorUnits.toFixed(2)}`;
    }
}

/**
 * Format a monetary value in INR currency without decimals for whole numbers
 * @param value - The monetary value as an integer (minor units)
 * @param locale - The locale to use for formatting (defaults to 'en-IN')
 * @returns Formatted currency string
 */
export function formatInrCurrencyCompact(value: number, locale = 'en-IN'): string {
    const majorUnits = value / 100;
    const isWholeNumber = majorUnits % 1 === 0;
    
    try {
        return new Intl.NumberFormat(locale, {
            style: 'currency',
            currency: 'INR',
            minimumFractionDigits: isWholeNumber ? 0 : 2,
            maximumFractionDigits: 2,
        }).format(majorUnits);
    } catch (e) {
        // Fallback formatting
        return isWholeNumber 
            ? `₹${majorUnits.toFixed(0)}` 
            : `₹${majorUnits.toFixed(2)}`;
    }
}

/**
 * Convert a price in rupees to the minor unit (paise) for storage
 * @param rupees - The price in rupees
 * @returns The price in paise (minor units)
 */
export function rupeesToPaise(rupees: number): number {
    return Math.round(rupees * 100);
}

/**
 * Convert a price in paise to rupees for display
 * @param paise - The price in paise (minor units)
 * @returns The price in rupees
 */
export function paiseToRupees(paise: number): number {
    return paise / 100;
}

/**
 * Validate if a price is valid for INR currency
 * @param price - The price to validate
 * @returns True if the price is valid
 */
export function isValidInrPrice(price: number): boolean {
    return price >= 0 && Number.isInteger(price) && Number.isFinite(price);
}

// USD conversion function removed - not needed for fresh INR-only setup

/**
 * Format large amounts in Indian numbering system (lakhs, crores)
 * @param value - The monetary value as an integer (minor units)
 * @param locale - The locale to use for formatting (defaults to 'en-IN')
 * @returns Formatted currency string with Indian numbering
 */
export function formatInrCurrencyIndian(value: number, locale = 'en-IN'): string {
    const majorUnits = value / 100;
    
    try {
        return new Intl.NumberFormat(locale, {
            style: 'currency',
            currency: 'INR',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
            // Use Indian numbering system
            numberingSystem: 'latn',
        }).format(majorUnits);
    } catch (e) {
        // Fallback with manual Indian formatting
        return formatInrCurrencyManual(majorUnits);
    }
}

/**
 * Manual formatting for Indian numbering system
 * @param rupees - Amount in rupees
 * @returns Formatted string with Indian numbering
 */
function formatInrCurrencyManual(rupees: number): string {
    const formatted = rupees.toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
    return `₹${formatted}`;
}
