import {
    dummyPaymentHandler,
    DefaultJobQueuePlugin,
    DefaultSchedulerPlugin,
    DefaultSearchPlugin,
    VendureConfig,
    NativeAuthenticationStrategy,
    LanguageCode,
    DefaultAssetNamingStrategy,
} from '@vendure/core';
import { defaultEmailHandlers, EmailPlugin, FileBasedTemplateLoader } from '@vendure/email-plugin';
import { AssetServerPlugin, configureS3AssetStorage } from '@vendure/asset-server-plugin';
import { AdminUiPlugin } from '@vendure/admin-ui-plugin';
import { GraphiqlPlugin } from '@vendure/graphiql-plugin';
import { BackInStockPlugin } from '@callit-today/vendure-plugin-back-in-stock';
import { FirebaseAuthenticationStrategy } from './plugins/authentication/firebase-authentication-strategy';
import { CustomerRegistrationPlugin } from './plugins/customer-registration/customer-registration.plugin';
import { WhatsAppPaymentPlugin } from './plugins/whatsapp-payment/whatsapp-payment.plugin';
import 'dotenv/config';
import path from 'path';
import { fromEnv } from '@aws-sdk/credential-providers';

const IS_DEV = process.env.APP_ENV === 'dev';
const IS_PRODUCTION = process.env.NODE_ENV === 'production';
const serverPort = +process.env.PORT || 3000;

export const config: VendureConfig = {
    apiOptions: {
        port: serverPort,
        adminApiPath: 'admin-api',
        shopApiPath: 'shop-api',
        // CORS configuration for storefront communication
        cors: {
            origin: [
                'http://localhost:8080',
                'http://localhost:3000',
                'https://younique-storefront.vercel.app',
                'https://youniqueindia.onrender.com',
                'https://youniqueindia.onrender.com:443',
            ],
            credentials: true,
        },
        // The following options are useful in development mode,
        // but are best turned off for production for security
        // reasons.
        ...(IS_DEV ? {
            adminApiDebug: true,
            shopApiDebug: true,
        } : {}),
    },
    // Language configuration - essential for proper Product.languageCode handling
    defaultLanguageCode: LanguageCode.en,
    authOptions: {
        tokenMethod: ['bearer', 'cookie'],
        superadminCredentials: {
            identifier: process.env.SUPERADMIN_USERNAME,
            password: process.env.SUPERADMIN_PASSWORD,
        },
        cookieOptions: {
          secret: process.env.COOKIE_SECRET,
        },
        // Admin API authentication strategies (for administrators)
        adminAuthenticationStrategy: [
            new NativeAuthenticationStrategy(),
        ],
        // Shop API authentication strategies (for customers)
        shopAuthenticationStrategy: [
            new NativeAuthenticationStrategy(),
            new FirebaseAuthenticationStrategy(),
        ],
        // Require verification for new customer accounts
        requireVerification: false,
        // Session duration (in seconds) - 30 days
        sessionDuration: 60 * 60 * 24 * 30,
    },
    dbConnectionOptions: {
        type: 'postgres',
        // See the README.md "Migrations" section for an explanation of
        // the `synchronize` and `migrations` options.
        synchronize: IS_DEV,
        migrations: [path.join(__dirname, './migrations/*.+(js|ts)')],
        logging: IS_DEV,
        // Connection pool settings for better reliability
        extra: {
            connectionLimit: 10,
            acquireTimeout: 60000,
            timeout: 60000,
        },
        // Use DATABASE_URL if available, otherwise use individual connection params
        url: process.env.DATABASE_URL,
        database: process.env.DB_NAME,
        schema: process.env.DB_SCHEMA || 'public',
        host: process.env.DB_HOST,
        port: +process.env.DB_PORT || 5432,
        username: process.env.DB_USERNAME,
        password: process.env.DB_PASSWORD,
        ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
    },
    paymentOptions: {
        paymentMethodHandlers: [dummyPaymentHandler],
    },

    // Custom fields for Firebase authentication
    customFields: {
        Customer: [
            {
                name: 'firebaseId',
                type: 'string',
                nullable: true,
                public: true,
                label: [
                    {
                        languageCode: LanguageCode.en,
                        value: 'Firebase ID',
                    },
                ],
            },
        ],
    },
    plugins: [
        GraphiqlPlugin.init(),
        AssetServerPlugin.init({
            route: 'assets',
            // Use a proper temporary directory for asset uploads (S3 handles actual storage)
            assetUploadDir: '/tmp/assets',
            namingStrategy: new DefaultAssetNamingStrategy(),
            storageStrategyFactory: configureS3AssetStorage({
                bucket: process.env.AWS_S3_BUCKET!,
                credentials: fromEnv(),
                nativeS3Configuration: {
                    region: process.env.AWS_REGION,
                },
            }),
        }),
        DefaultSchedulerPlugin.init(),
        DefaultJobQueuePlugin.init({ useDatabaseForBuffer: true }),
        DefaultSearchPlugin.init({ bufferUpdates: false, indexStockStatus: true }),
        EmailPlugin.init({
            devMode: true,
            outputPath: path.join(__dirname, '../static/email/test-emails'),
            route: 'mailbox',
            handlers: defaultEmailHandlers,
            templateLoader: new FileBasedTemplateLoader(path.join(__dirname, '../static/email/templates')),
            globalTemplateVars: {
                // The following variables will change depending on your storefront implementation.
                fromAddress: '"YouniqueIndia" <noreply@youniqueindia.com>',
                verifyEmailAddressUrl: IS_PRODUCTION ? 'https://younique-storefront.vercel.app/verify' : 'http://localhost:8080/verify',
                passwordResetUrl: IS_PRODUCTION ? 'https://younique-storefront.vercel.app/password-reset' : 'http://localhost:8080/password-reset',
                changeEmailAddressUrl: IS_PRODUCTION ? 'https://younique-storefront.vercel.app/verify-email-address-change' : 'http://localhost:8080/verify-email-address-change'
            },
        }),
        AdminUiPlugin.init({
            route: 'admin',
            port: serverPort,
            adminUiConfig: {
                apiHost: IS_PRODUCTION ? 'https://youniqueindia.onrender.com' : 'http://localhost',
                apiPort: IS_PRODUCTION ? 443 : serverPort,
                adminApiPath: 'admin-api',
                tokenMethod: 'bearer',
                // Remove loginUrl to use default native authentication
                // loginUrl: '/social-auth/login',
            },
        }),

        BackInStockPlugin.init({
            enableEmail: true,
            limitEmailToStock: true,
        }),
        // Firebase Authentication Strategy (custom implementation)
        // WhatsApp Payment Plugin
        WhatsAppPaymentPlugin,
        // Customer Registration Plugin
        CustomerRegistrationPlugin,
        // Note: INR currency is set via migration, no plugin needed
    ],
};
