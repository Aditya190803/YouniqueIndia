import { FulfillmentHandler, LanguageCode } from '@vendure/core';
export const indiaManualFulfillmentHandler = new FulfillmentHandler({
    code: 'india-manual-fulfillment',
    description: [
        {
            languageCode: LanguageCode.en,
            value: 'Manual fulfillment with courier selection',
        },
    ],
    args: {
        method: {
            type: 'string',
            defaultValue: 'India Post',
            label: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Courier Provider',
                },
            ],
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Select the courier/logistics provider',
                },
            ],
        },
        trackingCode: {
            type: 'string',
            label: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Tracking Number / AWB',
                },
            ],
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Enter the shipment tracking number',
                },
            ],
            required: false,
        },
        notes: {
            type: 'string',
            label: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Fulfillment Notes',
                },
            ],
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Additional notes about the fulfillment',
                },
            ],
            required: false,
        },
    },
    createFulfillment: async (ctx, orders, lines, args) => {
        return {
            method: args.method || 'India Post',
            trackingCode: args.trackingCode || '',
        };
    },
});

export const indianCourierHandlers = [indiaManualFulfillmentHandler];
