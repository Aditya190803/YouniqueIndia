import {
    DefaultJobQueuePlugin,
    DefaultSchedulerPlugin,
    DefaultSearchPlugin,
    VendureConfig,
    NativeAuthenticationStrategy,
    LanguageCode,
    DefaultAssetNamingStrategy,
    manualFulfillmentHandler,
} from '@vendure/core';
import { defaultEmailHandlers, EmailPlugin, FileBasedTemplateLoader } from '@vendure/email-plugin';
import { StellatePlugin, defaultPurgeRules } from '@vendure/stellate-plugin';
import { ResendEmailSender } from './config/resend-email-sender';
import { AssetServerPlugin } from '@vendure/asset-server-plugin';
import { AdminUiPlugin } from '@vendure/admin-ui-plugin';
import { GraphiqlPlugin } from '@vendure/graphiql-plugin';
// ...existing code...
import 'dotenv/config';
// If DB_SSL is enabled for development with a self-signed certificate,
// disable Node's strict certificate chain checks so the Postgres client
// can connect. This is only intended for local/dev environments.
if (process.env.DB_SSL === 'true') {
    // NOTE: Disables TLS certificate validation globally for this process.
    // Do NOT enable this in production systems.
    process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
}
import path from 'path';
// Cloudinary storage strategy
import { configureCloudinaryAssetStorage } from './plugins/cloudinary/cloudinary-asset-storage-strategy';
import { RazorpayPaymentHandler } from './plugins/razorpay/razorpay-payment.handler';
import { RazorpayPlugin } from './plugins/razorpay/razorpay.plugin';
import { indiaShippingEligibilityChecker } from './plugins/shipping/india-shipping-eligibility';
import { alwaysFreeShippingEligibilityChecker } from './plugins/shipping/always-free-shipping-checker';

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
                'http://localhost:8081',
                'http://localhost:3000',
                'http://localhost:3001',
                'https://younique-storefront.vercel.app',
                'https://youniqueindia.onrender.com',
                'https://youniqueindia.onrender.com:443',
                'https://youniqueindia.co.in',
                'http://youniqueindia.co.in',
                'https://www.youniqueindia.co.in',
                'http://www.youniqueindia.co.in',
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
        middleware: [
            {
                // Ensure Express trusts the proxy (needed on platforms like Render/Heroku)
                handler: (req: any, res: any, next: any) => {
                    const trustProxy = process.env.TRUST_PROXY_SETTING;
                    if (trustProxy) {
                        req.app?.set?.('trust proxy', trustProxy);
                    }
                    next();
                },
                route: '/',
            },
        ],
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
        extra: {
            // Maximum number of clients in the pool. Keep this below your Postgres
            // server's max_connections minus the reserved superuser slots (usually 3).
            max: +(process.env.DB_POOL_MAX || 5),
            // How long to wait when connecting a new client (ms)
            connectionTimeoutMillis: +(process.env.DB_CONNECTION_TIMEOUT_MS || 60000),
            // How long a client is allowed to remain idle before being closed (ms)
            idleTimeoutMillis: +(process.env.DB_IDLE_TIMEOUT_MS || 30000),
        },
        // Prefer DATABASE_URL if set, otherwise fall back to individual params
        ...(process.env.DATABASE_URL
            ? { 
                url: process.env.DATABASE_URL,
                ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
            }
            : {
                database: process.env.DB_NAME,
                schema: process.env.DB_SCHEMA || 'public',
                host: process.env.DB_HOST,
                port: +process.env.DB_PORT || 5432,
                username: process.env.DB_USERNAME,
                password: process.env.DB_PASSWORD,
                ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
            }
        ),
    },
    paymentOptions: {
        paymentMethodHandlers: [RazorpayPaymentHandler],
    },
    shippingOptions: {
        shippingEligibilityCheckers: [alwaysFreeShippingEligibilityChecker, indiaShippingEligibilityChecker],
        fulfillmentHandlers: [manualFulfillmentHandler],
    },

    // Custom fields for Firebase authentication
    customFields: {
        Customer: [
            // Removed firebaseId field
        ],
        Facet: [
            {
                name: 'showOnProductDetail',
                type: 'boolean',
                label: [{ languageCode: LanguageCode.en, value: 'Show on product detail?' }],
                defaultValue: false,
            },
        ],
    },
    plugins: [
        RazorpayPlugin,
        GraphiqlPlugin.init(),
        AssetServerPlugin.init({
            route: 'assets',
            // Use a proper temporary directory for asset uploads (S3 handles actual storage)
            assetUploadDir: '/tmp/assets',
            namingStrategy: new DefaultAssetNamingStrategy(),
            storageStrategyFactory: configureCloudinaryAssetStorage({
                cloudName: process.env.CLOUDINARY_CLOUD_NAME!,
                apiKey: process.env.CLOUDINARY_API_KEY!,
                apiSecret: process.env.CLOUDINARY_API_SECRET!,
                folder: process.env.CLOUDINARY_FOLDER || 'vendure',
                secure: true,
            }),
        }),
        DefaultSchedulerPlugin.init(),
        DefaultJobQueuePlugin.init({ useDatabaseForBuffer: true }),
        DefaultSearchPlugin.init({ bufferUpdates: false, indexStockStatus: true }),
        // Optional GraphQL edge cache integration via Stellate
        ...(process.env.STELLATE_SERVICE_NAME && process.env.STELLATE_PURGE_API_TOKEN
            ? [
                // Cast to any to allow passing a passthrough `saveOnce` option
                // which may not exist in older versions of the plugin types.
                StellatePlugin.init({
                    serviceName: process.env.STELLATE_SERVICE_NAME!,
                    apiToken: process.env.STELLATE_PURGE_API_TOKEN!,
                    devMode: process.env.APP_ENV !== 'prod' || process.env.STELLATE_DEBUG_MODE === 'true',
                    debugLogging: process.env.STELLATE_DEBUG_MODE === 'true',
                    // Optional passthrough flag: if supported by the installed
                    // @vendure/stellate-plugin version, this will enable a
                    // "save once" behavior so the cache only needs to be
                    // persisted a single time. If the plugin doesn't support
                    // this option, it's ignored harmlessly.
                    saveOnce: process.env.STELLATE_SAVE_ONCE === 'true',
                    purgeRules: [
                        ...defaultPurgeRules,
                        // Add custom PurgeRules here if you cache custom types in Stellate config
                    ],
                } as any),
            ]
            : []),
        EmailPlugin.init({
            ...(IS_DEV ? { devMode: true as const, route: 'mailbox' } : {}),
            outputPath: path.join(__dirname, '../static/email/test-emails'),
            handlers: defaultEmailHandlers,
            templateLoader: new FileBasedTemplateLoader(path.join(__dirname, '../static/email/templates')),
            globalTemplateVars: {
                // The following variables will change depending on your storefront implementation.
                fromAddress: '"YouniqueIndia" <noreply@youniqueindia.com>',
                verifyEmailAddressUrl: process.env.VERIFY_EMAIL_URL || 'http://localhost:8080/verify',
                passwordResetUrl: process.env.PASSWORD_RESET_URL || 'http://localhost:8080/password-reset',
                changeEmailAddressUrl: process.env.CHANGE_EMAIL_URL || 'http://localhost:8080/verify-email-address-change'
            },
            // Use custom EmailSender with Resend API (no SMTP)
            transport: { type: 'none' },
            emailSender: new ResendEmailSender(process.env.RESEND_API_KEY || ''),
        }),
    AdminUiPlugin.init({
            route: 'admin',
            port: serverPort,
            adminUiConfig: {
                apiHost: IS_PRODUCTION ? 'https://youniqueindia.onrender.com' : 'http://localhost',
                apiPort: IS_PRODUCTION ? 443 : serverPort,
                adminApiPath: 'admin-api',
                tokenMethod: 'bearer',
            },
        }),
    ],
};

export { config as vendureConfig };
