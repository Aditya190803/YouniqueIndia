import 'dotenv/config';
import { createConnection } from 'typeorm';
import * as fs from 'fs';
import * as path from 'path';

interface ImportOptions {
    exportDir?: string;
    skipTables?: string[];
    onlyTables?: string[];
    clearDatabase?: boolean;
    continueOnError?: boolean;
}

class DataImporter {
    private connection: any;
    private options: ImportOptions;

    constructor(options: ImportOptions = {}) {
        this.options = {
            clearDatabase: false,
            continueOnError: true,
            ...options
        };
    }

    async connect() {
        console.log('🔌 Connecting to Render PostgreSQL database...');
        
        this.connection = await createConnection({
            type: 'postgres',
            host: process.env.DB_HOST,
            port: +(process.env.DB_PORT || 5432),
            username: process.env.DB_USERNAME,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME,
            schema: process.env.DB_SCHEMA || 'public',
            ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
        });

        console.log('✅ Connected to Render database successfully!');
    }

    async disconnect() {
        if (this.connection) {
            await this.connection.close();
            console.log('🔌 Disconnected from database');
        }
    }

    async findLatestExport(): Promise<string> {
        const exportsDir = path.join(process.cwd(), 'exports');
        
        if (!fs.existsSync(exportsDir)) {
            throw new Error('❌ No exports directory found. Please run an export first.');
        }

        const exportDirs = fs.readdirSync(exportsDir)
            .filter(dir => dir.startsWith('neon-export-'))
            .sort()
            .reverse();

        if (exportDirs.length === 0) {
            throw new Error('❌ No export directories found.');
        }

        const latestExport = path.join(exportsDir, exportDirs[0]);
        console.log(`📁 Using latest export: ${latestExport}`);
        
        return latestExport;
    }

    async loadExportData(exportDir: string): Promise<any> {
        const jsonFile = path.join(exportDir, 'database-export.json');
        const infoFile = path.join(exportDir, 'export-info.json');

        if (!fs.existsSync(jsonFile)) {
            throw new Error(`❌ Export JSON file not found: ${jsonFile}`);
        }

        console.log('📖 Loading export data...');
        const exportData = JSON.parse(fs.readFileSync(jsonFile, 'utf8'));
        
        let exportInfo = null;
        if (fs.existsSync(infoFile)) {
            exportInfo = JSON.parse(fs.readFileSync(infoFile, 'utf8'));
            console.log(`📊 Export contains ${exportInfo.totalTables} tables`);
            console.log(`📅 Exported on: ${exportInfo.exportDate}`);
        }

        return { exportData, exportInfo };
    }

    async clearDatabase() {
        console.log('🧹 Clearing existing database...');
        
        try {
            // Get all tables
            const tables = await this.connection.query(`
                SELECT tablename 
                FROM pg_tables 
                WHERE schemaname = $1
            `, [process.env.DB_SCHEMA || 'public']);

            console.log(`   📋 Found ${tables.length} existing tables to drop`);

            // Drop tables one by one (can't disable FK checks on managed services)
            // Start with tables that are likely to have fewer dependencies
            const tableNames = tables.map((t: any) => t.tablename);
            
            // Try to drop tables in reverse dependency order
            for (const table of tableNames) {
                const tableName = table;
                try {
                    console.log(`   🗑️  Dropping table: ${tableName}`);
                    await this.connection.query(`DROP TABLE IF EXISTS "${tableName}" CASCADE`);
                } catch (error) {
                    console.log(`   ⚠️  Could not drop table ${tableName}: ${error instanceof Error ? error.message : String(error)}`);
                }
            }

            console.log('✅ Database cleared successfully');
        } catch (error) {
            console.error('❌ Error clearing database:', error instanceof Error ? error.message : String(error));
            throw error;
        }
    }

    async getTableCreationOrder(exportData: any): Promise<string[]> {
        // Try to determine table creation order based on foreign key dependencies
        const tableNames = Object.keys(exportData);
        
        // For now, we'll use a simple approach - tables with fewer FK references first
        // This is a simplified dependency resolution
        const tablesWithFKs = new Set<string>();
        const referencedTables = new Set<string>();

        // Scan for common reference patterns
        for (const [tableName, rows] of Object.entries(exportData) as [string, any[]][]) {
            if (Array.isArray(rows) && rows.length > 0) {
                const firstRow = rows[0];
                Object.keys(firstRow).forEach(column => {
                    // Common FK patterns
                    if (column.endsWith('Id') || column.endsWith('_id') || column.includes('channel') || column.includes('user')) {
                        tablesWithFKs.add(tableName);
                    }
                });
            }
        }

        // Basic ordering: independent tables first, then dependent ones
        const independentTables = tableNames.filter(name => !tablesWithFKs.has(name));
        const dependentTables = tableNames.filter(name => tablesWithFKs.has(name));

        // Some common Vendure table order considerations
        const priorityOrder = [
            'channel', 'country', 'zone', 'tax_category', 'shipping_method',
            'payment_method', 'customer_group', 'role', 'administrator', 
            'user', 'customer', 'address', 'collection', 'facet', 'facet_value',
            'product', 'product_variant', 'asset', 'product_asset',
            'collection_asset', 'product_variant_asset', 'order', 'order_line'
        ];

        const orderedTables: string[] = [];
        
        // Add tables in priority order if they exist
        priorityOrder.forEach(priority => {
            const found = tableNames.find(name => name.toLowerCase().includes(priority));
            if (found && !orderedTables.includes(found)) {
                orderedTables.push(found);
            }
        });

        // Add remaining independent tables
        independentTables.forEach(table => {
            if (!orderedTables.includes(table)) {
                orderedTables.push(table);
            }
        });

        // Add remaining dependent tables
        dependentTables.forEach(table => {
            if (!orderedTables.includes(table)) {
                orderedTables.push(table);
            }
        });

        console.log(`📋 Table import order determined: ${orderedTables.length} tables`);
        return orderedTables;
    }

    async createTableFromData(tableName: string, rows: any[]): Promise<void> {
        if (!rows || rows.length === 0) {
            console.log(`   ⚠️  Table ${tableName} is empty, skipping schema creation`);
            return;
        }

        const firstRow = rows[0];
        const columns = Object.keys(firstRow);

        // Infer column types from data
        const columnDefinitions = columns.map(col => {
            const sampleValue = firstRow[col];
            let sqlType = 'TEXT'; // Default fallback

            if (sampleValue === null) {
                // Check other rows for type inference
                const nonNullValue = rows.find(row => row[col] !== null)?.[col];
                if (nonNullValue !== undefined) {
                    sqlType = this.inferSQLType(nonNullValue, col);
                }
            } else {
                sqlType = this.inferSQLType(sampleValue, col);
            }

            return `"${col}" ${sqlType}`;
        });

        const createTableSQL = `
            CREATE TABLE IF NOT EXISTS "${tableName}" (
                ${columnDefinitions.join(',\n                ')}
            );
        `;

        try {
            await this.connection.query(createTableSQL);
            console.log(`   ✅ Created table: ${tableName}`);
        } catch (error) {
            console.log(`   ⚠️  Could not create table ${tableName}, it might already exist: ${error instanceof Error ? error.message : String(error)}`);
        }
    }

    private inferSQLType(value: any, columnName: string): string {
        const colName = columnName.toLowerCase();

        // ID columns
        if (colName === 'id' || colName.endsWith('_id') || colName.endsWith('id')) {
            return 'INTEGER';
        }

        // Timestamps
        if (colName.includes('time') || colName.includes('date') || colName.endsWith('at') || colName.includes('created') || colName.includes('updated')) {
            return 'TIMESTAMP';
        }

        // Booleans
        if (typeof value === 'boolean') {
            return 'BOOLEAN';
        }

        // Numbers
        if (typeof value === 'number') {
            return Number.isInteger(value) ? 'INTEGER' : 'DECIMAL';
        }

        // Dates
        if (value instanceof Date || (typeof value === 'string' && !isNaN(Date.parse(value)) && value.includes('T'))) {
            return 'TIMESTAMP';
        }

        // JSON objects
        if (typeof value === 'object' && value !== null) {
            return 'JSONB';
        }

        // Long text fields
        if (typeof value === 'string' && value.length > 255) {
            return 'TEXT';
        }

        // Default string
        return 'VARCHAR(255)';
    }

    async importTableData(tableName: string, rows: any[]): Promise<void> {
        if (!rows || rows.length === 0) {
            console.log(`   📭 Table ${tableName} is empty, skipping`);
            return;
        }

        console.log(`   📦 Importing ${rows.length} rows to ${tableName}`);

        // Create table schema first
        await this.createTableFromData(tableName, rows);

        const columns = Object.keys(rows[0]);
        const columnNames = columns.map(col => `"${col}"`).join(', ');

        // Import in chunks to avoid memory issues
        const chunkSize = 100;
        let imported = 0;

        for (let i = 0; i < rows.length; i += chunkSize) {
            const chunk = rows.slice(i, i + chunkSize);
            
            try {
                // Clear existing data for this chunk's primary keys if any
                const placeholders = chunk.map((_, index) => 
                    `(${columns.map((_, colIndex) => `$${index * columns.length + colIndex + 1}`).join(', ')})`
                ).join(', ');

                const values: any[] = [];
                chunk.forEach(row => {
                    columns.forEach(col => {
                        let value = row[col];
                        
                        // Handle special data types
                        if (value !== null && typeof value === 'object') {
                            value = JSON.stringify(value);
                        }
                        
                        values.push(value);
                    });
                });

                const insertSQL = `
                    INSERT INTO "${tableName}" (${columnNames}) 
                    VALUES ${placeholders}
                    ON CONFLICT DO NOTHING
                `;

                await this.connection.query(insertSQL, values);
                imported += chunk.length;
                
                if (imported % 500 === 0) {
                    console.log(`   📊 Imported ${imported}/${rows.length} rows`);
                }
                
            } catch (error) {
                if (this.options.continueOnError) {
                    console.log(`   ⚠️  Error importing chunk for ${tableName}: ${error instanceof Error ? error.message : String(error)}`);
                } else {
                    throw error;
                }
            }
        }

        console.log(`   ✅ Completed ${tableName}: ${imported} rows imported`);
    }

    async importDatabase(exportDir?: string): Promise<void> {
        await this.connect();

        try {
            // Find export directory
            const useExportDir = exportDir || this.options.exportDir || await this.findLatestExport();
            
            // Load export data
            const { exportData, exportInfo } = await this.loadExportData(useExportDir);

            // Clear database if requested
            if (this.options.clearDatabase) {
                await this.clearDatabase();
            }

            // Filter tables based on options
            let tablesToImport = Object.keys(exportData);
            
            if (this.options.onlyTables && this.options.onlyTables.length > 0) {
                tablesToImport = tablesToImport.filter(table => 
                    this.options.onlyTables!.includes(table)
                );
            }
            
            if (this.options.skipTables && this.options.skipTables.length > 0) {
                tablesToImport = tablesToImport.filter(table => 
                    !this.options.skipTables!.includes(table)
                );
            }

            console.log(`🎯 Importing ${tablesToImport.length} tables`);

            // Get optimal table order
            const orderedTables = await this.getTableCreationOrder(exportData);
            const filteredOrderedTables = orderedTables.filter(table => tablesToImport.includes(table));

            // Import each table (managed services don't allow disabling FK checks)
            let successCount = 0;
            let errorCount = 0;

            for (const tableName of filteredOrderedTables) {
                try {
                    console.log(`\n📋 Processing table: ${tableName}`);
                    await this.importTableData(tableName, exportData[tableName]);
                    successCount++;
                } catch (error) {
                    errorCount++;
                    console.error(`❌ Failed to import table ${tableName}:`, error instanceof Error ? error.message : String(error));
                    
                    if (!this.options.continueOnError) {
                        throw error;
                    }
                }
            }

            console.log('\n🎉 Import completed!');
            console.log(`✅ Successfully imported: ${successCount} tables`);
            if (errorCount > 0) {
                console.log(`⚠️  Failed to import: ${errorCount} tables`);
            }

        } finally {
            await this.disconnect();
        }
    }
}

// CLI usage
async function main() {
    const args = process.argv.slice(2);
    const options: ImportOptions = {};

    // Parse command line arguments
    for (let i = 0; i < args.length; i++) {
        switch (args[i]) {
            case '--export-dir':
                options.exportDir = args[++i];
                break;
            case '--clear-database':
                options.clearDatabase = true;
                break;
            case '--skip-tables':
                options.skipTables = args[++i].split(',');
                break;
            case '--only-tables':
                options.onlyTables = args[++i].split(',');
                break;
            case '--stop-on-error':
                options.continueOnError = false;
                break;
            case '--help':
                console.log(`
Database Import Tool

Usage: ts-node import-exported-data.ts [options]

Options:
  --export-dir <directory>     Use specific export directory
  --clear-database             Clear target database before import
  --skip-tables <table1,table2> Skip specific tables
  --only-tables <table1,table2> Import only specific tables
  --stop-on-error              Stop on first error (default: continue)
  --help                       Show this help message

Examples:
  ts-node import-exported-data.ts
  ts-node import-exported-data.ts --clear-database
  ts-node import-exported-data.ts --only-tables "user,product,order"
  ts-node import-exported-data.ts --skip-tables "temp_table,log_table"
                `);
                process.exit(0);
        }
    }

    try {
        const importer = new DataImporter(options);
        await importer.importDatabase();
    } catch (error) {
        console.error('❌ Import failed:', error);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}

export default DataImporter;
