# YouniqueIndia

This project was generated with [`@vendure/create`](https://github.com/vendure-ecommerce/vendure/tree/master/packages/create).

Useful links:

- [Vendure docs](https://www.vendure.io/docs)
- [Vendure Discord community](https://www.vendure.io/community)
- [Vendure on GitHub](https://github.com/vendure-ecommerce/vendure)
- [Vendure plugin template](https://github.com/vendure-ecommerce/plugin-template)

# YouniqueIndia

This project was generated with [`@vendure/create`](https://github.com/vendure-ecommerce/vendure/tree/master/packages/create).

## Directory structure
## Payments: Settlement without upfront payment (Pinelab)

This project uses the Pinelab Payment Extensions plugin to allow settling orders without an external PSP. It provides:

- `isCustomerInGroupPaymentChecker`: restrict payment method eligibility to members of a specific CustomerGroup.
- `settleWithoutPaymentHandler`: immediately settles the Payment when added.
- Legacy Razorpay tooling has been removed; the WhatsApp handler documented below replaces it for manual confirmation flows.

Setup steps:

1. Ensure the plugin is enabled in `src/vendure-config.ts` and that `settleWithoutPaymentHandler` and `isCustomerInGroupPaymentChecker` are included in `paymentOptions`.
2. Start the server and open Admin > Settings > Payment Methods.
3. Create a new Payment Method:
	- Eligibility checker: `isCustomerInGroupPaymentChecker` and select the desired CustomerGroup.
	- Payment handler: `settleWithoutPaymentHandler`.
4. Save. Customers in the selected group will see this method and orders will be settled on checkout.

## Payments: WhatsApp manual flow

The custom WhatsApp payment integration adds a manual checkout route for customers who confirm orders over chat.

- **Payment method**: `whatsapp-payment` is registered alongside the existing handlers. Adding this payment to an order automatically associates the contact details, creates (or reuses) a customer account, and keeps the order in the Vendure `Draft` state so staff can review it before fulfilment.
- **GraphQL helper**: A mutation is exposed on both Shop and Admin APIs to automate the flow from a storefront or back-office UI:

```graphql
mutation CreateWhatsappDraftOrder($input: WhatsappDraftOrderInput!) {
	createWhatsappDraftOrder(input: $input) {
		order { id code state totalWithTax }
		customer { id emailAddress phoneNumber }
		createdCustomer
		generatedEmailAddress
	}
}
```

The input accepts the shopper's name, phone number, optional email, any order lines, and optional addresses. When an email is not supplied, a unique placeholder address is generated so the new account can still sign in later via a password reset.

Once payment is confirmed in WhatsApp, staff can settle the order manually through the admin UI.


* `/src` contains the source code of your Vendure server. All your custom code and plugins should reside here.
* `/static` contains static (non-code) files such as assets (e.g. uploaded images) and email templates.

## Caching: Stellate GraphQL edge cache

The server can automatically purge the [Stellate](https://stellate.co) cache whenever catalog data changes. The integration is provided by `@vendure/stellate-plugin` and is enabled when the required environment variables are present:

- `STELLATE_SERVICE_NAME`: The Stellate service slug (e.g. `my-vendure` if the endpoint is `https://my-vendure.stellate.sh`). If omitted, the value is derived from `VITE_STELLATE_SHOP_API_URL` / `STELLATE_SHOP_API_URL`.
- `STELLATE_PURGE_API_TOKEN` (or legacy `STELLATE_PURGE_TOKEN`): Purging API token generated in the Stellate dashboard.
- `STELLATE_DEBUG_MODE` (optional): Set to `true` to log purge calls. Useful in dev while diagnosing rules.
- `STELLATE_DEV_MODE` (optional): Overrides the default dev-mode detection; set to `false` in production if you need to force purges.
- `STELLATE_PURGE_BUFFER_MS` (optional): Number of milliseconds to batch purge requests (defaults to Vendure's 2000ms).

Whenever a `Facet` changes (for example toggling the `showOnProductDetail` field) the cache for the `SearchResponse` type is also purged so storefront search results stay in sync.

## Development

```
npm run dev
```

will start the Vendure server and [worker](https://www.vendure.io/docs/developer-guide/vendure-worker/) processes from
the `src` directory.

### Product data dump

Export the full product catalog from the public Shop API and write a timestamped JSON snapshot:

```
npm run dump:products
```

The script hits `https://youniqueindia.onrender.com/shop-api` by default (override with `SHOP_API_URL`) and stores the output in `data-dumps/shop-products/`.

## Build

```
npm run build
```

will compile the TypeScript sources into the `/dist` directory.

## Production

For production, there are many possibilities which depend on your operational requirements as well as your production
hosting environment.

### Running directly

You can run the built files directly with the `start` script:

```
npm run start
```

You could also consider using a process manager like [pm2](https://pm2.keymetrics.io/) to run and manage
the server & worker processes.

### Using Docker

We've included a sample [Dockerfile](./Dockerfile) which you can build with the following command:

```
docker build -t vendure .
```

This builds an image and tags it with the name "vendure". We can then run it with:

```
# Run the server
docker run -dp 3000:3000 -e "DB_HOST=host.docker.internal" --name vendure-server vendure npm run start:server

# Run the worker
docker run -dp 3000:3000 -e "DB_HOST=host.docker.internal" --name vendure-worker vendure npm run start:worker
```

Here is a breakdown of the command used above:

- `docker run` - run the image we created with `docker build`
- `-dp 3000:3000` - the `-d` flag means to run in "detached" mode, so it runs in the background and does not take
control of your terminal. `-p 3000:3000` means to expose port 3000 of the container (which is what Vendure listens
on by default) as port 3000 on your host machine.
- `-e "DB_HOST=host.docker.internal"` - the `-e` option allows you to define environment variables. In this case we
are setting the `DB_HOST` to point to a special DNS name that is created by Docker desktop which points to the IP of
the host machine. Note that `host.docker.internal` only exists in a Docker Desktop environment and thus should only be
used in development.
- `--name vendure-server` - we give the container a human-readable name.
- `vendure` - we are referencing the tag we set up during the build.
- `npm run start:server` - this last part is the actual command that should be run inside the container.

### Docker Compose

We've included a [docker-compose.yml](./docker-compose.yml) file which includes configuration for commonly-used
services such as PostgreSQL, MySQL, MariaDB, Elasticsearch and Redis.

To use Docker Compose, you will need to have Docker installed on your machine. Here are installation
instructions for [Mac](https://docs.docker.com/desktop/install/mac-install/), [Windows](https://docs.docker.com/desktop/install/windows-install/),
and [Linux](https://docs.docker.com/desktop/install/linux/).

You can start the services with:

```shell
docker-compose up <service>

# examples:
docker-compose up postgres_db
docker-compose up redis
```

## Plugins

In Vendure, your custom functionality will live in [plugins](https://www.vendure.io/docs/plugins/).
These should be located in the `./src/plugins` directory.

To create a new plugin run:

```
npx vendure add
```

and select `[Plugin] Create a new Vendure plugin`.

## Migrations

[Migrations](https://www.vendure.io/docs/developer-guide/migrations/) allow safe updates to the database schema. Migrations
will be required whenever you make changes to the `customFields` config or define new entities in a plugin.

To generate a new migration, run:

```
npx vendure migrate
```

The generated migration file will be found in the `./src/migrations/` directory, and should be committed to source control.
Next time you start the server, and outstanding migrations found in that directory will be run by the `runMigrations()`
function in the [index.ts file](./src/index.ts).

If, during initial development, you do not wish to manually generate a migration on each change to customFields etc, you
can set `dbConnectionOptions.synchronize` to `true`. This will cause the database schema to get automatically updated
on each start, removing the need for migration files. Note that this is **not** recommended once you have production
data that you cannot lose.

---

You can also run any pending migrations manually, without starting the server via the "vendure migrate" command.

---

## Troubleshooting

### Error: Could not load the "sharp" module using the \[OS\]-x\[Architecture\] runtime when running Vendure server.

- Make sure your Node version is ^18.17.0 || ^20.3.0 || >=21.0.0 to support the Sharp library.
- Make sure your package manager is up to date.
- **Not recommended**: if none of the above helps to resolve the issue, install sharp specifying your machines OS and Architecture. For example: `pnpm install sharp --config.platform=linux --config.architecture=x64` or `npm install sharp --os linux --cpu x64`

