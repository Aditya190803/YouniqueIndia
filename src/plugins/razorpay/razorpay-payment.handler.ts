import { LanguageCode, PaymentMethodHandler } from '@vendure/core';
import crypto from 'crypto';

type RazorpayMetadata = {
  razorpay_order_id?: string;
  razorpay_payment_id?: string;
  razorpay_signature?: string;
  [k: string]: any;
};

export const RazorpayPaymentHandler = new PaymentMethodHandler({
  code: 'razorpay',
  description: [{ languageCode: LanguageCode.en, value: 'Razorpay Checkout' }],
  args: {
    keyId: { type: 'string' },
    keySecret: { type: 'string' },
    webhookSecret: { type: 'string', required: false },
    autoSettle: { type: 'boolean', required: false },
  },
  createPayment: async (ctx, order, amount, args, metadata: RazorpayMetadata) => {
    const { keySecret, autoSettle } = args as any;

    const orderId = metadata?.razorpay_order_id;
    const paymentId = metadata?.razorpay_payment_id;
    const signature = metadata?.razorpay_signature;

    if (!keySecret || !orderId || !paymentId || !signature) {
      return {
        amount,
        state: 'Declined' as const,
        metadata: { reason: 'missing-fields' },
      };
    }

    const expected = crypto
      .createHmac('sha256', keySecret)
      .update(`${orderId}|${paymentId}`)
      .digest('hex');

    if (expected !== signature) {
      return {
        amount,
        state: 'Declined' as const,
        metadata: { reason: 'signature-mismatch' },
      };
    }

    return {
      amount,
      state: autoSettle ? 'Settled' : 'Authorized',
      transactionId: paymentId,
      metadata,
    };
  },
  // If autoSettle was used, this is a no-op.
  settlePayment: async () => ({ success: true }),
});
