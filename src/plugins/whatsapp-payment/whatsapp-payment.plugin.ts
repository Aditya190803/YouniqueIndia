import { gql } from 'graphql-tag';
import { PluginCommonModule, VendurePlugin } from '@vendure/core';
import { WhatsappPaymentService } from './whatsapp-payment.service';
import { WhatsappPaymentResolver } from './whatsapp-payment.resolver';

const whatsappPaymentSchema = gql`
    extend type Mutation {
        createWhatsappDraftOrder(input: WhatsappDraftOrderInput!): WhatsappDraftOrderPayload!
    }

    input WhatsappDraftOrderInput {
        firstName: String!
        lastName: String
        phoneNumber: String!
        emailAddress: String
        notes: String
        lines: [WhatsappDraftOrderLineInput!]!
        shippingAddress: CreateAddressInput
        billingAddress: CreateAddressInput
    }

    input WhatsappDraftOrderLineInput {
        productVariantId: ID!
        quantity: Int!
    }

    type WhatsappDraftOrderPayload {
        order: Order!
        customer: Customer!
        createdCustomer: Boolean!
        generatedEmailAddress: String
    }
`;

@VendurePlugin({
    imports: [PluginCommonModule],
    providers: [WhatsappPaymentService],
    shopApiExtensions: {
        schema: whatsappPaymentSchema,
        resolvers: [WhatsappPaymentResolver],
    },
    adminApiExtensions: {
        schema: whatsappPaymentSchema,
        resolvers: [WhatsappPaymentResolver],
    },
})
export class WhatsappPaymentPlugin {}

export { whatsappPaymentHandler } from './whatsapp-payment.handler';
