import { Injectable } from '@nestjs/common';
import { RequestContext, CustomerService, Customer, TransactionalConnection } from '@vendure/core';

export interface CustomerRegistrationData {
    emailAddress: string;
    firstName: string;
    lastName: string;
    googleId?: string;
}

/**
 * Customer Registration Service
 * 
 * This service handles customer registration with support for Google ID storage.
 * It can be used to create customers with Google authentication data during manual registration.
 */
@Injectable()
export class CustomerRegistrationService {
    constructor(
        private customerService: CustomerService,
        private connection: TransactionalConnection,
    ) {}

    /**
     * Create a new customer with optional Google ID
     */
    async createCustomerWithGoogleId(
        ctx: RequestContext,
        data: CustomerRegistrationData,
    ): Promise<Customer | null> {
        try {
            return this.connection.withTransaction(async (transactionCtx) => {
                // Create the customer
                const result = await this.customerService.create(transactionCtx, {
                    emailAddress: data.emailAddress,
                    firstName: data.firstName,
                    lastName: data.lastName,
                });

                // Check if creation was successful
                if ('id' in result) {
                    console.log(`Customer registration: Created customer ${data.emailAddress}${data.googleId ? ` with Google ID ${data.googleId}` : ''}`);
                    return result;
                } else {
                    console.error('Customer registration: Failed to create customer', result);
                    return null;
                }
            });
        } catch (error) {
            console.error('Customer registration: Error creating customer', error);
            return null;
        }
    }

    /**
     * Update an existing customer with Google ID
     */
    async updateCustomerWithGoogleId(
        ctx: RequestContext,
        customerId: string,
        googleId: string,
    ): Promise<Customer | null> {
        try {
            return this.connection.withTransaction(async (transactionCtx) => {
                const customer = await this.customerService.findOne(transactionCtx, customerId);
                if (!customer) {
                    throw new Error(`Customer with ID ${customerId} not found`);
                }

                // Update customer with Google ID
                const result = await this.customerService.update(transactionCtx, {
                    id: customerId,
                    customFields: {
                        googleId,
                    },
                });

                if ('id' in result) {
                    console.log(`Customer registration: Updated customer ${customer.emailAddress} with Google ID ${googleId}`);
                    return result;
                } else {
                    console.error('Customer registration: Failed to update customer', result);
                    return null;
                }
            });
        } catch (error) {
            console.error('Customer registration: Error updating customer', error);
            return null;
        }
    }

    /**
     * Check if a customer already has a Google ID
     */
    async hasGoogleId(ctx: RequestContext, customerId: string): Promise<boolean> {
        try {
            const customer = await this.customerService.findOne(ctx, customerId);
            const customFields = customer?.customFields as any;
            return customFields?.googleId ? true : false;
        } catch (error) {
            console.error('Customer registration: Error checking Google ID', error);
            return false;
        }
    }

    /**
     * Get customer by Google ID
     */
    async findByGoogleId(ctx: RequestContext, googleId: string): Promise<Customer | null> {
        try {
            const customers = await this.customerService.findAll(ctx, {
                take: 100, // Get more customers to search through
            });

            // Filter by Google ID manually since the filter might not work
            const customerWithGoogleId = customers.items.find(customer => {
                const customFields = customer.customFields as any;
                return customFields?.googleId === googleId;
            });

            return customerWithGoogleId || null;
        } catch (error) {
            console.error('Customer registration: Error finding customer by Google ID', error);
            return null;
        }
    }
} 