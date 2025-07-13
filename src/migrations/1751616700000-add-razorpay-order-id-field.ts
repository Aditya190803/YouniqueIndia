import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddRazorpayOrderIdField1751616700000 implements MigrationInterface {
    name = 'AddRazorpayOrderIdField1751616700000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Check if the column already exists
        const columnExists = await queryRunner.hasColumn('order', 'customFieldsRazorpay_order_id');
        if (!columnExists) {
            await queryRunner.query(`
                ALTER TABLE "order"
                ADD COLUMN "customFieldsRazorpay_order_id" character varying(255)
            `);
        } else {
            // Ensure the type is correct
            await queryRunner.query(`
                ALTER TABLE "order"
                ALTER COLUMN "customFieldsRazorpay_order_id" TYPE character varying(255)
            `);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const columnExists = await queryRunner.hasColumn('order', 'customFieldsRazorpay_order_id');
        if (columnExists) {
            await queryRunner.query(`
                ALTER TABLE "order"
                DROP COLUMN "customFieldsRazorpay_order_id"
            `);
        }
    }
} 