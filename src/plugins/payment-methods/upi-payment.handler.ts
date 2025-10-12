import { LanguageCode, PaymentMethodHandler } from '@vendure/core';

/**
 * Payment handler for UPI (Unified Payments Interface) payments
 * This handler allows manual confirmation of UPI payments in the admin
 */
export const upiPaymentHandler = new PaymentMethodHandler({
    code: 'upi-payment',
    description: [
        {
            languageCode: LanguageCode.en,
            value: 'UPI Payment (PhonePe, Google Pay, Paytm, etc.)',
        },
    ],
    args: {
        upiId: {
            type: 'string',
            label: [
                {
                    languageCode: LanguageCode.en,
                    value: 'UPI Transaction ID',
                },
            ],
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Enter the UPI transaction reference number',
                },
            ],
            required: false,
        },
    },
    createPayment: async (ctx, order, amount, args, metadata) => {
        return {
            amount,
            state: 'Authorized' as const,
            transactionId: args.upiId || `upi-${order.code}-${Date.now()}`,
            metadata: {
                paymentMethod: 'UPI',
                upiTransactionId: args.upiId,
                customData: metadata,
            },
        };
    },
    settlePayment: async () => {
        // Manual settlement - admin confirms payment was received
        return { success: true };
    },
});
