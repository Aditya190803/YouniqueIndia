import 'dotenv/config';
import AppDataSource from '../data-source';

async function wipeDb() {
  console.log('⚠️  WIPING DATABASE SCHEMA – ALL DATA WILL BE LOST');
  const schema = process.env.DB_SCHEMA || 'public';
  const ds = AppDataSource;
  await ds.initialize();
  const qr = ds.createQueryRunner();
  try {
    await qr.query(`DROP SCHEMA IF EXISTS "${schema}" CASCADE;`);
    await qr.query(`CREATE SCHEMA "${schema}";`);
    console.log('✅ Schema recreated');
  } catch (e: any) {
    console.error('❌ Failed wiping schema:', e.message || e);
    process.exitCode = 1;
  } finally {
    await qr.release();
    await ds.destroy();
  }
}

if (require.main === module) {
  wipeDb();
}
