import { CreateAddressInput } from '@vendure/common/lib/generated-types';

export interface WhatsappOrderLineInput {
    productVariantId: string;
    quantity: number;
}

export interface WhatsappDraftOrderInput {
    firstName: string;
    lastName?: string;
    phoneNumber: string;
    emailAddress?: string;
    notes?: string;
    lines: WhatsappOrderLineInput[];
    shippingAddress?: CreateAddressInput | null;
    billingAddress?: CreateAddressInput | null;
}

export interface WhatsappPaymentMetadata extends WhatsappDraftOrderInput {
    channelToken?: string;
}

export interface WhatsappDraftOrderResult {
    createdCustomer: boolean;
    generatedEmailAddress?: string;
}
