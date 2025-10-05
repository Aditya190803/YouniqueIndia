export {};

// Here we declare the members of the process.env object, so that we
// can use them in our application code in a type-safe manner.
declare global {
    namespace NodeJS {
        interface ProcessEnv {
            APP_ENV: string;
            PORT: string;
            COOKIE_SECRET: string;
            TRUST_PROXY_SETTING?: string;
            SUPERADMIN_USERNAME: string;
            SUPERADMIN_PASSWORD: string;
            DB_HOST: string;
            DB_PORT: number;
            DB_NAME: string;
            DB_USERNAME: string;
            DB_PASSWORD: string;
            DB_SCHEMA: string;
            DB_SSL: string;
            ASSET_URL_PREFIX?: string;
            AWS_ACCESS_KEY_ID?: string;
            AWS_SECRET_ACCESS_KEY?: string;
            AWS_REGION?: string;
            AWS_S3_BUCKET?: string;
            CLOUDINARY_CLOUD_NAME?: string;
            CLOUDINARY_API_KEY?: string;
            CLOUDINARY_API_SECRET?: string;
            CLOUDINARY_FOLDER?: string;
            SMTP_HOST?: string;
            SMTP_PORT?: string;
            SMTP_USER?: string;
            SMTP_PASS?: string;
            VERIFY_EMAIL_URL?: string;
            PASSWORD_RESET_URL?: string;
            CHANGE_EMAIL_URL?: string;
        }
    }
}
