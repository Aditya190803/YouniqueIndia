import {
  CreatePaymentErrorResult,
  CreatePaymentResult,
  Logger,
  PaymentMethodHandler,
  SettlePaymentErrorResult,
  SettlePaymentResult,
  LanguageCode,
} from '@vendure/core';
import crypto from 'crypto';

export const RazorpayPaymentHandler = new PaymentMethodHandler({
  code: 'razorpay',
  description: [{ languageCode: LanguageCode.en, value: 'Razorpay payment gateway' }],
  args: {
    razorpayKeyId: {
      type: 'string',
      label: [{ languageCode: LanguageCode.en, value: 'Razorpay Key ID' }],
      description: [{ languageCode: LanguageCode.en, value: 'Public key (used on the client side)' }],
    },
    razorpayKeySecret: {
      type: 'string',
      label: [{ languageCode: LanguageCode.en, value: 'Razorpay Key Secret' }],
      description: [{ languageCode: LanguageCode.en, value: 'Secret key used to verify signatures' }],
      required: true,
    },
  },
  /**
   * Expects metadata from storefront: {
   *   razorpay_payment_id: string,
   *   razorpay_order_id: string,
   *   razorpay_signature: string
   * }
   */
  createPayment: async (
    ctx,
    order,
    amount,
    args,
    metadata,
  ): Promise<CreatePaymentResult | CreatePaymentErrorResult> => {
    try {
      const paymentId = (metadata as any)?.razorpay_payment_id as string | undefined;
      const orderId = (metadata as any)?.razorpay_order_id as string | undefined;
      const signature = (metadata as any)?.razorpay_signature as string | undefined;
      if (!paymentId || !orderId || !signature) {
        return {
          amount,
          state: 'Declined',
          metadata: {
            error: 'Missing Razorpay parameters',
          },
        };
      }

      const secret = args['razorpayKeySecret'] as string;
      const expected = crypto
        .createHmac('sha256', secret)
        .update(`${orderId}|${paymentId}`)
        .digest('hex');

      if (expected !== signature) {
        Logger.warn(
          `Razorpay signature verification failed for order ${order.code}`,
          'RazorpayPaymentHandler',
        );
        return {
          amount,
          state: 'Declined',
          metadata: {
            error: 'Invalid signature',
          },
        };
      }

      // Signature is valid. Mark payment as Settled.
      return {
        amount,
        state: 'Settled',
        transactionId: paymentId,
        metadata: {
          razorpay_order_id: orderId,
        },
      };
    } catch (e: any) {
      Logger.error(e?.message ?? String(e), 'RazorpayPaymentHandler');
      return {
        amount,
        state: 'Declined',
        metadata: { error: 'Exception during Razorpay verification' },
      };
    }
  },
  settlePayment: async (): Promise<SettlePaymentResult | SettlePaymentErrorResult> => {
    return { success: true };
  },
});
