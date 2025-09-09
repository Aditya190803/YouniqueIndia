// Sample Frontend Integration for Razorpay Plugin
// This file shows how to integrate with the Vendure Razorpay Plugin from a frontend application
// Note: This is an example file and contains TypeScript errors because it's not meant to be compiled
// in the backend. It's for reference when implementing the frontend integration.

import { gql } from '@apollo/client';

// GraphQL Mutations
export const GENERATE_RAZORPAY_ORDER_ID = gql`
  mutation generateRazorpayOrderId($vendureOrderId: ID!) {
    generateRazorpayOrderId(orderId: $vendureOrderId) {
      __typename
      ... on RazorpayOrderIdSuccess {
        razorpayOrderId
      }
      ... on RazorpayOrderIdGenerationError {
        errorCode
        message
      }
    }
  }
`;

export const ADD_PAYMENT_TO_ORDER_MUTATION = gql`
  mutation addPaymentToOrder($paymentInput: PaymentInput!) {
    addPaymentToOrder(input: $paymentInput) {
      __typename
      ... on Order {
        id
        code
        state
        totalWithTax
        payments {
          id
          state
          amount
          transactionId
        }
      }
      ... on PaymentFailedError {
        errorCode
        paymentErrorMessage
        message
      }
      ... on OrderPaymentStateError {
        errorCode
        message
      }
      ... on PaymentDeclinedError {
        message
        paymentErrorMessage
        errorCode
      }
    }
  }
`;

// Angular Service Example
export class RazorpayService {
  constructor(private apollo: Apollo) {}

  // Razorpay configuration
  private _razorpayOptions = {
    key: environment.razorpayKeyId, // Your Razorpay Key ID from environment
    order_id: '',
    currency: 'INR',
    description: 'YouniqueIndia Purchase',
    // image: 'https://your-logo-url.com/logo.png',
    prefill: {
      email: '',
      contact: '',
      name: '',
    },
    config: {
      display: {
        blocks: {
          card: {
            name: 'Pay with Card',
            instruments: [
              {
                method: 'card',
                networks: ['MasterCard', 'Visa', 'RuPay', 'Bajaj Finserv'],
              },
            ],
          },
          upi: {
            name: 'Pay using UPI',
            instruments: [
              {
                method: 'upi',
                flows: ['collect', 'intent', 'qr'],
                apps: ['google_pay', 'bhim', 'paytm', 'phonepe'],
              },
            ],
          },
          netbanking: {
            name: 'Pay using netbanking',
            instruments: [
              {
                method: 'netbanking',
              },
            ],
          },
          wallet: {
            name: 'Pay using wallets',
            instruments: [
              {
                method: 'wallet',
                wallets: ['phonepe', 'freecharge', 'airtelmoney'],
              },
            ],
          },
        },
        sequence: ['block.card', 'block.upi', 'block.netbanking', 'block.wallet'],
        preferences: {
          show_default_blocks: false,
        },
      },
    },
    handler: null, // Will be set dynamically
    modal: {
      ondismiss: null, // Will be set dynamically
    },
  };

  get razorpayOptions() {
    return this._razorpayOptions;
  }

  set razorpayOrderId(orderId: string) {
    this._razorpayOptions.order_id = orderId;
  }

  set razorpayPrefill({
    email,
    contact,
    name,
  }: {
    email: string | null;
    contact: string | null;
    name: string | null;
  }) {
    this._razorpayOptions.prefill = {
      email: email || '',
      contact: contact || '',
      name: name || '',
    };
  }

  set razorpaySuccessCallback(callback: (response: any) => void) {
    this._razorpayOptions.handler = callback;
  }

  set razorpayManualCloseCallback(callback: () => void) {
    this._razorpayOptions.modal.ondismiss = callback;
  }

  // Generate Razorpay order ID
  generateRazorpayOrderId(vendureOrderId: string) {
    return this.apollo
      .mutate({
        mutation: GENERATE_RAZORPAY_ORDER_ID,
        variables: { vendureOrderId },
      })
      .pipe(map((result: any) => result.data.generateRazorpayOrderId));
  }

  // Add payment to order
  addRazorpayPaymentToOrder(paymentMetadata: any) {
    const addPaymentMutationVariable = {
      paymentInput: {
        method: 'razorpay',
        metadata: JSON.stringify(paymentMetadata),
      },
    };

    return this.apollo
      .mutate({
        mutation: ADD_PAYMENT_TO_ORDER_MUTATION,
        variables: addPaymentMutationVariable,
      })
      .pipe(map((result: any) => result.data.addPaymentToOrder));
  }

  // Get Razorpay class from window
  get Razorpay() {
    if (!(window as any).Razorpay) {
      throw new Error(
        'Razorpay not loaded. Make sure you have loaded the Razorpay script.'
      );
    }
    return (window as any).Razorpay;
  }
}

// Script Loading Service
export class ScriptService {
  private scripts = [
    {
      name: 'razorpay',
      src: 'https://checkout.razorpay.com/v1/checkout.js',
    },
  ];

  loadScript(name: string): Promise<boolean> {
    return new Promise((resolve) => {
      const scriptObject = this.scripts.find((script) => script.name === name);

      if (scriptObject) {
        // Check if script is already loaded
        if (document.querySelector(`script[src="${scriptObject.src}"]`)) {
          resolve(true);
          return;
        }

        const script = document.createElement('script');
        script.src = scriptObject.src;
        script.onload = () => resolve(true);
        script.onerror = () => resolve(false);
        document.getElementsByTagName('head')[0].appendChild(script);
      } else {
        resolve(false);
      }
    });
  }
}

// Checkout Component Example
export class CheckoutComponent implements OnInit, OnDestroy {
  private destroy$ = new Subject<void>();
  razorpayFlowActive = false;

  constructor(
    private razorpayService: RazorpayService,
    private scriptService: ScriptService,
    private cd: ChangeDetectorRef,
    private zone: NgZone,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
  }

  async initiateRazorpayPayment(orderId: string) {
    try {
      this.razorpayFlowActive = true;
      this.cd.detectChanges();

      // 1. Load Razorpay script
      const isScriptLoaded = await this.scriptService.loadScript('razorpay');
      if (!isScriptLoaded) {
        throw new Error('Failed to load Razorpay script');
      }

      // 2. Generate Razorpay order ID
      this.razorpayService
        .generateRazorpayOrderId(orderId)
        .pipe(takeUntil(this.destroy$))
        .subscribe((response) => {
          this.onRazorpayIdGeneration(response);
        });
    } catch (error) {
      console.error('Error initiating Razorpay payment:', error);
      this.razorpayFlowActive = false;
      this.cd.detectChanges();
    }
  }

  onRazorpayIdGeneration(response: any) {
    if (response.__typename === 'RazorpayOrderIdSuccess') {
      const razorpayOrderId = response.razorpayOrderId;
      this.openRazorpayPopup(razorpayOrderId);
    } else {
      console.error(
        'Error generating Razorpay order ID:',
        response.message,
        response.errorCode
      );
      this.razorpayFlowActive = false;
      this.cd.detectChanges();
    }
  }

  openRazorpayPopup(razorpayOrderId: string) {
    try {
      const Razorpay = this.razorpayService.Razorpay;

      // Set order ID and customer details
      this.razorpayService.razorpayOrderId = razorpayOrderId;
      this.razorpayService.razorpayPrefill = {
        contact: this.customerDetails.phoneNumber,
        email: this.customerDetails.email,
        name: this.customerDetails.fullName,
      };

      // Set callbacks
      this.razorpayService.razorpaySuccessCallback = this.onRazorpayPaymentSuccess.bind(this);
      this.razorpayService.razorpayManualCloseCallback = this.onRazorpayManualClose.bind(this);

      // Create and open Razorpay instance
      const rzp = new Razorpay(this.razorpayService.razorpayOptions);

      // Handle payment failures
      rzp.on('payment.failed', (response: any) => {
        console.error('Payment failed:', response.error);
        this.zone.run(() => {
          this.razorpayFlowActive = false;
          this.cd.detectChanges();
        });
      });

      rzp.open();
    } catch (error) {
      console.error('Error opening Razorpay popup:', error);
      this.razorpayFlowActive = false;
      this.cd.detectChanges();
    }
  }

  onRazorpayPaymentSuccess(response: any) {
    console.log('Payment successful:', response);

    this.razorpayService
      .addRazorpayPaymentToOrder({
        razorpay_order_id: response.razorpay_order_id,
        razorpay_payment_id: response.razorpay_payment_id,
        razorpay_signature: response.razorpay_signature,
      })
      .pipe(takeUntil(this.destroy$))
      .subscribe((result) => {
        switch (result.__typename) {
          case 'PaymentFailedError':
          case 'PaymentDeclinedError':
          case 'IneligiblePaymentMethodError':
          case 'OrderPaymentStateError':
            console.error('Payment processing failed:', result.errorCode, result.message);
            this.razorpayFlowActive = false;
            this.cd.detectChanges();
            break;
          case 'Order':
            console.log('Payment processed successfully');
            this.zone.run(() => {
              this.router.navigate(['/order-confirmation'], {
                queryParams: { orderCode: result.code },
              });
            });
            break;
        }
      });
  }

  onRazorpayManualClose() {
    if (confirm('Are you sure you want to close the payment form?')) {
      console.log('Payment cancelled by user');
      this.razorpayFlowActive = false;
      this.cd.detectChanges();
    } else {
      console.log('User chose to complete the payment');
    }
  }
}

// Environment configuration
export const environment = {
  production: false,
  razorpayKeyId: 'rzp_test_your_key_id', // Replace with your Razorpay Key ID
  apiUrl: 'http://localhost:3000/shop-api',
  adminApiUrl: 'http://localhost:3000/admin-api',
};
