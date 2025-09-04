// Example frontend integration for Razorpay with your Vendure backend
// This would typically be in your Next.js/React storefront

// 1. Create Razorpay order on your backend (custom GraphQL mutation needed)
async function createRazorpayOrder(orderTotal, vendureOrderId) {
  // You might need to create this GraphQL mutation
  const mutation = `
    mutation CreateRazorpayOrder($amount: Int!, $orderId: String!) {
      createRazorpayOrder(amount: $amount, orderId: $orderId) {
        id
        amount
        currency
        key
      }
    }
  `;
  
  const response = await fetch('/shop-api', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      query: mutation,
      variables: { amount: orderTotal * 100, orderId: vendureOrderId }
    })
  });
  
  return response.json();
}

// 2. Initialize Razorpay checkout
async function initiateRazorpayPayment(vendureOrder) {
  // Create Razorpay order
  const razorpayOrder = await createRazorpayOrder(
    vendureOrder.totalWithTax, 
    vendureOrder.id
  );

  const options = {
    key: razorpayOrder.data.createRazorpayOrder.key, // Your Razorpay key
    amount: razorpayOrder.data.createRazorpayOrder.amount,
    currency: 'INR',
    order_id: razorpayOrder.data.createRazorpayOrder.id,
    name: 'YouniqueIndia',
    description: `Order ${vendureOrder.code}`,
    image: '/logo.png',
    handler: async function (response) {
      // 3. Send payment data to Vendure for verification
      await addPaymentToOrder({
        razorpay_order_id: response.razorpay_order_id,
        razorpay_payment_id: response.razorpay_payment_id,
        razorpay_signature: response.razorpay_signature,
      });
    },
    prefill: {
      name: vendureOrder.customer?.firstName + ' ' + vendureOrder.customer?.lastName,
      email: vendureOrder.customer?.emailAddress,
      contact: vendureOrder.customer?.phoneNumber,
    },
    theme: {
      color: '#3399cc'
    }
  };

  const rzp = new Razorpay(options);
  rzp.open();
}

// 3. Add payment to Vendure order
async function addPaymentToOrder(paymentData) {
  const mutation = `
    mutation AddPaymentToOrder($input: PaymentInput!) {
      addPaymentToOrder(input: $input) {
        __typename
        ... on Order {
          id
          code
          state
          payments {
            id
            state
            amount
            transactionId
          }
        }
        ... on OrderPaymentStateError {
          errorCode
          message
        }
      }
    }
  `;

  const response = await fetch('/shop-api', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      query: mutation,
      variables: {
        input: {
          method: 'razorpay',
          metadata: paymentData
        }
      }
    })
  });

  const result = await response.json();
  
  if (result.data.addPaymentToOrder.__typename === 'Order') {
    console.log('Payment successful!');
    // Redirect to success page
    window.location.href = '/order-success';
  } else {
    console.error('Payment failed:', result.data.addPaymentToOrder.message);
  }
}
