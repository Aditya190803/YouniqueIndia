import { BadRequestException, Injectable, InternalServerErrorException, OnModuleInit } from '@nestjs/common';
import {
    Customer,
    CustomerService,
    isGraphQlErrorResult,
    Logger,
    Order,
    OrderService,
    RequestContext,
    TransactionalConnection,
} from '@vendure/core';
import { UpdateCustomerInput } from '@vendure/common/lib/generated-types';
import { registerWhatsappPaymentService } from './whatsapp-payment.handler';
import {
    WhatsappDraftOrderInput,
    WhatsappPaymentMetadata,
    WhatsappDraftOrderResult,
} from './whatsapp-payment.types';

@Injectable()
export class WhatsappPaymentService implements OnModuleInit {
    private readonly loggerContext = WhatsappPaymentService.name;

    constructor(
        private readonly connection: TransactionalConnection,
        private readonly customerService: CustomerService,
        private readonly orderService: OrderService,
    ) {}

    onModuleInit(): void {
        registerWhatsappPaymentService(this);
    }

    async createDraftOrder(
        ctx: RequestContext,
        input: WhatsappDraftOrderInput,
    ): Promise<{ order: Order; customer: Customer } & WhatsappDraftOrderResult> {
        this.validateInput(input);

        return this.connection.withTransaction(ctx, async transactionCtx => {
            const order = await this.orderService.createDraft(transactionCtx);
            return this.prepareWhatsappOrder(transactionCtx, order, input);
        });
    }

    async prepareWhatsappOrder(
        ctx: RequestContext,
        order: Order,
        metadata: WhatsappPaymentMetadata,
    ): Promise<{ order: Order; customer: Customer } & WhatsappDraftOrderResult> {
        this.validateInput(metadata);
        const { customer, createdCustomer, generatedEmailAddress } = await this.ensureCustomer(ctx, metadata);

        let preparedOrder = order;

        if (!preparedOrder.customer || preparedOrder.customer.id !== customer.id) {
            preparedOrder = await this.orderService.updateOrderCustomer(ctx, {
                orderId: preparedOrder.id,
                customerId: customer.id,
                note: metadata.notes ?? undefined,
            });
        }

        if (metadata.lines && metadata.lines.length > 0) {
            const addResult = await this.orderService.addItemsToOrder(
                ctx,
                preparedOrder.id,
                metadata.lines.map(line => ({
                    productVariantId: line.productVariantId,
                    quantity: line.quantity,
                })),
            );

            if ('errorResults' in addResult && addResult.errorResults.length > 0) {
                const firstError = addResult.errorResults[0];
                throw new BadRequestException(firstError.message);
            }

            preparedOrder = addResult.order;
        } else {
            const reloaded = await this.orderService.findOne(ctx, preparedOrder.id);
            preparedOrder = reloaded ?? preparedOrder;
        }

        if (metadata.shippingAddress) {
            preparedOrder = await this.orderService.setShippingAddress(
                ctx,
                preparedOrder.id,
                metadata.shippingAddress,
            );
        }

        if (metadata.billingAddress) {
            preparedOrder = await this.orderService.setBillingAddress(
                ctx,
                preparedOrder.id,
                metadata.billingAddress,
            );
        }

        const hydratedOrder = await this.orderService.findOne(ctx, preparedOrder.id, [
            'lines',
            'lines.productVariant',
            'customer',
            'shippingLines',
            'surcharges',
            'payments',
        ]);

        if (!hydratedOrder) {
            Logger.error(`Unable to hydrate draft order ${preparedOrder.id}`, this.loggerContext);
            throw new InternalServerErrorException('Failed to prepare WhatsApp draft order');
        }

        return {
            order: hydratedOrder,
            customer,
            createdCustomer,
            generatedEmailAddress,
        };
    }

    async prepareWhatsappOrderTransactional(
        ctx: RequestContext,
        order: Order,
        metadata: WhatsappPaymentMetadata,
    ): Promise<{ order: Order; customer: Customer } & WhatsappDraftOrderResult> {
        return this.connection.withTransaction(ctx, transactionCtx =>
            this.prepareWhatsappOrder(transactionCtx, order, metadata),
        );
    }

    private validateInput(input: WhatsappDraftOrderInput): void {
        if (!input.firstName || input.firstName.trim().length === 0) {
            throw new BadRequestException('firstName is required for WhatsApp orders');
        }
        if (!input.phoneNumber || input.phoneNumber.trim().length === 0) {
            throw new BadRequestException('phoneNumber is required for WhatsApp orders');
        }
    }

    private async ensureCustomer(
        ctx: RequestContext,
        metadata: WhatsappPaymentMetadata,
    ): Promise<{ customer: Customer; createdCustomer: boolean; generatedEmailAddress?: string }> {
        const normalizedEmail = this.buildEmailAddress(metadata.emailAddress, metadata.phoneNumber);
        const repository = this.connection.getRepository(ctx, Customer);

        let customer = await repository.findOne({ where: { emailAddress: normalizedEmail } });
        let createdCustomer = false;

        if (!customer) {
            const password = this.generateRandomPassword();
            const createResult = await this.customerService.create(ctx, {
                emailAddress: normalizedEmail,
                firstName: metadata.firstName,
                lastName: metadata.lastName ?? '',
                phoneNumber: metadata.phoneNumber,
            }, password);

            if (isGraphQlErrorResult(createResult)) {
                throw new BadRequestException(createResult.message);
            }

            customer = createResult;
            createdCustomer = true;
        } else {
            const updateInput: UpdateCustomerInput = { id: customer.id };
            let shouldUpdate = false;

            if (metadata.firstName && metadata.firstName !== customer.firstName) {
                updateInput.firstName = metadata.firstName;
                shouldUpdate = true;
            }
            if (metadata.lastName && metadata.lastName !== customer.lastName) {
                updateInput.lastName = metadata.lastName;
                shouldUpdate = true;
            }
            if (metadata.phoneNumber && metadata.phoneNumber !== customer.phoneNumber) {
                updateInput.phoneNumber = metadata.phoneNumber;
                shouldUpdate = true;
            }

            if (shouldUpdate) {
                const updateResult = await this.customerService.update(ctx, updateInput);
                if (isGraphQlErrorResult(updateResult)) {
                    throw new BadRequestException((updateResult as any).message);
                }
                customer = updateResult;
            }
        }

        return {
            customer,
            createdCustomer,
            generatedEmailAddress: metadata.emailAddress ? undefined : normalizedEmail,
        };
    }

    private buildEmailAddress(explicitEmail: string | undefined | null, phoneNumber: string): string {
        if (explicitEmail && explicitEmail.trim().length > 0) {
            return explicitEmail.trim().toLowerCase();
        }

        const sanitizedPhone = phoneNumber.replace(/[^0-9]/g, '');
        return `whatsapp+${sanitizedPhone || Date.now()}@youniqueindia.local`;
    }

    private generateRandomPassword(): string {
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let password = '';
        for (let i = 0; i < 16; i++) {
            const index = Math.floor(Math.random() * characters.length);
            password += characters.charAt(index);
        }
        return password;
    }
}
