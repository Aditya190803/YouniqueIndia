# YouniqueIndia Scripts Directory

Essential scripts for managing the YouniqueIndia Vendure e-commerce platform.

## 🚀 Setup Scripts

### `setup-basic-data.ts`
Sets up essential store data including countries, zones, tax categories, shipping methods, and payment methods.
```bash
npx ts-node ./src/scripts/setup-basic-data.ts
```

### `setup-whatsapp-payment.ts`
Creates the WhatsApp payment method in the database.
```bash
npx ts-node ./src/scripts/setup-whatsapp-payment.ts
```

## 🔧 Fix Scripts

### `fix-column-type.ts`
Fixes column type issues for custom fields (specifically `customFieldsRazorpay_order_id`).
```bash
npx ts-node ./src/scripts/fix-column-type.ts
```

## 🧹 Database Management Scripts

### `clean-database.ts`
Completely cleans the database of all catalog data and resets ID sequences.
```bash
npx ts-node ./src/scripts/clean-database.ts
```

## 🌱 Data Seeding Scripts

### `seed-jewelry-final.ts`
Seeds the database with jewelry products, collections, and facets.
```bash
npx ts-node ./src/scripts/seed-jewelry-final.ts
```

## 🔄 Migration Scripts

### Database Migrations
Located in `src/migrations/`:
- `1700000000000-initial.ts` - Initial migration
- `1735977600000-set-inr-currency.ts` - Sets INR as default currency
- `1751616600000-fix-language-code.ts` - Fixes language code issues
- `1751616700000-add-razorpay-order-id-field.ts` - Adds Razorpay order ID custom field

## 🚨 Troubleshooting

### Common Issues and Solutions

1. **Custom Field Column Errors**
   ```bash
   # Run the column type fix
   npx ts-node ./src/scripts/fix-column-type.ts
   ```

2. **Payment Method Issues**
   ```bash
   # Setup WhatsApp payment
   npx ts-node ./src/scripts/setup-whatsapp-payment.ts
   ```

3. **Database Cleanup**
   ```bash
   # Clean database (WARNING: This will delete all data)
   npx ts-node ./src/scripts/clean-database.ts
   ```

## 📋 Script Execution Order

For a fresh setup:
1. `setup-basic-data.ts` - Set up basic store configuration
2. `setup-whatsapp-payment.ts` - Configure payment methods
3. `seed-jewelry-final.ts` - Add products and catalog data

For fixing issues:
1. `fix-column-type.ts` - Fix specific column type issues

## 🔧 Development Workflow

1. **After schema changes**: Run `npx vendure migrate` to apply migrations
2. **If issues arise**: Use the specific fix scripts based on the error type

## 📝 Notes

- All scripts use the Vendure configuration from `src/vendure-config.ts`
- Scripts are designed to be idempotent (safe to run multiple times)
- Database operations are wrapped in transactions where appropriate
- Error handling is implemented to provide clear feedback

## 🆘 Emergency Scripts

If you encounter critical issues:

1. **Database completely broken**: Use `clean-database.ts` (WARNING: Data loss)
2. **Migration issues**: Check `src/migrations/` for proper migration files
3. **Payment method problems**: Re-run `setup-whatsapp-payment.ts` 