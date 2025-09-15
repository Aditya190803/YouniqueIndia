import { LanguageCode, ShippingEligibilityChecker } from '@vendure/core';

/**
 * Always eligible free shipping – shipping cost baked into product pricing.
 */
export const alwaysFreeShippingEligibilityChecker = new ShippingEligibilityChecker({
  code: 'always-free-shipping',
  description: [
    { languageCode: LanguageCode.en, value: 'Always eligible free shipping' },
  ],
  args: {},
  check: () => true,
});
