import { MigrationInterface, QueryRunner } from 'typeorm';

export class FixAssetMimeTypeColumn1751617200000 implements MigrationInterface {
    name = 'FixAssetMimeTypeColumn1751617200000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Drop 'mimetype' column if it exists
        const hasMimetype = await queryRunner.hasColumn('asset', 'mimetype');
        if (hasMimetype) {
            await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "mimetype"`);
        }
        // Add 'mimeType' column if it does not exist
        const hasMimeType = await queryRunner.hasColumn('asset', 'mimeType');
        if (!hasMimeType) {
            await queryRunner.query(`ALTER TABLE "asset" ADD COLUMN "mimeType" character varying(255) NOT NULL DEFAULT ''`);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop 'mimeType' column if it exists
        const hasMimeType = await queryRunner.hasColumn('asset', 'mimeType');
        if (hasMimeType) {
            await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "mimeType"`);
        }
        // Add 'mimetype' column back as nullable
        const hasMimetype = await queryRunner.hasColumn('asset', 'mimetype');
        if (!hasMimetype) {
            await queryRunner.query(`ALTER TABLE "asset" ADD COLUMN "mimetype" character varying(255)`);
        }
    }
} 