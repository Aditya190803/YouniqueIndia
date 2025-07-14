import { MigrationInterface, QueryRunner } from 'typeorm';

export class FixGoogleIdColumnName1751617000000 implements MigrationInterface {
    name = 'FixGoogleIdColumnName1751617000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        const hasOld = await queryRunner.hasColumn('customer', 'customFieldsGoogleId');
        const hasNew = await queryRunner.hasColumn('customer', 'customFieldsGoogleid');
        if (hasOld && !hasNew) {
            await queryRunner.query(`
                ALTER TABLE "customer"
                RENAME COLUMN "customFieldsGoogleId" TO "customFieldsGoogleid"
            `);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const hasNew = await queryRunner.hasColumn('customer', 'customFieldsGoogleid');
        const hasOld = await queryRunner.hasColumn('customer', 'customFieldsGoogleId');
        if (hasNew && !hasOld) {
            await queryRunner.query(`
                ALTER TABLE "customer"
                RENAME COLUMN "customFieldsGoogleid" TO "customFieldsGoogleId"
            `);
        }
    }
} 