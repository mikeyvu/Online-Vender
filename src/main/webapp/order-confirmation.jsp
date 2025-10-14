<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Order Confirmation - Yummy</title>
    
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
        .confirmation-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .confirmation-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .confirmation-header h1 {
            color: #28a745;
            margin-bottom: 0.5rem;
        }
        
        .confirmation-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        .success-section {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 1rem;
        }
        
        .success-message {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        
        .success-subtitle {
            color: #666;
            font-size: 1.1rem;
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
            color: #28a745;
            font-weight: 600;
        }
        
        .next-steps {
            background: #e8f4fd;
            padding: 1.5rem;
            border-radius: 10px;
            border-left: 4px solid #007bff;
            margin-bottom: 2rem;
        }
        
        .next-steps h4 {
            color: #007bff;
            margin-bottom: 1rem;
        }
        
        .next-steps ol {
            margin: 0;
            padding-left: 1.5rem;
        }
        
        .next-steps li {
            margin-bottom: 0.5rem;
            color: #333;
        }
        
        .restaurant-info {
            background: #fff5f2;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        
        .restaurant-info h3 {
            color: #ff6b35;
            margin-bottom: 1rem;
        }
        
        .restaurant-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .restaurant-details-item {
            text-align: left;
        }
        
        .restaurant-details-item strong {
            color: #333;
            display: block;
            margin-bottom: 0.25rem;
        }
        
        .restaurant-details-item span {
            color: #666;
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
            background: #28a745;
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
            background: #218838;
            color: white;
            text-decoration: none;
        }
    </style>
</head>

<body>
    <header id="header" class="header d-flex align-items-center sticky-top">
        <div class="container position-relative d-flex align-items-center justify-content-between">
            <a href="<%=request.getContextPath()%>/HomeServlet" class="logo d-flex align-items-center me-auto me-xl-0">
                <h1 class="sitename">Yummy</h1>
                <span>.</span>
            </a>
            
            <nav id="navmenu" class="navmenu">
                <ul>
                    <li><a href="<%=request.getContextPath()%>/HomeServlet">Home</a></li>
                    <li><a href="<%=request.getContextPath()%>/HomeServlet#menu">Menu</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main class="main">
        <div class="confirmation-container">
            <div class="confirmation-header">
                <h1><i class="bi bi-check-circle-fill"></i> Order Confirmed!</h1>
                <p>Thank you for your order. We're preparing your delicious meal!</p>
            </div>
            
            <div class="success-section">
                <div class="success-icon">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="success-message">
                    Order Successfully Placed
                </div>
                <div class="success-subtitle">
                    Your order has been received and is being prepared
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
                    <strong>Order Status:</strong>
                    <span>Confirmed</span>
                </div>
                <div class="order-info">
                    <strong>Estimated Time:</strong>
                    <span>15-20 minutes</span>
                </div>
            </div>
            
            <div class="restaurant-info">
                <h3><i class="bi bi-geo-alt"></i> Restaurant Information</h3>
                <div class="restaurant-details">
                    <div class="restaurant-details-item">
                        <strong>Restaurant Name:</strong>
                        <span>Yummy Restaurant</span>
                    </div>
                    <div class="restaurant-details-item">
                        <strong>Address:</strong>
                        <span>123 Food Street, City</span>
                    </div>
                    <div class="restaurant-details-item">
                        <strong>Phone:</strong>
                        <span>(02) 1234-5678</span>
                    </div>
                    <div class="restaurant-details-item">
                        <strong>Opening Hours:</strong>
                        <span>9:00 AM - 10:00 PM</span>
                    </div>
                </div>
            </div>
            
            <div class="next-steps">
                <h4><i class="bi bi-info-circle"></i> What's Next?</h4>
                <ol>
                    <li>Your order is being prepared by our chefs</li>
                    <li>You'll receive a notification when it's ready</li>
                    <li>Please wait at your table for service</li>
                    <li>Enjoy your delicious meal!</li>
                </ol>
            </div>
            
            <div class="action-buttons">
                <button class="btn-back" onclick="window.location.href='payment.jsp'">
                    <i class="bi bi-arrow-left"></i> Back to Payment
                </button>
                <a href="<%=request.getContextPath()%>/HomeServlet" class="btn-home">
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
            document.getElementById('order-ref-display').textContent = orderRef;
            document.getElementById('total-amount-display').textContent = '$' + totalAmount.toFixed(2);
            
            // Cart has already been cleared in payment.jsp after successful order
        });
    </script>
</body>
</html>
