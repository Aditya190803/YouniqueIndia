import { LanguageCode, PaymentMethodHandler } from '@vendure/core';

/**
 * Payment handler for Cash on Delivery (COD) / Cash payments
 * This handler allows orders to be placed with cash payment
 */
export const cashPaymentHandler = new PaymentMethodHandler({
    code: 'cash-payment',
    description: [
        {
            languageCode: LanguageCode.en,
            value: 'Cash Payment / Cash on Delivery (COD)',
        },
    ],
    args: {
        notes: {
            type: 'string',
            label: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Payment Notes',
                },
            ],
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Additional notes about the cash payment',
                },
            ],
            required: false,
        },
    },
    createPayment: async (ctx, order, amount, args, metadata) => {
        return {
            amount,
            state: 'Authorized' as const,
            transactionId: `cash-${order.code}-${Date.now()}`,
            metadata: {
                paymentMethod: 'Cash/COD',
                notes: args.notes,
                customData: metadata,
            },
        };
    },
    settlePayment: async () => {
        // For COD, settlement happens when cash is collected on delivery
        return { success: true };
    },
});
