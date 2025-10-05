import { LanguageCode, PaymentMethodHandler } from '@vendure/core';
import { WhatsappPaymentService } from './whatsapp-payment.service';
import { WhatsappPaymentMetadata } from './whatsapp-payment.types';

let whatsappPaymentService: WhatsappPaymentService | undefined;

export function registerWhatsappPaymentService(service: WhatsappPaymentService) {
    whatsappPaymentService = service;
}

export const whatsappPaymentHandler = new PaymentMethodHandler({
    code: 'whatsapp-payment',
    description: [
        {
            languageCode: LanguageCode.en,
            value: 'WhatsApp manual payment',
        },
    ],
    args: {},
    createPayment: async (ctx, order, amount, args, metadata) => {
        if (!whatsappPaymentService) {
            throw new Error('WhatsApp payment service has not been initialized');
        }

        const paymentMetadata = (metadata ?? {}) as WhatsappPaymentMetadata;
        const preparationResult = await whatsappPaymentService.prepareWhatsappOrderTransactional(
            ctx,
            order,
            paymentMetadata,
        );

        return {
            amount: preparationResult.order.totalWithTax ?? amount,
            state: 'Authorized',
            transactionId: `whatsapp-${preparationResult.order.code}`,
            metadata: {
                customerId: preparationResult.customer.id,
                whatsappPhone: paymentMetadata.phoneNumber,
                notes: paymentMetadata.notes ?? null,
                generatedEmail: preparationResult.generatedEmailAddress ?? null,
                draftOrderId: preparationResult.order.id,
                draftOrderCode: preparationResult.order.code,
            },
        };
    },
    settlePayment: async () => {
        return { success: true };
    },
});
