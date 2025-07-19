import { PluginCommonModule, VendurePlugin } from '@vendure/core';
import { FirebaseAuthenticationStrategy } from './firebase-authentication-strategy';

@VendurePlugin({
    imports: [PluginCommonModule],
    configuration: config => {
        // Add Firebase authentication strategy to shop authentication
        if (!config.authOptions?.shopAuthenticationStrategy) {
            config.authOptions = config.authOptions || {};
            config.authOptions.shopAuthenticationStrategy = [];
        }
        config.authOptions.shopAuthenticationStrategy.push(new FirebaseAuthenticationStrategy());
        
        return config;
    },
})
export class FirebaseAuthenticationPlugin {} 