export {};

// Here we declare the members of the process.env object, so that we
// can use them in our application code in a type-safe manner.
declare global {
    namespace NodeJS {
        interface ProcessEnv {
            APP_ENV: string;
            NODE_ENV: string;
            PORT?: string;
            COOKIE_SECRET: string;
            TRUST_PROXY_SETTING?: string;
            EMAIL_DEV_MAILBOX?: string;
            SUPERADMIN_USERNAME: string;
            SUPERADMIN_PASSWORD: string;
            DATABASE_URL?: string;
            DB_HOST?: string;
            DB_PORT?: string;
            DB_NAME?: string;
            DB_USERNAME?: string;
            DB_PASSWORD?: string;
            DB_SCHEMA?: string;
            DB_SSL?: string;
            DB_POOL_MAX?: string;
            DB_CONNECTION_TIMEOUT_MS?: string;
            DB_IDLE_TIMEOUT_MS?: string;
            CLOUDINARY_CLOUD_NAME: string;
            CLOUDINARY_API_KEY: string;
            CLOUDINARY_API_SECRET: string;
            CLOUDINARY_FOLDER?: string;
            FROM_EMAIL?: string;
            VERIFY_EMAIL_URL?: string;
            PASSWORD_RESET_URL?: string;
            CHANGE_EMAIL_URL?: string;
            SHOP_API_URL?: string;
            SHOP_API_PAGE_SIZE?: string;
            TEST_EMAIL?: string;
            NODE_TLS_REJECT_UNAUTHORIZED?: string;
        }
    }
}
