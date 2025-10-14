document.addEventListener('DOMContentLoaded', function () {
    // Retrieve the shopping cart from localStorage
    const cart = JSON.parse(localStorage.getItem('shoppingCart')) || [];

    // Select the total cost element
    const totalCostElement = document.getElementById('total-cost');
    const orderItemsElement = document.getElementById('order-items');

    // Check if the cart is empty
    if (cart.length === 0) {
        orderItemsElement.innerHTML = '<p>Your cart is empty.</p>';
        totalCostElement.textContent = '0.00';
        return;
    }

    // Calculate total cost and generate order summary
    let totalCost = 0;
    cart.forEach((item) => {
        const itemPrice = parseFloat(item.price.replace('$', '')); // Remove dollar sign and parse price
        const itemTotalCost = itemPrice * item.quantity;
        totalCost += itemTotalCost;

        // Create order item element
        const itemElement = document.createElement('div');
        itemElement.classList.add('order-item');
        itemElement.innerHTML = `
            <p><strong>${item.name}</strong></p>
            <p>Quantity: ${item.quantity}</p>
            <p>Price per unit: ${item.price}</p>
            <p>Total: $${itemTotalCost.toFixed(2)}</p>
            <hr>
        `;
        orderItemsElement.appendChild(itemElement);
    });

    // Display the total cost
    totalCostElement.textContent = totalCost.toFixed(2);
});
