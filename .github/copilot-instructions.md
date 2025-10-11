# AI Assistant Guide for YouniqueIndia

Use this as your quick-start map for making useful, correct changes fast.

## Architecture & entry points
- Platform: Vendure (Headless Commerce) on Node.js/TypeScript.
- Runtime processes:
  - Server: `src/index.ts` boots Vendure after `runMigrations(config)`.
  - Worker: `src/index-worker.ts` boots the worker and starts job queue.
- Central config: `src/vendure-config.ts` (ports, CORS, auth, DB, plugins, payment/shipping, Email, Admin UI).
- DB access for scripts: `src/data-source.ts` (TypeORM DataSource for wipe/reset).

## Key integrations
- Assets: Cloudinary via `AssetServerPlugin` with custom strategy `plugins/cloudinary/cloudinary-asset-storage-strategy.ts`.
  - Strategy caches recent uploads and retries reads to avoid eventual-consistency 404s. Identifiers are normalized; use base filenames where possible.
- Email: Vendure `EmailPlugin` uses `ResendEmailSender` (`config/resend-email-sender.ts`) with `transport: none`.
  - Dev mailbox toggle: `EMAIL_DEV_MAILBOX=true` serves emails at `/mailbox`.
- Payments: Pinelab Payment Extensions plugin; enabled handler/checker in `paymentOptions`:
  - `settleWithoutPaymentHandler` (immediate settle)
  - `isCustomerInGroupPaymentChecker` (eligibility by customer group)
- Shipping: Always-eligible free shipping checkers (`plugins/shipping/*`) + `manualFulfillmentHandler`.

## Data & migrations
- Migrations are run on server start (`runMigrations`).
- Dev enables `dbConnectionOptions.synchronize` to true; disable in prod.
- Currency migration `src/migrations/1735977600000-set-inr-currency.ts` sets channel currency to INR.
- Wipe schema: `npm run db:wipe` (drops/creates `DB_SCHEMA`).

## Scripts & workflows
- Dev: `npm run dev` (concurrently server+worker via ts-node).
- Build: `npm run build` → `dist/`; Prod: `npm run start` (server+worker from dist).
- Initial setup: `npm run setup` (zones, tax, free shipping, payment method placeholder, channel INR).
- Seed products: `npm run seed` (imports from `src/scripts/2-seed-products.generated.ts`, attaches local assets from `static/assets/seed`).
  - If seeding fails on tax zone, script self-heals by ensuring a default tax setup.
- Test email: `npm run email:test -- --to you@example.com` (uses Resend API).

## Environment variables (most used)
- Database: `DATABASE_URL` or `DB_HOST, DB_PORT, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_SCHEMA, DB_SSL`.
- Server/UI: `PORT, NODE_ENV, APP_ENV, TRUST_PROXY_SETTING`.
- Auth: `SUPERADMIN_USERNAME, SUPERADMIN_PASSWORD, COOKIE_SECRET`.
- Cloudinary: `CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUDINARY_FOLDER`.
- Email/Resend: `RESEND_API_KEY, FROM_EMAIL, EMAIL_DEV_MAILBOX` and URLs `VERIFY_EMAIL_URL, PASSWORD_RESET_URL, CHANGE_EMAIL_URL`.

## Conventions & patterns
- Use `vendure-config.ts` for most cross-cutting changes (CORS, plugins, payment/shipping, Email).
- When touching Cloudinary asset handling, prefer base filenames—seed pipeline flattens paths to avoid fetch mismatches.
- For local/dev with `DB_SSL=true`, TLS validation is disabled in-process (do not replicate in prod).
- INR-only store: use helpers in `utils/currency-utils.ts` (e.g. `formatInrCurrency`, `rupeesToPaise`).
- Tests: Jest `ts-jest` preset; specs match `**/*.spec.ts`.

## Examples to mirror
- Add shipping eligibility checker: see `plugins/shipping/always-free-shipping-checker.ts`.
- Create a simple Nest/Vendure plugin: `plugins/customer-registration/*` and `plugins/currency-config/*`.
- Seed assets from local files: see `attachLocalAssets()` in `src/scripts/import-seed-products.ts` and the `static/assets/seed` directory.

## Gotchas
- Seeding depends on Admin context, default channel, and a default tax zone; script repairs if missing.
- Admin UI host/port are set in `AdminUiPlugin.init` based on `NODE_ENV`/`PORT`—keep in sync when deploying.
- If Cloudinary returns 404 right after upload, the strategy already retries/caches—avoid adding ad-hoc delays elsewhere.