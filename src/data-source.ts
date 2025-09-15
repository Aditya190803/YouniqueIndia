import 'dotenv/config';
import { DataSource } from 'typeorm';
import path from 'path';

const isDev = process.env.APP_ENV === 'dev';

// Use only TS sources during development (ts-node scripts) to avoid loading stale compiled JS
// which can reference removed dependencies (e.g., deleted auth strategies). In production (NODE_ENV=production),
// rely on compiled JS in dist.
const isProd = process.env.NODE_ENV === 'production';
// Narrow entity glob to only model/entity files to prevent recursive scanning loops
const entityGlobs = isProd ? ['dist/**/!(*.spec).js'] : ['src/**/*.{entity,model}.ts'];
const migrationGlobs = isProd ? ['dist/migrations/*.{js}'] : ['src/migrations/*.{ts,js}'];

const AppDataSource = new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST,
    port: +(process.env.DB_PORT || 5432),
    username: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    schema: process.env.DB_SCHEMA || 'public',
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
    synchronize: false,
    logging: false,
    entities: entityGlobs,
    migrations: migrationGlobs,
});

export default AppDataSource; 

// Ensure TLS rejection is disabled when DB_SSL is true to allow self-signed certs
// for local development. This mirrors the behavior in vendure-config.ts.
if (process.env.DB_SSL === 'true') {
    process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
}