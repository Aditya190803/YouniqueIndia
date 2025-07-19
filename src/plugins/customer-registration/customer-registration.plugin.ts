import { PluginCommonModule, VendurePlugin } from '@vendure/core';
import { CustomerRegistrationService } from './customer-registration.service';

/**
 * Custom Customer Registration Plugin
 * 
 * This plugin extends the customer registration process to handle Google ID storage
 * when users manually register. It provides a service that can be used to update
 * customer custom fields with Google authentication data.
 */
@VendurePlugin({
    imports: [PluginCommonModule],
    providers: [CustomerRegistrationService],
})
export class CustomerRegistrationPlugin {} 