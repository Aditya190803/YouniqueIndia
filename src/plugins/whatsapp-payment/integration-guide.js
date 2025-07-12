// WhatsApp Payment Integration Documentation

/**
 * WhatsApp Payment Method for Vendure
 * 
 * This payment method allows customers to send order details via WhatsApp
 * for manual payment processing and confirmation.
 * 
 * SETUP INSTRUCTIONS:
 * 
 * 1. Update your WhatsApp number in the setup script:
 *    Edit src/scripts/setup-whatsapp-payment.ts and change the whatsappNumber
 * 
 * 2. Run the setup script to create the payment method:
 *    npx ts-node ./src/scripts/setup-whatsapp-payment.ts
 * 
 * 3. Restart your Vendure server to load the plugin
 * 
 * 4. In your storefront, integrate the WhatsApp payment flow:
 */

// Example storefront integration (vanilla JavaScript)
function initWhatsAppPayment(order) {
    const whatsappNumber = '+919876543210'; // Replace with your number
    const businessName = 'YouniqueIndia';
    
    // Generate WhatsApp message
    let message = `🙏 *New Order from ${businessName}*\n\n`;
    message += `📋 *Order Details:*\n`;
    message += `Order ID: ${order.code}\n`;
    message += `Date: ${new Date().toLocaleDateString('en-IN')}\n\n`;
    
    if (order.customer) {
        message += `👤 *Customer Details:*\n`;
        message += `Name: ${order.customer.firstName} ${order.customer.lastName}\n`;
        message += `Email: ${order.customer.emailAddress}\n`;
    }
    
    if (order.shippingAddress) {
        message += `Phone: ${order.shippingAddress.phoneNumber || 'Not provided'}\n`;
        message += `Address: ${order.shippingAddress.streetLine1}, ${order.shippingAddress.city}, ${order.shippingAddress.postalCode}\n`;
    }
    
    message += `\n🛍️ *Items Ordered:*\n`;
    order.lines.forEach((line, index) => {
        message += `${index + 1}. ${line.productVariant.name}\n`;
        message += `   Quantity: ${line.quantity}\n`;
        message += `   Price: ₹${(line.unitPriceWithTax / 100).toLocaleString('en-IN')}\n`;
        message += `   Total: ₹${(line.linePriceWithTax / 100).toLocaleString('en-IN')}\n\n`;
    });
    
    message += `💰 *Total Amount: ₹${(order.totalWithTax / 100).toLocaleString('en-IN')}*\n\n`;
    message += `📞 Please confirm this order and provide payment instructions.\n`;
    message += `Thank you for choosing ${businessName}! 🙏`;
    
    // Create WhatsApp URL
    const encodedMessage = encodeURIComponent(message);
    const cleanPhoneNumber = whatsappNumber.replace(/[^\d+]/g, '');
    const whatsappUrl = `https://wa.me/${cleanPhoneNumber}?text=${encodedMessage}`;
    
    return whatsappUrl;
}

// Example HTML for storefront payment form
const whatsappPaymentHTML = `
<div class="whatsapp-payment-container" style="padding: 20px; border: 1px solid #25D366; border-radius: 8px; background-color: #f0fff4;">
    <div style="text-align: center; margin-bottom: 20px;">
        <h3 style="color: #25D366; margin: 0 0 10px 0;">💬 WhatsApp Payment</h3>
        <p style="color: #666; margin: 0;">
            Click the button below to send your order details via WhatsApp for payment confirmation
        </p>
    </div>
    
    <div style="margin-bottom: 20px; padding: 15px; background-color: white; border-radius: 5px;">
        <h4 style="margin: 0 0 10px 0; color: #333;">Order Summary:</h4>
        <p style="margin: 5px 0; font-size: 14px;">Order ID: <strong id="order-id"></strong></p>
        <p style="margin: 5px 0; font-size: 14px;">Total: <strong id="order-total"></strong></p>
        <p style="margin: 5px 0; font-size: 14px;">Items: <strong id="order-items"></strong></p>
    </div>
    
    <div style="text-align: center;">
        <button 
            id="whatsapp-payment-btn"
            style="
                background-color: #25D366;
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 25px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                margin: 0 auto;
                min-width: 200px;
            "
        >
            📱 Send to WhatsApp
        </button>
    </div>
    
    <div style="margin-top: 15px; font-size: 12px; color: #666; text-align: center;">
        <p style="margin: 5px 0;">✅ Your order will be confirmed after we receive your WhatsApp message</p>
        <p style="margin: 5px 0;">💳 Payment instructions will be provided via WhatsApp</p>
        <p style="margin: 5px 0;">📞 For urgent queries, call us directly</p>
    </div>
</div>
`;

// Example JavaScript to handle the payment
function handleWhatsAppPayment(order) {
    // Update order display
    document.getElementById('order-id').textContent = order.code;
    document.getElementById('order-total').textContent = `₹${(order.totalWithTax / 100).toLocaleString('en-IN')}`;
    document.getElementById('order-items').textContent = `${order.lines.length} item(s)`;
    
    // Add click handler
    document.getElementById('whatsapp-payment-btn').addEventListener('click', function() {
        const whatsappUrl = initWhatsAppPayment(order);
        
        // Open WhatsApp
        window.open(whatsappUrl, '_blank');
        
        // Update button state
        this.innerHTML = '✅ Message Sent to WhatsApp';
        this.disabled = true;
        this.style.backgroundColor = '#128C7E';
        
        // You can also trigger payment completion in your checkout flow here
        // For example, redirect to a confirmation page or update order status
    });
}

/**
 * ADMIN WORKFLOW:
 * 
 * 1. Customer places order and chooses WhatsApp payment
 * 2. Order details are sent to your WhatsApp number
 * 3. You confirm order details with customer via WhatsApp
 * 4. Provide payment instructions (bank transfer, UPI, etc.)
 * 5. Once payment is received, go to Vendure Admin
 * 6. Find the order and manually settle the payment
 * 7. Update order status to "Shipped" when ready
 * 
 * CUSTOMIZATION OPTIONS:
 * 
 * - Change WhatsApp number in setup script
 * - Modify message template in the handler
 * - Add business hours validation
 * - Integration with UPI payment links
 * - Auto-settlement via webhook (advanced)
 */

export { initWhatsAppPayment, handleWhatsAppPayment, whatsappPaymentHTML };
