import React, { useState, useEffect } from 'react';

interface WhatsAppPaymentComponentProps {
    order: {
        code: string;
        totalWithTax: number;
        lines: Array<{
            productVariant: { name: string };
            quantity: number;
            unitPriceWithTax: number;
            linePriceWithTax: number;
        }>;
        customer?: {
            firstName: string;
            lastName: string;
            emailAddress: string;
        };
        shippingAddress?: {
            phoneNumber?: string;
            streetLine1: string;
            city: string;
            postalCode: string;
        };
    };
    onPaymentComplete: (paymentData: any) => void;
}

export const WhatsAppPaymentComponent: React.FC<WhatsAppPaymentComponentProps> = ({
    order,
    onPaymentComplete
}) => {
    const [isProcessing, setIsProcessing] = useState(false);
    const [whatsappUrl, setWhatsappUrl] = useState<string>('');

    useEffect(() => {
        // Generate WhatsApp URL when component mounts
        generateWhatsAppUrl();
    }, [order]);

    const generateWhatsAppUrl = () => {
        const businessName = 'YouniqueIndia';
        const whatsappNumber = '+919876543210'; // Replace with your WhatsApp number
        
        let message = `🙏 *New Order from ${businessName}*\n\n`;
        message += `📋 *Order Details:*\n`;
        message += `Order ID: ${order.code}\n`;
        message += `Date: ${new Date().toLocaleDateString('en-IN')}\n\n`;
        
        message += `👤 *Customer Details:*\n`;
        if (order.customer) {
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
        
        const encodedMessage = encodeURIComponent(message);
        const cleanPhoneNumber = whatsappNumber.replace(/[^\d+]/g, '');
        const url = `https://wa.me/${cleanPhoneNumber}?text=${encodedMessage}`;
        
        setWhatsappUrl(url);
    };

    const handleWhatsAppClick = () => {
        setIsProcessing(true);
        
        // Open WhatsApp
        window.open(whatsappUrl, '_blank');
        
        // Simulate payment processing (in real scenario, you'd wait for admin confirmation)
        setTimeout(() => {
            onPaymentComplete({
                method: 'whatsapp-payment',
                transactionId: `WA_${order.code}_${Date.now()}`,
                amount: order.totalWithTax,
                status: 'pending_confirmation',
                whatsappUrl: whatsappUrl,
                timestamp: new Date().toISOString(),
            });
            setIsProcessing(false);
        }, 2000);
    };

    return (
        <div className="whatsapp-payment-container" style={{ padding: '20px', border: '1px solid #25D366', borderRadius: '8px', backgroundColor: '#f0fff4' }}>
            <div style={{ textAlign: 'center', marginBottom: '20px' }}>
                <h3 style={{ color: '#25D366', margin: '0 0 10px 0' }}>
                    💬 WhatsApp Payment
                </h3>
                <p style={{ color: '#666', margin: '0' }}>
                    Click the button below to send your order details via WhatsApp for payment confirmation
                </p>
            </div>
            
            <div style={{ marginBottom: '20px', padding: '15px', backgroundColor: 'white', borderRadius: '5px' }}>
                <h4 style={{ margin: '0 0 10px 0', color: '#333' }}>Order Summary:</h4>
                <p style={{ margin: '5px 0', fontSize: '14px' }}>Order ID: <strong>{order.code}</strong></p>
                <p style={{ margin: '5px 0', fontSize: '14px' }}>Total: <strong>₹{(order.totalWithTax / 100).toLocaleString('en-IN')}</strong></p>
                <p style={{ margin: '5px 0', fontSize: '14px' }}>Items: <strong>{order.lines.length} item(s)</strong></p>
            </div>
            
            <div style={{ textAlign: 'center' }}>
                <button
                    onClick={handleWhatsAppClick}
                    disabled={isProcessing}
                    style={{
                        backgroundColor: '#25D366',
                        color: 'white',
                        border: 'none',
                        padding: '15px 30px',
                        borderRadius: '25px',
                        fontSize: '16px',
                        fontWeight: 'bold',
                        cursor: isProcessing ? 'not-allowed' : 'pointer',
                        opacity: isProcessing ? 0.7 : 1,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: '10px',
                        margin: '0 auto',
                        minWidth: '200px',
                    }}
                >
                    {isProcessing ? (
                        <>
                            <span>Processing...</span>
                            <div style={{ 
                                width: '16px', 
                                height: '16px', 
                                border: '2px solid white', 
                                borderTop: '2px solid transparent', 
                                borderRadius: '50%', 
                                animation: 'spin 1s linear infinite' 
                            }}></div>
                        </>
                    ) : (
                        <>
                            <span>📱 Send to WhatsApp</span>
                        </>
                    )}
                </button>
            </div>
            
            <div style={{ marginTop: '15px', fontSize: '12px', color: '#666', textAlign: 'center' }}>
                <p style={{ margin: '5px 0' }}>
                    ✅ Your order will be confirmed after we receive your WhatsApp message
                </p>
                <p style={{ margin: '5px 0' }}>
                    💳 Payment instructions will be provided via WhatsApp
                </p>
                <p style={{ margin: '5px 0' }}>
                    📞 For urgent queries, call us directly
                </p>
            </div>
            
            <style jsx>{`
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            `}</style>
        </div>
    );
};

export default WhatsAppPaymentComponent;
