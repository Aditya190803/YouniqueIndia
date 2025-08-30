import { LanguageCode, ShippingEligibilityChecker } from '@vendure/core';

export const indiaShippingEligibilityChecker = new ShippingEligibilityChecker({
  code: 'india-shipping-eligibility', // keep same code so existing shipping method keeps working
  description: [
    { languageCode: LanguageCode.en, value: 'Always eligible free shipping' },
  ],
  args: {},
  check: () => true,
});
