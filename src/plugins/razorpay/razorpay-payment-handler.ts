import { 
  LanguageCode, 
  PaymentMethodHandler, 
  CreatePaymentResult, 
  SettlePaymentResult,
  CreateRefundResult,
  Logger 
} from '@vendure/core';
import crypto from 'crypto';
import Razorpay from 'razorpay';

const loggerCtx = 'RazorpayPaymentHandler';

type RazorpayMetadata = {
  razorpay_order_id?: string;
  razorpay_payment_id?: string;
  razorpay_signature?: string;
  razorpay_order_amount?: number;
  customer_email?: string;
  [k: string]: any;
};

export const RazorpayPaymentHandler = new PaymentMethodHandler({
  code: 'razorpay',
  description: [{ 
    languageCode: LanguageCode.en, 
    value: 'Pay securely with Razorpay (Credit/Debit Cards, UPI, Net Banking, Wallets)' 
  }],
  args: {
    keyId: { 
      type: 'string',
      label: [{ languageCode: LanguageCode.en, value: 'Razorpay Key ID' }],
      description: [{ languageCode: LanguageCode.en, value: 'Your Razorpay API Key ID' }]
    },
    keySecret: { 
      type: 'string',
      label: [{ languageCode: LanguageCode.en, value: 'Razorpay Key Secret' }],
      description: [{ languageCode: LanguageCode.en, value: 'Your Razorpay API Key Secret' }]
    },
    webhookSecret: { 
      type: 'string', 
      required: false,
      label: [{ languageCode: LanguageCode.en, value: 'Webhook Secret' }],
      description: [{ languageCode: LanguageCode.en, value: 'Optional webhook secret for additional security' }]
    },
    autoSettle: { 
      type: 'boolean', 
      required: false,
      defaultValue: true,
      label: [{ languageCode: LanguageCode.en, value: 'Auto Settle' }],
      description: [{ languageCode: LanguageCode.en, value: 'Automatically settle payments upon successful verification' }]
    },
  },

  createPayment: async (ctx, order, amount, args, metadata: RazorpayMetadata): Promise<CreatePaymentResult> => {
    const { keySecret, autoSettle } = args as any;

    Logger.info(`Processing Razorpay payment for order ${order.code}`, loggerCtx);

    // Extract payment data from metadata
    const orderId = metadata?.razorpay_order_id;
    const paymentId = metadata?.razorpay_payment_id;
    const signature = metadata?.razorpay_signature;

    // Validate required fields
    if (!keySecret) {
      Logger.error('Razorpay key secret not configured', loggerCtx);
      return {
        amount,
        state: 'Declined' as const,
        metadata: { 
          reason: 'configuration-error',
          message: 'Payment method not properly configured'
        },
      };
    }

    if (!orderId || !paymentId || !signature) {
      Logger.error(`Missing required payment fields for order ${order.code}`, loggerCtx);
      return {
        amount,
        state: 'Declined' as const,
        metadata: { 
          reason: 'missing-fields',
          message: 'Required payment information missing',
          received: {
            orderId: !!orderId,
            paymentId: !!paymentId,
            signature: !!signature
          }
        },
      };
    }

    // Verify Razorpay signature
    try {
      const expected = crypto
        .createHmac('sha256', keySecret)
        .update(`${orderId}|${paymentId}`)
        .digest('hex');

      if (expected !== signature) {
        Logger.error(`Signature verification failed for order ${order.code}`, loggerCtx);
        return {
          amount,
          state: 'Declined' as const,
          metadata: { 
            reason: 'signature-mismatch',
            message: 'Payment signature verification failed'
          },
        };
      }

      Logger.info(`Payment signature verified successfully for order ${order.code}`, loggerCtx);

      // Verify amount matches (if provided in metadata)
      if (metadata.razorpay_order_amount && metadata.razorpay_order_amount !== amount) {
        Logger.warn(`Amount mismatch for order ${order.code}: expected ${amount}, got ${metadata.razorpay_order_amount}`, loggerCtx);
      }

      const paymentState = autoSettle ? 'Settled' : 'Authorized';
      Logger.info(`Payment ${paymentState.toLowerCase()} for order ${order.code}`, loggerCtx);

      return {
        amount,
        state: (autoSettle ? 'Settled' : 'Authorized') as 'Settled' | 'Authorized',
        transactionId: paymentId,
        metadata: {
          ...metadata,
          verification_status: 'verified',
          verification_time: new Date().toISOString(),
          razorpay_order_id: orderId,
          razorpay_payment_id: paymentId
        },
      };

    } catch (error: any) {
      Logger.error(`Payment processing error for order ${order.code}: ${error.message}`, loggerCtx);
      return {
        amount,
        state: 'Declined' as const,
        metadata: { 
          reason: 'processing-error',
          message: 'Payment processing failed',
          error: error.message
        },
      };
    }
  },

  settlePayment: async (ctx, order, payment, args): Promise<SettlePaymentResult> => {
    Logger.info(`Settling payment ${payment.id} for order ${order.code}`, loggerCtx);
    
    try {
      // For Razorpay, payments are typically settled immediately upon successful verification
      // This method is called when manually settling an authorized payment
      
      Logger.info(`Payment ${payment.id} settled successfully`, loggerCtx);
      
      return { 
        success: true,
        metadata: {
          settled_at: new Date().toISOString(),
          settlement_method: 'razorpay_auto'
        }
      };
    } catch (error: any) {
      Logger.error(`Settlement error for payment ${payment.id}: ${error.message}`, loggerCtx);
      
      return { 
        success: false, 
        errorMessage: `Settlement failed: ${error.message}`
      } as any;
    }
  },

  createRefund: async (ctx, input, amount, order, payment, args): Promise<CreateRefundResult> => {
    const { keyId, keySecret } = args as any;
    
    Logger.info(`Creating refund for payment ${payment.id}, amount: ${amount}`, loggerCtx);

    try {
      if (!keyId || !keySecret) {
        Logger.error('Razorpay credentials not configured for refund', loggerCtx);
        return {
          state: 'Failed' as const,
          metadata: {
            reason: 'configuration-error',
            message: 'Razorpay credentials not configured'
          }
        };
      }

      // Initialize Razorpay client
      const razorpay = new Razorpay({
        key_id: keyId,
        key_secret: keySecret,
      });

      const paymentId = payment.transactionId;
      if (!paymentId) {
        Logger.error(`No transaction ID found for payment ${payment.id}`, loggerCtx);
        return {
          state: 'Failed' as const,
          metadata: {
            reason: 'missing-transaction-id',
            message: 'No Razorpay payment ID found'
          }
        };
      }

      // Create refund via Razorpay API
      const refundData = await razorpay.payments.refund(paymentId, {
        amount: amount, // Amount in smallest currency unit
        notes: {
          refund_reason: input.reason || 'Refund requested',
          vendure_order_code: order.code,
          vendure_payment_id: payment.id.toString()
        }
      });

      Logger.info(`Refund created successfully: ${refundData.id} for payment ${payment.id}`, loggerCtx);

      return {
        state: 'Settled' as const,
        transactionId: refundData.id,
        metadata: {
          razorpay_refund_id: refundData.id,
          razorpay_payment_id: paymentId,
          refund_amount: refundData.amount,
          refund_status: refundData.status,
          created_at: refundData.created_at,
          processed_at: new Date().toISOString()
        }
      };

    } catch (error: any) {
      Logger.error(`Refund creation failed for payment ${payment.id}: ${error.message}`, loggerCtx);
      
      return {
        state: 'Failed' as const,
        metadata: {
          reason: 'refund-failed',
          message: `Refund failed: ${error.message}`,
          error_details: error.error || error.message
        }
      };
    }
  },
});
