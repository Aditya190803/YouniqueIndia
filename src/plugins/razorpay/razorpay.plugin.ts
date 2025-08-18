import { PluginCommonModule, VendurePlugin, RequestContext, Ctx, OrderService } from '@vendure/core';
import { Resolver, Mutation } from '@nestjs/graphql';
import { gql } from 'graphql-tag';
import Razorpay from 'razorpay';

/**
 * GraphQL return type for creating a Razorpay order.
 */
export interface RazorpayOrderResponse {
  id: string;
  amount: number; // amount in smallest currency unit (paise)
  currency: string;
  key: string; // public key id for client checkout
  receipt?: string;
}

@Resolver()
class RazorpayResolver {
  constructor(private orderService: OrderService) {}

  /**
   * Internal helper to create a Razorpay order from the current active Vendure order.
   */
  private async create(ctx: RequestContext): Promise<RazorpayOrderResponse> {
    const userId = ctx.activeUserId;
    if (!userId) {
      throw new Error('Not authenticated');
    }
    const order = await this.orderService.getActiveOrderForUser(ctx, userId);
    if (!order || order.totalWithTax === 0) {
      throw new Error('No active order to create Razorpay payment for');
    }
    if (order.currencyCode !== 'INR') {
      throw new Error('Razorpay integration currently supports only INR currency');
    }
    const keyId = process.env.RAZORPAY_KEY_ID || process.env.RAZORPAY_KEY || process.env.key_id || '';
    const keySecret = process.env.RAZORPAY_KEY_SECRET || process.env.RAZORPAY_SECRET || process.env.key_secret || '';
    if (!keyId || !keySecret) {
      throw new Error('Razorpay environment variables not configured');
    }
    const rp = new Razorpay({ key_id: keyId, key_secret: keySecret });
    const rpOrder = await rp.orders.create({
      amount: order.totalWithTax, // Vendure stores amounts in minor units, Razorpay expects paise
      currency: order.currencyCode,
      receipt: order.code,
      notes: { orderCode: order.code, orderId: order.id.toString() },
    });
    return {
      id: rpOrder.id,
      amount: Number(rpOrder.amount),
      currency: rpOrder.currency,
      key: keyId,
      receipt: rpOrder.receipt,
    };
  }

  @Mutation(() => Object)
  async createRazorpayOrder(@Ctx() ctx: RequestContext): Promise<RazorpayOrderResponse> {
    return this.create(ctx);
  }

  // Backwards compatibility with docs referencing generateRazorpayOrderId
  @Mutation(() => Object)
  async generateRazorpayOrderId(@Ctx() ctx: RequestContext): Promise<RazorpayOrderResponse> {
    return this.create(ctx);
  }
}

@VendurePlugin({
  imports: [PluginCommonModule],
  shopApiExtensions: {
    schema: gql/* GraphQL */`
      type RazorpayOrderResponse {
        id: String!
        amount: Int!
        currency: String!
        key: String!
        receipt: String
      }
      extend type Mutation {
        createRazorpayOrder: RazorpayOrderResponse!
        generateRazorpayOrderId: RazorpayOrderResponse! # alias for frontend expectation
      }
    `,
    resolvers: [RazorpayResolver],
  },
})
export class RazorpayPlugin {}
