import { LanguageCode, ShippingEligibilityChecker } from '@vendure/core';

/**
 * Always returns true so the free shipping method is universally eligible.
 * You are baking shipping cost into product prices, so we avoid any address-based filtering.
 */
export const indiaShippingEligibilityChecker = new ShippingEligibilityChecker({
  code: 'india-shipping-eligibility', // keep same code so existing shipping method keeps working
  description: [
    { languageCode: LanguageCode.en, value: 'Always eligible free shipping' },
  ],
  args: {},
  check: () => true,
});
