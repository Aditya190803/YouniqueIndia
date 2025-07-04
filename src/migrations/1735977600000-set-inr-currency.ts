import {MigrationInterface, QueryRunner} from "typeorm";

export class SetInrCurrency1735977600000 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Update the default channel to use INR as the default and only currency
        await queryRunner.query(`
            UPDATE "channel" 
            SET "defaultCurrencyCode" = 'INR', 
                "availableCurrencyCodes" = 'INR'
            WHERE "code" = '__default_channel__'
        `);
        
        // Note: Since you're starting fresh with no existing products,
        // no price conversion is needed. All new products will be entered directly in INR.
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Revert the channel currency settings back to USD
        await queryRunner.query(`
            UPDATE "channel" 
            SET "defaultCurrencyCode" = 'USD', 
                "availableCurrencyCodes" = 'USD'
            WHERE "code" = '__default_channel__'
        `);
    }
}
