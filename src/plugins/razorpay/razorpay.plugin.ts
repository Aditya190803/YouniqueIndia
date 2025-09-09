import { 
  PluginCommonModule, 
  VendurePlugin, 
  ActiveOrderService,
  OrderService,
  PaymentMethodService,
  Logger,
  Ctx,
  RequestContext,
  ID
} from '@vendure/core';
import { Resolver, Mutation, Args } from '@nestjs/graphql';
import { gql } from 'apollo-server-core';
import Razorpay from 'razorpay';

const loggerCtx = 'RazorpayPlugin';

// GraphQL schema extensions
// Accepts optional identifiers. If none provided, uses the active order from session.
const shopApiExtensions = gql`
  extend type Mutation {
    generateRazorpayOrderId(orderId: ID, orderCode: String): RazorpayOrderIdResult!
  }

  union RazorpayOrderIdResult = RazorpayOrderIdSuccess | RazorpayOrderIdGenerationError

  type RazorpayOrderIdSuccess {
    razorpayOrderId: String!
  }

  type RazorpayOrderIdGenerationError implements ErrorResult {
    errorCode: ErrorCode!
    message: String!
  }
`;

@Resolver()
export class RazorpayResolver {
  constructor(
    private activeOrderService: ActiveOrderService,
    private orderService: OrderService,
    private paymentMethodService: PaymentMethodService
  ) {}

  @Mutation()
  async generateRazorpayOrderId(
    @Ctx() ctx: RequestContext,
    @Args('orderId') orderId?: ID,
    @Args('orderCode') orderCode?: string
  ) {
    try {
      Logger.info(`Generating Razorpay order ID...`, loggerCtx);
      
      // Resolve order: prefer active order from session
      let order = await this.activeOrderService.getOrderFromContext(ctx);
      
      // If an explicit id/code is provided, ensure it matches the active order (to prevent tampering)
      if (!order && (orderId || orderCode)) {
        // Fall back to direct lookup, but this may be restricted on Shop API; so we only allow
        // it if it matches the active session's order (if any). If no active order, we still try
        // to find by id to support custom flows where order is attached to session.
        if (orderId) {
          order = await this.orderService.findOne(ctx, orderId);
        }
        // Note: OrderService has findOneByCode in newer Vendure versions, but to avoid version
        // mismatch, we still prefer the active order path.
      }
      
      if (!order) {
        Logger.error(`No active order found in session${orderId ? `, and order ${orderId} not accessible` : ''}`, loggerCtx);
        return {
          __typename: 'RazorpayOrderIdGenerationError',
          errorCode: 'ORDER_NOT_FOUND',
          message: `No active order found. Ensure the order is in session and in ArrangingPayment state.`
        };
      }

      // If user supplied orderId/orderCode, ensure it matches active order to avoid manipulating others' orders
    if (orderId && String(order.id) !== String(orderId)) {
        Logger.error(`Provided orderId does not match active order in session`, loggerCtx);
        return {
          __typename: 'RazorpayOrderIdGenerationError',
      errorCode: 'ORDER_MODIFICATION_ERROR',
          message: 'Provided orderId does not match the active order'
        };
      }

      // Check if order is in the correct state
      if (order.state !== 'ArrangingPayment') {
        Logger.error(`Order ${orderId} is not in ArrangingPayment state. Current state: ${order.state}`, loggerCtx);
        return {
          __typename: 'RazorpayOrderIdGenerationError',
          errorCode: 'ORDER_PAYMENT_STATE_ERROR',
          message: `Order is not in a state that allows payment. Current state: ${order.state}`
        };
      }

      // Get Razorpay configuration from payment method
      const paymentMethods = await this.paymentMethodService.findAll(ctx);
      const razorpayMethod = paymentMethods.items.find(method => method.code === 'razorpay');
      
      if (!razorpayMethod || !razorpayMethod.enabled) {
        Logger.error('Razorpay payment method not found or not enabled', loggerCtx);
        return {
          __typename: 'RazorpayOrderIdGenerationError',
          errorCode: 'PAYMENT_METHOD_MISSING',
          message: 'Razorpay payment method not found or not enabled'
        };
      }

  const keyId = razorpayMethod.handler.args.find(arg => arg.name === 'keyId')?.value;
  const keySecret = razorpayMethod.handler.args.find(arg => arg.name === 'keySecret')?.value;

      if (!keyId || !keySecret) {
        Logger.error('Razorpay credentials not configured', loggerCtx);
        return {
          __typename: 'RazorpayOrderIdGenerationError',
          errorCode: 'PAYMENT_METHOD_MISSING',
          message: 'Razorpay credentials not properly configured'
        };
      }

      // Initialize Razorpay client
      const razorpay = new Razorpay({
        key_id: keyId,
        key_secret: keySecret,
      });

      // Create Razorpay order
  const razorpayOrder = await razorpay.orders.create({
        amount: order.totalWithTax, // Amount in smallest currency unit (paise for INR)
        currency: 'INR',
        receipt: `order_${order.code}`,
        notes: {
          vendure_order_id: order.id.toString(),
          vendure_order_code: order.code,
          customer_email: order.customer?.emailAddress || '',
          customer_id: order.customer?.id?.toString() || '',
        }
      });

      // Store the Razorpay order ID in the order's custom fields
      await this.orderService.updateCustomFields(ctx, order.id, {
        razorpay_order_id: razorpayOrder.id
      });

  Logger.info(`Razorpay order created successfully: ${razorpayOrder.id} for Vendure order: ${order.id}`, loggerCtx);

      return {
        __typename: 'RazorpayOrderIdSuccess',
        razorpayOrderId: razorpayOrder.id
      };

    } catch (error: any) {
      Logger.error(`Failed to generate Razorpay order ID for order ${orderId}: ${error.message}`, loggerCtx);
      return {
        __typename: 'RazorpayOrderIdGenerationError',
        errorCode: 'UNKNOWN_ERROR',
        message: `Failed to generate Razorpay order ID: ${error.message}`
      };
    }
  }
}

@VendurePlugin({
  imports: [PluginCommonModule],
  providers: [RazorpayResolver],
  configuration: config => {
    // Add custom field for storing Razorpay order ID
    config.customFields = config.customFields || {};
    config.customFields.Order = config.customFields.Order || [];
    
    config.customFields.Order.push({
      name: 'razorpay_order_id',
      type: 'string',
      nullable: true,
      public: false,
      readonly: true,
      internal: true,
      label: [{ languageCode: 'en' as any, value: 'Razorpay Order ID' }],
      description: [{ languageCode: 'en' as any, value: 'The Razorpay order ID associated with this order' }],
    });

    return config;
  },
  shopApiExtensions: {
    schema: shopApiExtensions,
    resolvers: [RazorpayResolver],
  },
})
export class RazorpayPlugin {}
