import {
    CreatePaymentResult,
    PaymentMethodHandler,
    Logger,
    LanguageCode,
    Order,
    OrderLine,
    CreatePaymentErrorResult,
    SettlePaymentResult,
    SettlePaymentErrorResult,
    RequestContext,
} from '@vendure/core';

export const WhatsAppPaymentHandler = new PaymentMethodHandler({
    code: 'whatsapp-payment',
    description: [
        {
            languageCode: LanguageCode.en,
            value: 'WhatsApp Payment - Send order details via WhatsApp',
        },
    ],
    args: {
        whatsappNumber: {
            type: 'string',
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'WhatsApp number to send order details (with country code, e.g., +91xxxxxxxxxx)',
                },
            ],
        },
        businessName: {
            type: 'string',
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Business name to display in the message',
                },
            ],
        },
        customMessage: {
            type: 'string',
            description: [
                {
                    languageCode: LanguageCode.en,
                    value: 'Custom message template (optional)',
                },
            ],
            required: false,
        },
    },

    createPayment: async (
        ctx: RequestContext,
        order: Order,
        amount: number,
        args: any,
        metadata: any,
    ): Promise<CreatePaymentResult | CreatePaymentErrorResult> => {
        try {
            // Format the order details for WhatsApp
            const orderDetails = formatOrderForWhatsApp(order, args);
            
            // Create WhatsApp URL
            const whatsappUrl = createWhatsAppUrl(args.whatsappNumber, orderDetails);
            
            Logger.info(`WhatsApp payment initiated for order ${order.code}`, 'WhatsAppPaymentHandler');
            Logger.info(`WhatsApp URL: ${whatsappUrl}`, 'WhatsAppPaymentHandler');
            
            // Return success - the payment will be settled manually after WhatsApp confirmation
            return {
                amount,
                state: 'Authorized' as const,
                metadata: {
                    whatsappUrl,
                    whatsappNumber: args.whatsappNumber,
                    orderDetails,
                    timestamp: new Date().toISOString(),
                },
            };
        } catch (error: any) {
            Logger.error(`WhatsApp payment failed for order ${order.code}: ${error?.message || error}`, 'WhatsAppPaymentHandler');
            return {
                amount,
                state: 'Declined' as const,
                metadata: {
                    error: error?.message || 'Unknown error',
                },
            };
        }
    },

    settlePayment: async (
        ctx: RequestContext,
        order: Order,
        payment: any,
        args: any,
    ): Promise<SettlePaymentResult | SettlePaymentErrorResult> => {
        // This will be called when the payment is manually settled in the admin
        Logger.info(`WhatsApp payment settled for order ${order.code}`, 'WhatsAppPaymentHandler');
        return {
            success: true,
            metadata: {
                settledAt: new Date().toISOString(),
            },
        };
    },
});

function formatOrderForWhatsApp(order: Order, args: any): string {
    const businessName = args.businessName || 'YouniqueIndia';
    
    let message = `🙏 *New Order from ${businessName}*\n\n`;
    message += `📋 *Order Details:*\n`;
    message += `Order ID: ${order.code}\n`;
    message += `Date: ${new Date().toLocaleDateString('en-IN')}\n\n`;
    
    message += `👤 *Customer Details:*\n`;
    if (order.customer) {
        message += `Name: ${order.customer.firstName} ${order.customer.lastName}\n`;
        message += `Email: ${order.customer.emailAddress}\n`;
    }
    
    if (order.shippingAddress) {
        message += `Phone: ${order.shippingAddress.phoneNumber || 'Not provided'}\n`;
        message += `Address: ${order.shippingAddress.streetLine1}, ${order.shippingAddress.city}, ${order.shippingAddress.postalCode}\n`;
    }
    
    message += `\n🛍️ *Items Ordered:*\n`;
    order.lines.forEach((line: OrderLine, index: number) => {
        message += `${index + 1}. ${line.productVariant.name}\n`;
        message += `   Quantity: ${line.quantity}\n`;
        message += `   Price: ₹${(line.unitPriceWithTax / 100).toLocaleString('en-IN')}\n`;
        message += `   Total: ₹${(line.linePriceWithTax / 100).toLocaleString('en-IN')}\n\n`;
    });
    
    message += `💰 *Order Summary:*\n`;
    message += `Subtotal: ₹${(order.subTotalWithTax / 100).toLocaleString('en-IN')}\n`;
    if (order.shippingWithTax > 0) {
        message += `Shipping: ₹${(order.shippingWithTax / 100).toLocaleString('en-IN')}\n`;
    }
    message += `*Total: ₹${(order.totalWithTax / 100).toLocaleString('en-IN')}*\n\n`;
    
    message += `📞 Please confirm this order and provide payment instructions.\n`;
    message += `Thank you for choosing ${businessName}! 🙏`;
    
    return message;
}

function createWhatsAppUrl(phoneNumber: string, message: string): string {
    const encodedMessage = encodeURIComponent(message);
    const cleanPhoneNumber = phoneNumber.replace(/[^\d+]/g, '');
    return `https://wa.me/${cleanPhoneNumber}?text=${encodedMessage}`;
}
