import { MigrationInterface, QueryRunner } from 'typeorm';

export class RemoveRazorpayOrderIdField1751616800000 implements MigrationInterface {
    name = 'RemoveRazorpayOrderIdField1751616800000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Check if the column exists before trying to drop it
        const columnExists = await queryRunner.hasColumn('order', 'customFieldsRazorpay_order_id');
        if (columnExists) {
            await queryRunner.query(`
                ALTER TABLE "order"
                DROP COLUMN "customFieldsRazorpay_order_id"
            `);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Recreate the column if needed (for rollback)
        const columnExists = await queryRunner.hasColumn('order', 'customFieldsRazorpay_order_id');
        if (!columnExists) {
            await queryRunner.query(`
                ALTER TABLE "order"
                ADD COLUMN "customFieldsRazorpay_order_id" character varying(255)
            `);
        }
    }
} 