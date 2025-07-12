# WhatsApp Payment Plugin for Vendure

This plugin enables WhatsApp-based payment processing for your Vendure e-commerce store. When customers choose this payment method, their order details are automatically formatted and sent via WhatsApp for manual processing.

## Features

- 🚀 **Easy Setup**: One-time configuration with your WhatsApp number
- 📱 **Mobile-Friendly**: Works on all devices with WhatsApp
- 💬 **Rich Messages**: Formatted order details with customer info
- 🔧 **Customizable**: Easy to modify message templates
- 🇮🇳 **India-Ready**: Pre-configured for Indian market (INR currency)

## How It Works

1. **Customer Checkout**: Customer selects "WhatsApp Payment" at checkout
2. **Order Details**: System generates formatted WhatsApp message with order details
3. **WhatsApp Integration**: Customer clicks button to send message via WhatsApp
4. **Manual Processing**: You receive order details and process payment manually
5. **Order Completion**: Mark payment as received in Vendure admin panel

## Installation

The plugin is already installed in your project. Follow these steps to activate it:

### 1. Configure WhatsApp Number

Edit the setup script to use your WhatsApp number:

```bash
# Edit the script
code src/scripts/setup-whatsapp-payment.ts

# Change this line (around line 34):
whatsappNumber: '+919876543210', // Replace with your WhatsApp number
```

### 2. Run Setup Script

```bash
npx ts-node ./src/scripts/setup-whatsapp-payment.ts
```

### 3. Restart Server

```bash
npm run dev
```

### 4. Verify in Admin

1. Go to http://localhost:3000/admin
2. Navigate to Settings → Payment Methods
3. You should see "WhatsApp Payment" listed

## Storefront Integration

### Basic HTML Integration

Add this to your checkout page:

```html
<div id="whatsapp-payment"></div>

<script>
// Include the integration script
// Copy code from src/plugins/whatsapp-payment/integration-guide.js
</script>
```

### Example Usage

```javascript
// When customer selects WhatsApp payment
const order = {
    code: 'ORDER-123',
    totalWithTax: 7500000, // ₹75,000 in cents
    lines: [
        {
            productVariant: { name: 'Gold Diamond Ring' },
            quantity: 1,
            unitPriceWithTax: 7500000,
            linePriceWithTax: 7500000
        }
    ],
    customer: {
        firstName: 'John',
        lastName: 'Doe',
        emailAddress: 'john@example.com'
    },
    shippingAddress: {
        phoneNumber: '+919876543210',
        streetLine1: '123 Main Street',
        city: 'Mumbai',
        postalCode: '400001'
    }
};

// Initialize WhatsApp payment
handleWhatsAppPayment(order);
```

## Message Format

The WhatsApp message includes:

- 📋 **Order Details**: Order ID, date
- 👤 **Customer Info**: Name, email, phone, address
- 🛍️ **Items**: Product names, quantities, prices
- 💰 **Total Amount**: Final total in INR
- 📞 **Call to Action**: Request for confirmation

## Admin Workflow

1. **Receive WhatsApp**: Order details arrive on your WhatsApp
2. **Verify Order**: Check order details in Vendure admin
3. **Confirm with Customer**: Respond via WhatsApp
4. **Process Payment**: Share payment instructions (UPI, bank transfer, etc.)
5. **Receive Payment**: Customer sends payment
6. **Mark as Paid**: Update payment status in Vendure admin
7. **Ship Order**: Process and ship the order

## Customization

### Change WhatsApp Number

Edit `src/scripts/setup-whatsapp-payment.ts`:

```typescript
whatsappNumber: '+919876543210', // Your number
```

### Modify Message Template

Edit `src/plugins/whatsapp-payment/whatsapp-payment-handler.ts`:

```typescript
function formatOrderForWhatsApp(order: Order, args: any): string {
    // Customize your message template here
    let message = `🙏 *New Order from ${args.businessName}*\n\n`;
    // ... rest of your custom template
    return message;
}
```

### Add Business Hours Check

```typescript
function isBusinessHours(): boolean {
    const now = new Date();
    const hour = now.getHours();
    return hour >= 9 && hour <= 18; // 9 AM to 6 PM
}
```

## Payment Processing Options

### Bank Transfer
- Share bank account details via WhatsApp
- Customer transfers money and shares receipt
- Verify payment in bank account

### UPI Payments
- Share UPI ID or QR code
- Customer pays via any UPI app
- Verify transaction ID

### Cash on Delivery
- For local deliveries
- Collect payment during delivery

## Troubleshooting

### WhatsApp Link Not Working
- Ensure phone number includes country code (+91 for India)
- Remove spaces, dashes, or special characters
- Test the generated WhatsApp URL manually

### Payment Method Not Visible
- Check if plugin is loaded in vendure-config.ts
- Restart the server after adding plugin
- Verify payment method is enabled in admin

### Message Not Formatted Properly
- Check if all order data is available
- Verify message encoding for special characters
- Test with different order scenarios

## Security Considerations

- ✅ No sensitive payment data is transmitted
- ✅ Manual verification of all orders
- ✅ WhatsApp provides message encryption
- ⚠️ Always verify customer identity before processing
- ⚠️ Keep payment confirmations for records

## Support

For issues or questions:
1. Check the integration guide in `src/plugins/whatsapp-payment/integration-guide.js`
2. Review Vendure payment plugin documentation
3. Test with small orders first

## License

This plugin is part of your YouniqueIndia project and follows the same license terms.
