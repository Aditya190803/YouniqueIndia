import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddMimetypeToAsset1751617100000 implements MigrationInterface {
    name = 'AddMimetypeToAsset1751617100000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        const hasColumn = await queryRunner.hasColumn('asset', 'mimetype');
        if (!hasColumn) {
            await queryRunner.query(`ALTER TABLE "asset" ADD COLUMN "mimetype" character varying(255)`);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const hasColumn = await queryRunner.hasColumn('asset', 'mimetype');
        if (hasColumn) {
            await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "mimetype"`);
        }
    }
} 