import { 
  PluginCommonModule, 
  VendurePlugin, 
  ActiveOrderService,
  Ctx,
  RequestContext
} from '@vendure/core';
import { Resolver, Mutation } from '@nestjs/graphql';
import { gql } from 'apollo-server-core';
import Razorpay from 'razorpay';

const shopApiExtensions = gql`
  extend type Mutation {
    createRazorpayOrder: RazorpayOrderResult!
  }

  type RazorpayOrderResult {
    id: String!
    amount: Int!
    currency: String!
    key: String!
    receipt: String
  }
`;

@Resolver()
export class RazorpayResolver {
  constructor(private activeOrderService: ActiveOrderService) {}

  @Mutation(() => String)
  async createRazorpayOrder(@Ctx() ctx: RequestContext) {
    // Get the current active order
    const order = await this.activeOrderService.getOrderFromContext(ctx);
    
    if (!order) {
      throw new Error('No active order found');
    }

    // Initialize Razorpay client
    const razorpay = new Razorpay({
      key_id: process.env.RAZORPAY_KEY_ID!,
      key_secret: process.env.RAZORPAY_KEY_SECRET!,
    });

    // Create Razorpay order
    const razorpayOrder = await razorpay.orders.create({
      amount: order.totalWithTax, // Amount in paise
      currency: 'INR',
      receipt: `order_${order.code}`,
      notes: {
        vendure_order_id: order.id.toString(),
        vendure_order_code: order.code,
        customer_email: order.customer?.emailAddress || '',
      }
    });

    return {
      id: razorpayOrder.id,
      amount: razorpayOrder.amount,
      currency: razorpayOrder.currency,
      key: process.env.RAZORPAY_KEY_ID!,
      receipt: razorpayOrder.receipt,
    };
  }
}

@VendurePlugin({
  imports: [PluginCommonModule],
  providers: [RazorpayResolver],
  shopApiExtensions: {
    schema: shopApiExtensions,
    resolvers: [RazorpayResolver],
  },
})
export class RazorpayGraphQLPlugin {}
