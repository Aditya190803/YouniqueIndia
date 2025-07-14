import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddGoogleAuthCustomFields1751616900000 implements MigrationInterface {
    name = 'AddGoogleAuthCustomFields1751616900000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Add googleId column to customer table
        const googleIdExists = await queryRunner.hasColumn('customer', 'customFieldsGoogleId');
        if (!googleIdExists) {
            await queryRunner.query(`
                ALTER TABLE "customer"
                ADD COLUMN "customFieldsGoogleId" character varying(255)
            `);
        }

        // Add avatar column to customer table
        const avatarExists = await queryRunner.hasColumn('customer', 'customFieldsAvatar');
        if (!avatarExists) {
            await queryRunner.query(`
                ALTER TABLE "customer"
                ADD COLUMN "customFieldsAvatar" character varying(255)
            `);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Remove googleId column
        const googleIdExists = await queryRunner.hasColumn('customer', 'customFieldsGoogleId');
        if (googleIdExists) {
            await queryRunner.query(`
                ALTER TABLE "customer"
                DROP COLUMN "customFieldsGoogleId"
            `);
        }

        // Remove avatar column
        const avatarExists = await queryRunner.hasColumn('customer', 'customFieldsAvatar');
        if (avatarExists) {
            await queryRunner.query(`
                ALTER TABLE "customer"
                DROP COLUMN "customFieldsAvatar"
            `);
        }
    }
} 