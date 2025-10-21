<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Shopping Cart - Yummy</title>
    
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Favicons -->
    <link href="../../assets/img/favicon.png" rel="icon">
    <link href="../../assets/img/apple-touch-icon.png" rel="apple-touch-icon">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Inter:wght@100;200;300;400;500;600;700;800;900&family=Amatic+SC:wght@400;700&display=swap" rel="stylesheet">
    
    <!-- Vendor CSS Files -->
    <link href="../../assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Main CSS File -->
    <link href="../../assets/css/main.css" rel="stylesheet">
    <link href="../../assets/css/cart.css" rel="stylesheet">
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
        <div class="container">
            <div class="cart-header">
                <h1>Shopping Cart</h1>
            </div>
            
            <div id="cart-items" class="cart-items-container">
                <!-- Cart items will be populated by JavaScript -->
            </div>
            
            <div class="cart-summary">
                    <span id="item-count">0 items</span> </br>
                    <span id="total-cost">Total: $0.00</span>
            </div>
            
            <div class="cart-actions">
                <button id="add-items-button" onclick="window.location.href='<%=request.getContextPath()%>/home'">
                    <i class="bi bi-arrow-left"></i> Add More Items
                </button>
                <button id="order-button" onclick="window.location.href='<%=request.getContextPath()%>/client/order/order-summary.jsp'">
                    Place Order <i class="bi bi-arrow-right"></i>
                </button>
            </div>
        </div>
    </main>

    <!-- Vendor JS Files -->
    <script src="../../assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../../assets/js/main.js"></script>
    <script src="../../assets/js/payment.js"></script>
    
    <script>
        // Shopping cart functionality
        document.addEventListener('DOMContentLoaded', function() {
            const cart = JSON.parse(localStorage.getItem('shoppingCart')) || [];
            const cartItemsElement = document.getElementById('cart-items');
            const totalCostElement = document.getElementById('total-cost');
            const itemCountElement = document.getElementById('item-count');
            
            if (cart.length === 0) {
                cartItemsElement.innerHTML = 
                    '<div class="empty-cart">' +
                        '<i class="bi bi-cart-x" style="font-size: 48px; color: #ccc; margin-bottom: 20px;"></i>' +
                        '<h3>Your cart is empty</h3>' +
                        '<p>Add some delicious items to get started!</p>' +
                    '</div>';
                totalCostElement.textContent = 'Total: $0.00';
                itemCountElement.textContent = '0 items';
                return;
            }
            
            let totalCost = 0;
            let totalItems = 0;
            
            cart.forEach((item, index) => {
                const itemPrice = parseFloat(item.price.replace('$', ''));
                const itemTotalCost = itemPrice * item.quantity;
                totalCost += itemTotalCost;
                totalItems += item.quantity;
                
                const itemElement = document.createElement('div');
                itemElement.classList.add('cart-item');
                
                // Create notes display if notes exist
                const notesDisplay = item.note ? '<div class="item-notes"><strong>Notes:</strong> ' + item.note + '</div>' : '';
                
                itemElement.innerHTML = 
                    '<div class="cart-item-content">' +
                        '<img src="../../assets/img/food/' + (item.imageName || 'menu-item-1.png') + '" alt="' + item.name + '" class="cart-item-image">' +
                        '<div class="cart-item-details">' +
                            '<p class="item-description">' + (item.ingredients || '') + '</p>' +
                            '<div class="item-info">' +
                                '<span class="item-quantity">Qty: ' + item.quantity + '</span><br>' +
                                '<span class="item-price">' + item.price + ' each</span><br>' +
                                '<span class="item-total">Total: $' + itemTotalCost.toFixed(2) + '</span>' +
                            '</div>' +
                            notesDisplay +
                        '</div>' +
                        '<div class="cart-item-actions">' +
                            '<button onclick="removeFromCart(' + index + ')" class="remove-btn">' +
                                '<i class="bi bi-trash"></i> Remove' +
                            '</button>' +
                        '</div>' +
                    '</div>';
                cartItemsElement.appendChild(itemElement);
            });
            
            totalCostElement.textContent = 'Total: $' + totalCost.toFixed(2);
            itemCountElement.textContent = totalItems + ' item' + (totalItems != 1 ? 's' : '');
        });
        
        function removeFromCart(index) {
            const cart = JSON.parse(localStorage.getItem('shoppingCart')) || [];
            cart.splice(index, 1);
            localStorage.setItem('shoppingCart', JSON.stringify(cart));
            location.reload();
        }
    </script>
</body>
</html>

