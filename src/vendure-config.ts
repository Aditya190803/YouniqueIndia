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
import { AssetServerPlugin } from '@vendure/asset-server-plugin';
import { AdminUiPlugin } from '@vendure/admin-ui-plugin';
import { GraphiqlPlugin } from '@vendure/graphiql-plugin';
import { BackInStockPlugin } from '@callit-today/vendure-plugin-back-in-stock';
import { GoogleAuthenticationStrategy } from './plugins/authentication/google-authentication-strategy';
import 'dotenv/config';
import path from 'path';
// Cloudinary storage strategy
import { configureCloudinaryAssetStorage } from './plugins/cloudinary/cloudinary-asset-storage-strategy';

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
                handler: (app: any) => {
                    app.set('trust proxy', true);
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
            new GoogleAuthenticationStrategy(),
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
        paymentMethodHandlers: [dummyPaymentHandler],
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
                folder: process.env.CLOUDINARY_FOLDER,
                secure: true,
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
                verifyEmailAddressUrl: process.env.VERIFY_EMAIL_URL || 'http://localhost:8080/verify',
                passwordResetUrl: process.env.PASSWORD_RESET_URL || 'http://localhost:8080/password-reset',
                changeEmailAddressUrl: process.env.CHANGE_EMAIL_URL || 'http://localhost:8080/verify-email-address-change'
            },
            transport: {
                type: 'smtp',
                host: process.env.SMTP_HOST,
                port: Number(process.env.SMTP_PORT),
                auth: {
                    user: process.env.SMTP_USER,
                    pass: process.env.SMTP_PASS,
                },
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
    ],
};

export { config as vendureConfig };
