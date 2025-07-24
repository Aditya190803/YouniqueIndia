import 'dotenv/config';
import { DataSource } from 'typeorm';
import path from 'path';

const isDev = process.env.APP_ENV === 'dev';

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
    logging: isDev,
    entities: ['src/**/*.ts', 'dist/**/*.js'],
    migrations: ['src/migrations/*.{ts,js}', 'dist/migrations/*.{ts,js}'],
});

export default AppDataSource; 