<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Bank Transfer Payment - Yummy</title>
    
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Inter:wght@100;200;300;400;500;600;700;800;900&family=Amatic+SC:wght@400;700&display=swap" rel="stylesheet">
    
    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Main CSS File -->
    <link href="assets/css/main.css" rel="stylesheet">
    <link href="assets/css/payment.css" rel="stylesheet">
    
    <style>
        .transfer-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .payment-header h1 {
            color: #ff6b35;
            margin-bottom: 0.5rem;
        }
        
        .payment-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        .qr-section {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .qr-code {
            width: 200px;
            height: 200px;
            margin: 0 auto 1rem;
            border: 2px solid #eee;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
        }
        
        .qr-code img {
            max-width: 100%;
            max-height: 100%;
        }
        
        .bank-details {
            background: #fff5f2;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        
        .bank-details h3 {
            color: #ff6b35;
            margin-bottom: 1rem;
        }
        
        .bank-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .bank-info-item {
            text-align: left;
        }
        
        .bank-info-item strong {
            color: #333;
            display: block;
            margin-bottom: 0.25rem;
        }
        
        .bank-info-item span {
            color: #666;
        }
        
        .order-details {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        
        .order-details h3 {
            color: #333;
            margin-bottom: 1rem;
        }
        
        .order-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
        
        .order-info strong {
            color: #333;
        }
        
        .order-info span {
            color: #ff6b35;
            font-weight: 600;
        }
        
        .payment-instructions {
            background: #e8f4fd;
            padding: 1.5rem;
            border-radius: 10px;
            border-left: 4px solid #007bff;
            margin-bottom: 2rem;
        }
        
        .payment-instructions h4 {
            color: #007bff;
            margin-bottom: 1rem;
        }
        
        .payment-instructions ol {
            margin: 0;
            padding-left: 1.5rem;
        }
        
        .payment-instructions li {
            margin-bottom: 0.5rem;
            color: #333;
        }
        
        .important-note {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .important-note i {
            color: #856404;
            margin-right: 0.5rem;
        }
        
        .important-note strong {
            color: #856404;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-back:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
        }
        
        .btn-home {
            background: #ff6b35;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-home:hover {
            background: #e55a2b;
            color: white;
            text-decoration: none;
        }
    </style>
</head>

<body>
    <header id="header" class="header d-flex align-items-center sticky-top">
        <div class="container position-relative d-flex align-items-center justify-content-between">
            <a href="<%=request.getContextPath()%>/home" class="logo d-flex align-items-center me-auto me-xl-0">
                <h1 class="sitename">Yummy</h1>
                <span>.</span>
            </a>
            
            <nav id="navmenu" class="navmenu">
                <ul>
                    <li><a href="<%=request.getContextPath()%>/home">Home</a></li>
                    <li><a href="<%=request.getContextPath()%>/home#menu">Menu</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main class="main">
        <div class="transfer-container">
            <div class="payment-header">
                <h1><i class="bi bi-phone"></i> Bank Transfer Payment</h1>
                <p>Scan the QR code below to complete your payment</p>
            </div>
            
            <div class="qr-section">
                <h3>Scan QR Code to Pay</h3>
                <div class="qr-code">
                    <img src="assets/img/qr-codes/payment-qr.png" alt="Payment QR Code" id="qr-image">
                </div>
                <p><strong>Amount to Transfer: <span id="transfer-amount">$0.00</span></strong></p>
                <p><small>Order Reference: <span id="order-reference">ORD-000000</span></small></p>
            </div>
            
            <div class="bank-details">
                <h3><i class="bi bi-bank"></i> Bank Details</h3>
                <div class="bank-info">
                    <div class="bank-info-item">
                        <strong>Bank Name:</strong>
                        <span>Yummy Restaurant Bank</span>
                    </div>
                    <div class="bank-info-item">
                        <strong>Account Number:</strong>
                        <span>1234567890</span>
                    </div>
                    <div class="bank-info-item">
                        <strong>Account Name:</strong>
                        <span>Yummy Restaurant</span>
                    </div>
                    <div class="bank-info-item">
                        <strong>BSB:</strong>
                        <span>123-456</span>
                    </div>
                </div>
            </div>
            
            <div class="order-details">
                <h3><i class="bi bi-receipt"></i> Order Details</h3>
                <div class="order-info">
                    <strong>Order Reference:</strong>
                    <span id="order-ref-display">ORD-000000</span>
                </div>
                <div class="order-info">
                    <strong>Total Amount:</strong>
                    <span id="total-amount-display">$0.00</span>
                </div>
                <div class="order-info">
                    <strong>Payment Method:</strong>
                    <span>Bank Transfer</span>
                </div>
            </div>
            
            <div class="payment-instructions">
                <h4><i class="bi bi-info-circle"></i> How to Pay</h4>
                <ol>
                    <li>Open your banking app on your phone</li>
                    <li>Scan the QR code above or use the bank details</li>
                    <li>Enter the exact amount shown</li>
                    <li>Add the order reference in the description</li>
                    <li>Complete the transfer</li>
                </ol>
            </div>
            
            <div class="important-note">
                <i class="bi bi-exclamation-triangle"></i>
                <strong>Important:</strong> Your order will be placed once the payment is made. Please keep your payment receipt for reference.
            </div>
            
            <div class="action-buttons">
                <button class="btn-back" onclick="window.location.href='payment.jsp'">
                    <i class="bi bi-arrow-left"></i> Back to Payment
                </button>
                <a href="<%=request.getContextPath()%>/home" class="btn-home">
                    <i class="bi bi-house"></i> Back to Home
                </a>
            </div>
        </div>
    </main>

    <!-- Vendor JS Files -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
    
    <script>
        // Load order details from localStorage and clear cart
        document.addEventListener('DOMContentLoaded', function() {
            const cart = JSON.parse(localStorage.getItem('shoppingCart')) || [];
            
            // Calculate total amount
            let totalAmount = 0;
            cart.forEach(item => {
                const itemPrice = parseFloat(item.price.replace('$', ''));
                totalAmount += itemPrice * item.quantity;
            });
            
            // Generate order reference
            const orderRef = 'ORD-' + Date.now().toString().slice(-6);
            
            // Update display
            document.getElementById('transfer-amount').textContent = '$' + totalAmount.toFixed(2);
            document.getElementById('order-reference').textContent = orderRef;
            document.getElementById('order-ref-display').textContent = orderRef;
            document.getElementById('total-amount-display').textContent = '$' + totalAmount.toFixed(2);
            
            // Cart has already been cleared in payment.jsp after successful order
        });
    </script>
</body>
</html>

