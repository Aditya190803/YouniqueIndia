# Vite Frontend: Razorpay + Vendure Integration

This guide shows how to integrate Razorpay checkout in a Vite (React) app with this Vendure backend.

## Prerequisites
- Vendure server running locally at http://localhost:3000
- Razorpay payment method configured in Admin UI (code: razorpay)
- This repo already includes a mutation to generate Razorpay order IDs

## 1) Set env vars in your Vite app
Create `.env.local` in your Vite frontend:

```
VITE_SHOP_API_URL=http://localhost:3000/shop-api
VITE_RAZORPAY_KEY_ID=rzp_test_xxxxxxxxx
```

Access them with `import.meta.env.VITE_*`.

## 2) Load Razorpay script
Add a tiny script loader utility:

```ts
// src/utils/loadScript.ts
export async function loadScript(src: string): Promise<boolean> {
  return new Promise((resolve) => {
    if (document.querySelector(`script[src="${src}"]`)) return resolve(true);
    const s = document.createElement('script');
    s.src = src;
    s.onload = () => resolve(true);
    s.onerror = () => resolve(false);
    document.head.appendChild(s);
  });
}
```

## 3) GraphQL operations
Use simple fetch calls with cookies (Vendure session):

```ts
// src/api/shop.ts
const SHOP_API_URL = import.meta.env.VITE_SHOP_API_URL;

async function gql(query: string, variables?: any) {
  const res = await fetch(SHOP_API_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify({ query, variables }),
  });
  const json = await res.json();
  if (json.errors?.length) throw new Error(json.errors[0].message);
  return json.data;
}

export async function getActiveOrder() {
  return gql(`
    query {
      activeOrder { id code state totalWithTax customer { emailAddress } }
    }
  `).then(d => d.activeOrder);
}

export async function generateRazorpayOrderId() {
  return gql(`
    mutation { generateRazorpayOrderId { __typename ... on RazorpayOrderIdSuccess { razorpayOrderId } ... on RazorpayOrderIdGenerationError { errorCode message } } }
  `).then(d => d.generateRazorpayOrderId);
}

export async function addPaymentToOrder(paymentMeta: Record<string, any>) {
  return gql(`
    mutation($input: PaymentInput!) {
      addPaymentToOrder(input: $input) {
        __typename
        ... on Order { id code state }
        ... on PaymentFailedError { errorCode message paymentErrorMessage }
        ... on PaymentDeclinedError { errorCode message paymentErrorMessage }
        ... on OrderPaymentStateError { errorCode message }
      }
    }
  `, { input: { method: 'razorpay', metadata: JSON.stringify(paymentMeta) } })
  .then(d => d.addPaymentToOrder);
}
```

## 4) React checkout button

```tsx
// src/components/RazorpayButton.tsx
import React, { useState } from 'react';
import { loadScript } from '../utils/loadScript';
import { getActiveOrder, generateRazorpayOrderId, addPaymentToOrder } from '../api/shop';

declare global { interface Window { Razorpay: any } }

export function RazorpayButton({ onSuccess }: { onSuccess?: (orderCode: string) => void }) {
  const [loading, setLoading] = useState(false);

  async function pay() {
    setLoading(true);
    try {
      const ok = await loadScript('https://checkout.razorpay.com/v1/checkout.js');
      if (!ok) throw new Error('Failed to load Razorpay SDK');

      const order = await getActiveOrder();
      if (!order || order.state !== 'ArrangingPayment') {
        throw new Error('Order not ready for payment');
      }

      const gen = await generateRazorpayOrderId();
      if (gen.__typename !== 'RazorpayOrderIdSuccess') {
        throw new Error(gen.message || 'Failed to create Razorpay order');
      }

      const rzp = new window.Razorpay({
        key: import.meta.env.VITE_RAZORPAY_KEY_ID,
        order_id: gen.razorpayOrderId,
        currency: 'INR',
        name: 'YouniqueIndia',
        description: `Order ${order.code}`,
        handler: async (resp: any) => {
          const res = await addPaymentToOrder({
            razorpay_order_id: resp.razorpay_order_id,
            razorpay_payment_id: resp.razorpay_payment_id,
            razorpay_signature: resp.razorpay_signature,
          });
          if (res.__typename === 'Order') onSuccess?.(res.code);
          else throw new Error(res.message || 'Payment failed');
        },
        modal: { ondismiss: () => setLoading(false) },
        prefill: { email: order.customer?.emailAddress || '' },
      });
      rzp.open();
    } catch (e: any) {
      alert(e.message || 'Payment error');
    } finally {
      setLoading(false);
    }
  }

  return (
    <button disabled={loading} onClick={pay}>
      {loading ? 'Processing…' : 'Pay with Razorpay'}
    </button>
  );
}
```

## 5) CORS and cookies
- This backend is configured to allow Vite origins at http://localhost:5173
- Always use `credentials: 'include'` in fetch to preserve the Vendure session

## 6) Test
- Start Vendure server
- Start Vite app on 5173
- Add item to cart, proceed to checkout until order is ArrangingPayment
- Click “Pay with Razorpay” and complete the flow using Razorpay test cards

That’s it. Your Vite app will create a Razorpay order, open the checkout, and confirm the payment with Vendure.
