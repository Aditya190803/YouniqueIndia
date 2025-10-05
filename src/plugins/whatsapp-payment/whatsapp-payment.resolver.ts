import { Args, Mutation, Resolver } from '@nestjs/graphql';
import { Allow, Ctx, Permission, RequestContext, Transaction } from '@vendure/core';
import { WhatsappPaymentService } from './whatsapp-payment.service';
import { WhatsappDraftOrderInput } from './whatsapp-payment.types';

@Resolver()
export class WhatsappPaymentResolver {
    constructor(private readonly whatsappPaymentService: WhatsappPaymentService) {}

    @Mutation('createWhatsappDraftOrder')
    @Allow(Permission.Public)
    @Transaction()
    async createWhatsappDraftOrder(
        @Ctx() ctx: RequestContext,
        @Args('input') input: WhatsappDraftOrderInput,
    ) {
        const result = await this.whatsappPaymentService.createDraftOrder(ctx, input);
        return {
            order: result.order,
            customer: result.customer,
            createdCustomer: result.createdCustomer,
            generatedEmailAddress: result.generatedEmailAddress ?? null,
        };
    }
}
