import { Injectable } from '@nestjs/common';
import { RequestContext, CustomerService, Customer, TransactionalConnection } from '@vendure/core';

export interface CustomerRegistrationData {
    emailAddress: string;
    firstName: string;
    lastName: string;
}

/**
 * Customer Registration Service
 * 
 * This service handles customer registration.
 */
@Injectable()
export class CustomerRegistrationService {
    constructor(
        private customerService: CustomerService,
        private connection: TransactionalConnection,
    ) {}

    /**
     * Create a new customer
     */
    async createCustomer(
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
                    console.log(`Customer registration: Created customer ${data.emailAddress}`);
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

    // ...existing code...

    // ...existing code...

    // ...existing code...
} 