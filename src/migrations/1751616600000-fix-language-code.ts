import { MigrationInterface, QueryRunner } from "typeorm";

export class FixLanguageCode1751616600000 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Ensure all product translations have proper language codes
        await queryRunner.query(`
            UPDATE "product_translation" 
            SET "languageCode" = 'en' 
            WHERE "languageCode" IS NULL OR "languageCode" = ''
        `);

        // Ensure all product variant translations have proper language codes
        await queryRunner.query(`
            UPDATE "product_variant_translation" 
            SET "languageCode" = 'en' 
            WHERE "languageCode" IS NULL OR "languageCode" = ''
        `);

        // Ensure all collection translations have proper language codes
        await queryRunner.query(`
            UPDATE "collection_translation" 
            SET "languageCode" = 'en' 
            WHERE "languageCode" IS NULL OR "languageCode" = ''
        `);

        // Ensure all facet translations have proper language codes
        await queryRunner.query(`
            UPDATE "facet_translation" 
            SET "languageCode" = 'en' 
            WHERE "languageCode" IS NULL OR "languageCode" = ''
        `);

        // Ensure all facet value translations have proper language codes
        await queryRunner.query(`
            UPDATE "facet_value_translation" 
            SET "languageCode" = 'en' 
            WHERE "languageCode" IS NULL OR "languageCode" = ''
        `);

        // Ensure the default channel has proper language configuration
        await queryRunner.query(`
            UPDATE "channel" 
            SET "defaultLanguageCode" = 'en',
                "availableLanguageCodes" = 'en'
            WHERE "code" = '__default_channel__'
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // This migration fixes data integrity issues, so no rollback is needed
        // Rolling back could cause the same GraphQL errors to reoccur
    }
}
