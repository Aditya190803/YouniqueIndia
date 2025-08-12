import { PluginCommonModule, VendurePlugin } from '@vendure/core';
import { CustomerRegistrationService } from './customer-registration.service';

import { Module } from '@nestjs/common';

@Module({
	imports: [PluginCommonModule],
	providers: [CustomerRegistrationService],
})
export class CustomerRegistrationPlugin {}