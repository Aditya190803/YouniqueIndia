import { MigrationInterface, QueryRunner } from 'typeorm';

export class Initial1700000000000 implements MigrationInterface {
    name = 'Initial1700000000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Initial migration - Vendure will create the database schema
        // This file exists to satisfy the migrations configuration
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // This is the initial migration, so no down migration is needed
    }
}
