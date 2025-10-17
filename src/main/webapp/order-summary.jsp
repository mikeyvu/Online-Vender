<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Order Summary - Yummy</title>
    
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
    <link href="assets/css/cart.css" rel="stylesheet">
    
    <style>
        .order-summary-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .order-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .order-items-container {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 1rem;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.25rem;
        }
        
        .item-ingredients {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .item-notes {
            color: #ff6b35;
            font-size: 0.85rem;
            font-style: italic;
        }
        
        .item-quantity {
            background: #f8f9fa;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.9rem;
            color: #666;
            margin-right: 1rem;
        }
        
        .item-price {
            font-weight: 600;
            color: #ff6b35;
            font-size: 1.1rem;
        }
        
        .order-total {
            background: #fff5f2;
            padding: 1.5rem;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .total-amount {
            font-size: 2rem;
            font-weight: bold;
            color: #ff6b35;
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
        
        .btn-payment {
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
        
        .btn-payment:hover {
            background: #e55a2b;
            color: white;
            text-decoration: none;
        }
        
        .empty-cart {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .empty-cart i {
            font-size: 4rem;
            color: #ccc;
            margin-bottom: 1rem;
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
        <div class="order-summary-container">
            <div class="order-header">
                <h1><i class="bi bi-receipt"></i> Order Summary</h1>
                <p>Please review your order before proceeding to payment</p>
            </div>
            
            <div id="order-items" class="order-items-container">
                <!-- Order items will be populated by JavaScript -->
            </div>
            
            <div class="order-total">
                <h3>Total Amount</h3>
                <div class="total-amount" id="total-cost">$0.00</div>
            </div>
            
            <div class="action-buttons">
                <a href="shopping_cart.jsp" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Back to Cart
                </a>
                <a href="payment.jsp" class="btn-payment" id="proceed-payment-btn">
                    Proceed to Payment <i class="bi bi-arrow-right"></i>
                </a>
            </div>
        </div>
    </main>

    <!-- Vendor JS Files -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
    
    <script>
        // Order summary functionality
        document.addEventListener('DOMContentLoaded', function() {
            const cart = JSON.parse(localStorage.getItem('shoppingCart')) || [];
            const orderItemsElement = document.getElementById('order-items');
            const totalCostElement = document.getElementById('total-cost');
            const proceedBtn = document.getElementById('proceed-payment-btn');
            
            if (cart.length === 0) {
                orderItemsElement.innerHTML = 
                    '<div class="empty-cart">' +
                        '<i class="bi bi-cart-x"></i>' +
                        '<h3>Your cart is empty</h3>' +
                        '<p>Add some delicious items to get started!</p>' +
                    '</div>';
                totalCostElement.textContent = '$0.00';
                proceedBtn.style.display = 'none';
                return;
            }
            
            let totalCost = 0;
            
            cart.forEach((item) => {
                const itemPrice = parseFloat(item.price.replace('$', ''));
                const itemTotalCost = itemPrice * item.quantity;
                totalCost += itemTotalCost;
                
                const itemElement = document.createElement('div');
                itemElement.classList.add('order-item');
                
                // Create notes display if notes exist
                const notesDisplay = item.note ? '<div class="item-notes">Note: ' + item.note + '</div>' : '';
                
                itemElement.innerHTML = 
                    '<img src="assets/img/food/' + (item.imageName || 'menu-item-1.png') + '" alt="' + item.name + '" class="item-image">' +
                    '<div class="item-details">' +
                        '<div class="item-name">' + item.name + '</div>' +
                        '<div class="item-ingredients">' + (item.ingredients || '') + '</div>' +
                        notesDisplay +
                    '</div>' +
                    '<div class="item-quantity">Qty: ' + item.quantity + '</div>' +
                    '<div class="item-price">$' + itemTotalCost.toFixed(2) + '</div>';
                
                orderItemsElement.appendChild(itemElement);
            });
            
            // Display the total cost
            totalCostElement.textContent = '$' + totalCost.toFixed(2);
        });
    </script>
</body>
</html>

