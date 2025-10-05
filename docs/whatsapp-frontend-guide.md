# WhatsApp Payment Frontend Integration Guide

This document walks through the steps a storefront must take to support the WhatsApp manual payment flow that the backend now exposes. The goal is to capture customer intent in the UI, trigger the `createWhatsappDraftOrder` mutation, guide the shopper into chatting with the business over WhatsApp, and keep the resulting order code handy for staff to confirm once payment is received.

## 1. Understand the workflow

1. A shopper chooses “Pay via WhatsApp” at checkout.
2. Your frontend collects contact information, shipping/billing details, and the chosen cart items.
3. The frontend calls the Shop API mutation `createWhatsappDraftOrder` with those details.
4. The server creates (or updates) a customer record, builds a draft order, and replies with the order and customer data.
5. The UI shows a confirmation screen directing the shopper to send a WhatsApp message (including the returned order code) to complete payment offline.
6. Staff review the draft order in the Vendure Admin UI and settle it manually once payment is confirmed.

## 2. Prerequisites

- **GraphQL endpoint:** Ensure your storefront can reach the Shop API (`/shop-api`) over HTTPS. If you rely on cookies for sessions, use `credentials: 'include'` when making requests.
- **Authenticated session:** The mutation can run anonymously, but if your storefront uses logged-in sessions, reuse the same session token/cookies so the draft order attaches to the current cart context where applicable.
- **Cart state:** Gather the product variant IDs and quantities the shopper selected. The backend will use these to populate the draft order.

## 3. Collect the required fields

Build a form that collects the following:

| Field | Required? | Notes |
| --- | --- | --- |
| `firstName` | ✅ | Display name used for the draft customer account. |
| `lastName` | ➖ | Optional but recommended. |
| `phoneNumber` | ✅ | Use an international format (e.g., `+91XXXXXXXXXX`). The backend falls back on this to generate an email alias if one is not supplied. |
| `emailAddress` | ➖ | Optional. If omitted, a placeholder email of the form `whatsapp+<phone>@youniqueindia.local` is generated so the customer can still recover access later. |
| `notes` | ➖ | Extra instructions or context (e.g., preferred delivery time). |
| `lines[]` | ✅ | One entry per product variant with two fields: `productVariantId` (ID from your cart) and `quantity`. |
| `shippingAddress` | ➖ | Use Vendure’s `CreateAddressInput` shape (street, city, postal code, etc.). |
| `billingAddress` | ➖ | Same shape as `shippingAddress`; omit if billing matches shipping. |

### Frontend validation tips

- Strip non-digit characters from the phone while preserving a leading `+`.
- Ensure every `productVariantId` maps to an active cart line before firing the mutation.
- Only include address objects if the shopper provided all mandatory fields (name, street, city, country, postal code, etc.).

## 4. Call the GraphQL mutation

Use the same mutation that is documented in the README:

```graphql
mutation CreateWhatsappDraftOrder($input: WhatsappDraftOrderInput!) {
  createWhatsappDraftOrder(input: $input) {
    order {
      id
      code
      state
      totalWithTax
      currencyCode
      lines {
        id
        quantity
        productVariant {
          id
          name
        }
      }
    }
    customer {
      id
      emailAddress
      phoneNumber
      firstName
      lastName
    }
    createdCustomer
    generatedEmailAddress
  }
}
```

### Example variables payload

```json
{
  "input": {
    "firstName": "Aarav",
    "lastName": "Sharma",
    "phoneNumber": "+919876543210",
    "notes": "Please confirm colour before shipping",
    "lines": [
      { "productVariantId": "1", "quantity": 1 },
      { "productVariantId": "5", "quantity": 2 }
    ],
    "shippingAddress": {
      "fullName": "Aarav Sharma",
      "streetLine1": "12 Residency Road",
      "city": "Bengaluru",
      "postalCode": "560025",
      "countryCode": "IN",
      "phoneNumber": "+919876543210"
    }
  }
}
```

### Sending the request with `fetch`

```ts
const response = await fetch("/shop-api", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  credentials: "include", // keep session cookies if you rely on them
  body: JSON.stringify({
    query,
    variables,
  }),
});

const { data, errors } = await response.json();
if (errors?.length) {
  // surface the first error to the UI
  throw new Error(errors[0].message ?? "Unable to create WhatsApp draft order");
}

const payload = data.createWhatsappDraftOrder;
```

## 5. Handle the response

From the payload:

- `order.code` — display this prominently. Ask the shopper to mention it in the WhatsApp chat so staff can locate the draft order quickly.
- `order.state` — should be `Draft`. Use it to reassure the shopper their order is pending manual confirmation.
- `customer.emailAddress` — if `generatedCustomer` is `true`, this may contain the generated alias. Consider prompting shoppers to update their email later.
- `createdCustomer` — if `true`, inform the shopper that an account was created and that they will receive onboarding instructions once the order is confirmed.
- `generatedEmailAddress` — show only when present; explain it is temporary and can be changed later.

### UI suggestions

1. **Success screen**
   - Display the order code and summarized items/total.
   - Provide a “Message us on WhatsApp” button linking to `https://wa.me/<business-number>?text=Order%20code%20${order.code}%20-%20...`.
   - Include next steps (e.g., “We’ll confirm stock and reply with payment details”).

2. **Failure handling**
   - Show a friendly error message if the mutation fails.
   - Offer to retry and provide alternative contact options (phone/email).

## 6. Guide the shopper into WhatsApp

Use WhatsApp’s click-to-chat link with the order code prefilled:

```ts
const businessPhone = "+919999888877"; // update with your number
const message = encodeURIComponent(
  `Hi! I'd like to confirm order ${order.code}. My phone: ${userPhone}`
);
window.location.href = `https://wa.me/${businessPhone.replace(/[^0-9]/g, "")}?text=${message}`;
```

Display additional instructions (e.g., “If the button doesn’t open WhatsApp, save our number and message us manually”).

## 7. Optional: persist draft order locally

If you maintain local checkout state:

- Store the returned `order.id`/`code` in local storage or your app state so you can show a status page or allow the shopper to re-open the conversation later.
- Provide a “View WhatsApp Order Status” entry in the user’s account area (read-only). The order will remain in `Draft` until staff transitions it to `PaymentSettled` or closes it.

## 8. Notify staff (optional automation)

Trigger an internal notification so staff know a WhatsApp order is waiting:

- Send a Slack/email webhook containing `order.code`, customer contact details, and cart contents.
- Alternatively, mark the draft order with a distinctive note by calling the Admin API (requires secure credentials) after the Shop API mutation succeeds.

## 9. Staff confirmation flow (for reference)

Share these instructions with the operations team:

1. Open Vendure Admin → Orders → filter by `Draft` state.
2. Search for the order using the `order.code` provided by the shopper.
3. Verify payment in WhatsApp/UPI.
4. Transition the order to `PaymentSettled` and proceed with fulfilment as usual.

## 10. Testing checklist

- ✅ Anonymous shopper can submit the form and receive a draft order.
- ✅ Authenticated shopper reusing an existing account keeps the order tied to their customer record.
- ✅ Form validation prevents empty required fields.
- ✅ WhatsApp button opens the chat with the correct template message.
- ✅ Error states (network failure, validation failure) show actionable feedback.
- ✅ Staff can locate the generated order code and complete the manual settlement.

Implementing the above steps gives shoppers a smooth path from online browsing to WhatsApp-based payment while keeping your operations team in sync.
