import { LanguageCode, PaymentMethodHandler } from '@vendure/core';

/**
 * Payment handler for Card payments (Credit/Debit Card)
 * This handler allows manual confirmation of card payments in the admin
 */
export const cardPaymentHandler = new PaymentMethodHandler({
    code: 'card-payment',
    description: [
        {
            languageCode: LanguageCode.en,
            value: 'Card Payment (Credit Card / Debit Card)',
        },
    ],
    args: {
        transactionId: {
            type: 'string',
            label: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Card Transaction ID',
                },
            ],
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Enter the card transaction reference number',
                },
            ],
            required: false,
        },
        last4Digits: {
            type: 'string',
            label: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Last 4 digits of card',
                },
            ],
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Last 4 digits of the card used (optional)',
                },
            ],
            required: false,
        },
    },
    createPayment: async (ctx, order, amount, args, metadata) => {
        return {
            amount,
            state: 'Authorized' as const,
            transactionId: args.transactionId || `card-${order.code}-${Date.now()}`,
            metadata: {
                paymentMethod: 'Card',
                cardTransactionId: args.transactionId,
                cardLast4: args.last4Digits,
                customData: metadata,
            },
        };
    },
    settlePayment: async () => {
        // Manual settlement - admin confirms payment was received
        return { success: true };
    },
});
