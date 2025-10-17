<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Payment - Yummy</title>
    
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
            <h1>Payment</h1>
            
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="payment-options">
                        <h3>Choose Payment Method</h3>
                        <p>Select your preferred payment method to complete your order</p>
                        <div class="payment-methods">
                            <div class="payment-option">
                                <input type="radio" id="transfer" name="paymentMethod" value="transfer">
                                <label for="transfer" class="payment-label" onclick="selectPaymentMethod('transfer')">
                                    <i class="bi bi-phone"></i>
                                    <span>Bank Transfer</span>
                                    <small>Pay via QR code</small>
                                </label>
                            </div>
                            <div class="payment-option">
                                <input type="radio" id="cash" name="paymentMethod" value="cash">
                                <label for="cash" class="payment-label" onclick="selectPaymentMethod('cash')">
                                    <i class="bi bi-cash"></i>
                                    <span>Cash Payment</span>
                                    <small>Pay at the counter</small>
                                </label>
                            </div>
                        </div>
                        <div class="payment-actions">
                            <button type="button" class="btn-back" onclick="window.location.href='order-summary.jsp'">
                                <i class="bi bi-arrow-left"></i> Back to Order Summary
                            </button>
                            <button type="button" class="btn-proceed" id="proceed-btn" onclick="proceedToPayment()" disabled>
                                Proceed <i class="bi bi-arrow-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Vendor JS Files -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
    <script src="assets/js/payment.js"></script>
    
    <script>
        let selectedPaymentMethod = null;
        
        function selectPaymentMethod(method) {
            selectedPaymentMethod = method;
            document.getElementById('proceed-btn').disabled = false;
            
            // Update visual selection
            document.querySelectorAll('.payment-label').forEach(label => {
                label.classList.remove('selected');
            });
            document.querySelector(`label[for="${method}"]`).classList.add('selected');
        }
        
        function proceedToPayment() {
            if (!selectedPaymentMethod) {
                alert('Please select a payment method');
                return;
            }
            
            // Create order and proceed
            createOrderAndProceed();
        }
        
        function createOrderAndProceed() {
            const cart = JSON.parse(localStorage.getItem('shoppingCart')) || [];
            
            // Validate cart
            if (cart.length === 0) {
                alert('Your cart is empty. Please add items before proceeding.');
                return;
            }
            
            console.log('Cart validation passed. Cart items:', cart);
            
            // Prepare order data as JSON
            const orderData = {
                paymentMethod: selectedPaymentMethod,
                items: cart.map(item => ({
                    foodName: item.name,
                    price: parseFloat(item.price.replace('$', '')),
                    quantity: item.quantity,
                    notes: item.note || ''
                }))
            };
            
            console.log('Order data to send:', orderData);
            console.log('Total items to send:', cart.length);
            
            // Submit order
            console.log('Submitting order to:', '<%=request.getContextPath()%>/client/order');
            console.log('Payment method:', selectedPaymentMethod);
            console.log('Cart items:', cart);
            
            fetch('<%=request.getContextPath()%>/client/order', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(orderData)
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);
                
                if (response.ok) {
                    console.log('Order created successfully, clearing cart and redirecting...');
                    
                    // Clear the shopping cart immediately after successful order
                    if (typeof clearShoppingCart === 'function') {
                        clearShoppingCart();
                    } else {
                        localStorage.removeItem('shoppingCart');
                        console.log('Shopping cart cleared after successful order placement');
                        
                        // Update cart count in header if it exists
                        const cartCountElement = document.querySelector('.cart-count');
                        if (cartCountElement) {
                            cartCountElement.textContent = '0';
                        }
                    }
                    
                    // Navigate based on selected payment method
                    if (selectedPaymentMethod === 'transfer') {
                        window.location.href = 'transfer-payment.jsp';
                    } else if (selectedPaymentMethod === 'cash') {
                        window.location.href = 'cash-payment.jsp';
                    } else {
                        window.location.href = 'order-confirmation.jsp';
                    }
                } else {
                    console.error('Order creation failed with status:', response.status);
                    response.text().then(text => {
                        console.error('Error response:', text);
                        alert('Failed to create order. Please try again. Status: ' + response.status);
                    });
                }
            })
            .catch(error => {
                console.error('Error creating order:', error);
                alert('Error creating order. Please try again.');
            });
        }
    </script>
</body>
</html>

