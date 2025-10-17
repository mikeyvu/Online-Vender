<jsp:include page="partials/menu.jsp" />

	<!-- Main Section Starts -->
		<div class="main-section">
			<div class="wrapper">
				<h1>Manage Orders</h1>
				<div class="connection-status" id="connection-status">
					<span class="status-indicator" id="status-indicator"></span>
					<span id="status-text">Connecting...</span>
				</div>
				
				<div id="orders-container">
					<!-- Orders will be loaded dynamically -->
				</div>
			</div>
		</div>
		<!-- Main Section Ends -->

	<style>
		.connection-status {
			display: flex;
			align-items: center;
			gap: 0.5rem;
			margin-bottom: 1rem;
			padding: 0.5rem 1rem;
			border-radius: 5px;
			background: #f8f9fa;
		}
		
		.status-indicator {
			width: 10px;
			height: 10px;
			border-radius: 50%;
			background: #ffc107;
		}
		
		.status-indicator.connected {
			background: #28a745;
		}
		
		.status-indicator.disconnected {
			background: #dc3545;
		}
		
		.order-card {
			background: white;
			border: 1px solid #ddd;
			border-radius: 10px;
			padding: 1.5rem;
			margin-bottom: 1rem;
			box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		}
		
		.order-header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 1rem;
			padding-bottom: 0.5rem;
			border-bottom: 1px solid #eee;
		}
		
		.order-id {
			font-weight: bold;
			color: #333;
		}
		
		.order-time {
			color: #666;
			font-size: 0.9rem;
		}
		
		.order-status {
			padding: 0.25rem 0.75rem;
			border-radius: 15px;
			font-size: 0.8rem;
			font-weight: bold;
			text-transform: uppercase;
		}
		
		.order-status.not-paid {
			background: #fff3cd;
			color: #856404;
		}
		
		.order-status.pending {
			background: #fff3cd;
			color: #856404;
		}
		
		.order-status.processing {
			background: #d1ecf1;
			color: #0c5460;
		}
		
		.order-status.finished {
			background: #d4edda;
			color: #155724;
		}
		
		.order-status.cancelled {
			background: #f8d7da;
			color: #721c24;
		}
		
		.order-status.completed {
			background: #d4edda;
			color: #155724;
		}
		
		.order-details {
			margin-bottom: 1rem;
		}
		
		.order-details h4 {
			margin-bottom: 0.5rem;
			color: #333;
		}
		
		.order-items {
			margin-top: 1rem;
		}
		
		.order-items h5 {
			margin-bottom: 0.5rem;
			color: #333;
			font-size: 0.9rem;
		}
		
		.order-items ul {
			list-style: none;
			padding: 0;
			margin: 0;
		}
		
		.order-items ul li {
			padding: 0.25rem 0;
			border-bottom: 1px solid #f0f0f0;
			color: #666;
			font-size: 0.85rem;
		}
		
		.order-items ul li:last-child {
			border-bottom: none;
		}
		
		.order-total {
			font-weight: bold;
			color: #ff6b35;
			font-size: 1.1rem;
		}
		
		.order-actions {
			display: flex;
			gap: 0.5rem;
			flex-wrap: wrap;
		}
		
		.btn-action {
			padding: 0.5rem 1rem;
			border: none;
			border-radius: 5px;
			cursor: pointer;
			font-size: 0.9rem;
			transition: background 0.3s;
		}
		
		.btn-confirm {
			background: #28a745;
			color: white;
		}
		
		.btn-confirm:hover {
			background: #218838;
		}
		
		.btn-cancel {
			background: #dc3545;
			color: white;
		}
		
		.btn-cancel:hover {
			background: #c82333;
		}
		
		.btn-finish {
			background: #17a2b8;
			color: white;
		}
		
		.btn-finish:hover {
			background: #138496;
		}
		
		#orders-container {
			min-height: 100px;
			width: 100%;
			display: block;
			visibility: visible;
			position: relative;
			z-index: 1;
			background-color: #f9f9f9;
		}
		
		.empty-orders {
			text-align: center;
			padding: 3rem;
			color: #666;
		}
		
		.empty-orders i {
			font-size: 3rem;
			color: #ccc;
			margin-bottom: 1rem;
		}
	</style>

	<script>
		let orders = [];
		let eventSource = null;
		
		// Initialize SSE connection
		function initSSE() {
			const statusIndicator = document.getElementById('status-indicator');
			const statusText = document.getElementById('status-text');
			
			statusIndicator.className = 'status-indicator';
			statusText.textContent = 'Connecting...';
			
			const sseUrl = '<%=request.getContextPath()%>/restaurant/order/order-notification';
			console.log('Connecting to SSE URL:', sseUrl);
			
			eventSource = new EventSource(sseUrl);
			
			eventSource.onopen = function() {
				console.log('SSE connection opened successfully');
				statusIndicator.className = 'status-indicator connected';
				statusText.textContent = 'Connected';
			};
			
			eventSource.onmessage = function(event) {
				try {
					const data = JSON.parse(event.data);
					handleSSEMessage(data);
				} catch (e) {
					console.error('Error parsing SSE message:', e);
					console.error('Raw event data:', event.data);
				}
			};
			
			eventSource.onerror = function(event) {
				console.error('SSE connection error:', event);
				console.log('EventSource readyState:', eventSource.readyState);
				statusIndicator.className = 'status-indicator disconnected';
				statusText.textContent = 'Disconnected';
				
				// Attempt to reconnect after 5 seconds
				setTimeout(() => {
					if (eventSource.readyState === EventSource.CLOSED) {
						console.log('Attempting to reconnect...');
						initSSE();
					}
				}, 5000);
			};
		}
		
		// Handle SSE messages
		function handleSSEMessage(data) {
			if (data.type === 'initial_orders') {
				orders = data.orders || [];
				console.log('Loaded initial orders:', orders.length);
				renderOrders();
			} else if (data.type === 'new_order') {
				console.log('New order received - Order #' + data.order.id + ' for Table ' + data.order.tableId);
				orders.unshift(data.order);
				renderOrders();
			} else if (data.type === 'order_update') {
				console.log('Order update received - Order #' + data.order.id + ' status: ' + data.order.status);
				const orderIndex = orders.findIndex(order => order.id === data.order.id);
				if (orderIndex !== -1) {
					orders[orderIndex] = data.order;
					renderOrders();
				}
			}
			// Ignore heartbeat messages
		}
		
		// Render orders
		function renderOrders() {
			const container = document.getElementById('orders-container');
			
			if (orders.length === 0) {
				container.innerHTML = 
					'<div class="empty-orders">' +
						'<i class="bi bi-inbox"></i>' +
						'<h3>No orders yet</h3>' +
						'<p>Orders will appear here in real-time</p>' +
					'</div>';
				return;
			}
			
			try {
				console.log('About to render orders. Orders array:', orders);
				const orderHTML = orders.map(order => createOrderCard(order)).join('');
				console.log('Generated HTML length:', orderHTML.length);
				console.log('First 500 characters of HTML:', orderHTML.substring(0, 500));
				
				container.innerHTML = orderHTML;
				console.log('Orders rendered successfully - ' + orders.length + ' orders displayed');
				console.log('Container innerHTML after rendering:', container.innerHTML.length + ' characters');
				
				// Force a reflow to make sure the container updates
				container.offsetHeight;
			} catch (error) {
				console.error('Error rendering orders:', error);
				console.error('Orders data:', orders);
			}
		}
		
		// Create order card HTML
		function createOrderCard(order) {
			console.log('Creating order card for order ID:', order.id);
			const statusClass = order.status.replace('_', '-');
			const orderDate = order.orderDate && order.orderDate !== 'N/A' ? 
				new Date(order.orderDate).toLocaleString() : 
				new Date().toLocaleString();
			
			console.log('Order card data - ID:', order.id, 'Table:', order.tableId, 'Status:', order.status, 'Date:', orderDate);
			
			try {
				const actionsHtml = getOrderActions(order);
				console.log('Actions HTML for order', order.id, ':', actionsHtml);
				
				const html = 
				'<div class="order-card" data-order-id="' + order.id + '">' +
					'<div class="order-header">' +
						'<div>' +
							'<div class="order-id">Order #' + order.id + '</div>' +
							'<div class="order-time">' + orderDate + '</div>' +
						'</div>' +
						'<span class="order-status ' + statusClass + '">' + order.status + '</span>' +
					'</div>' +
					'<div class="order-details">' +
						'<h4>Table: ' + (order.tableId || 'N/A') + '</h4>' +
						'<p><strong>Total:</strong> <span class="order-total">$' + order.total.toFixed(2) + '</span></p>' +
						'<div class="order-items">' +
							'<h5>Items:</h5>' +
							'<ul>' +
								(order.orderItems || []).map(item => 
									'<li>' + item.quantity + 'x ' + item.itemName + ' - $' + item.total.toFixed(2) + '</li>'
								).join('') +
							'</ul>' +
						'</div>' +
					'</div>' +
					'<div class="order-actions">' +
						actionsHtml +
					'</div>' +
				'</div>';
				
				console.log('Generated HTML for order', order.id, ':', html.substring(0, 100) + '...');
				return html;
			} catch (error) {
				console.error('Error creating order card for order', order.id, ':', error);
				return '<div class="order-card error">Error displaying order #' + order.id + '</div>';
			}
		}
		
		// Get order action buttons based on status
		function getOrderActions(order) {
			console.log('getOrderActions called for order ID:', order.id, 'status:', order.status);
			
			if (order.status === 'pending') {
				const html = 
					'<button class="btn-action btn-confirm" onclick="updateOrder(' + order.id + ', \'confirmed\')">' +
						'Confirm Order' +
					'</button>' +
					'<button class="btn-action btn-cancel" onclick="updateOrder(' + order.id + ', \'cancelled\')">' +
						'Cancel Order' +
					'</button>';
				console.log('Returning pending actions HTML:', html);
				return html;
			} else if (order.status === 'confirmed') {
				const html = 
					'<button class="btn-action btn-finish" onclick="updateOrder(' + order.id + ', \'completed\')">' +
						'Complete' +
					'</button>';
				console.log('Returning confirmed actions HTML:', html);
				return html;
			} else if (order.status === 'completed') {
				console.log('Returning completed actions HTML - no actions available');
				return '<span style="color: #28a745; font-weight: bold;"><i class="bi bi-check-circle"></i> Order Completed</span>';
			} else if (order.status === 'cancelled') {
				console.log('Returning cancelled actions HTML - no actions available');
				return '<span style="color: #dc3545; font-weight: bold;"><i class="bi bi-x-circle"></i> Order Cancelled</span>';
			} else if (order.status === 'not_paid') {
				const html = 
					'<button class="btn-action btn-confirm" onclick="updateOrder(' + order.id + ', \'confirmed\')">' +
						'Confirm Order' +
					'</button>' +
					'<button class="btn-action btn-cancel" onclick="updateOrder(' + order.id + ', \'cancelled\')">' +
						'Cancel Order' +
					'</button>';
				console.log('Returning not_paid actions HTML:', html);
				return html;
			} else {
				console.log('Returning default no actions HTML for status:', order.status);
				return '<span style="color: #666;">No actions available</span>';
			}
		}
		
		// Update order status
		function updateOrder(orderId, newStatus) {
			console.log('Updating order', orderId, 'to status:', newStatus);
			
			// Show loading state
			const orderCard = document.querySelector(`[data-order-id="${orderId}"]`);
			if (orderCard) {
				const actionsDiv = orderCard.querySelector('.order-actions');
				if (actionsDiv) {
					actionsDiv.innerHTML = '<span style="color: #666;"><i class="bi bi-hourglass-split"></i> Updating...</span>';
				}
			}
			
			const formData = new FormData();
			formData.append('action', 'update_status');
			formData.append('orderId', orderId);
			formData.append('status', newStatus);
			
			fetch('<%=request.getContextPath()%>/restaurant/order/manage-order', {
				// catch html instead of json
				method: 'POST',
				body: formData
			})
			.then(response => {
				// Log the full raw response
				console.log("Raw response: ", response);
				response.json();
			}
			)
			.then(data => {
				if (data.success) {
					console.log('Order status updated successfully:', data.message);
					
					// Update local order status immediately for better UX
					const orderIndex = orders.findIndex(order => order.id === orderId);
					if (orderIndex !== -1) {
						orders[orderIndex].status = newStatus;
						renderOrders();
					}
					
					// Show success message
					showNotification(`Order #${orderId} status updated to ${newStatus}`, 'success');
				} else {
					console.error('Failed to update order status:', data.message);
					showNotification(`Failed to update order: ${data.message}`, 'error');
					renderOrders(); // Re-render to restore original state
				}
			})
			.catch(error => {
				console.error('Error updating order:', error);
				showNotification('Error updating order status', 'error');
				renderOrders(); // Re-render to restore original state
			});
		}
		
		// Show notification to user
		function showNotification(message, type) {
			// Create notification element
			const notification = document.createElement('div');
			
			// Set base styles
			notification.style.position = 'fixed';
			notification.style.top = '20px';
			notification.style.right = '20px';
			notification.style.padding = '15px 20px';
			notification.style.borderRadius = '5px';
			notification.style.color = 'white';
			notification.style.fontWeight = 'bold';
			notification.style.zIndex = '1000';
			notification.style.opacity = '0';
			notification.style.transition = 'opacity 0.3s ease';
			
			// Set background color based on type
			if (type === 'success') {
				notification.style.background = '#28a745';
			} else {
				notification.style.background = '#dc3545';
			}
			
			notification.textContent = message;
			
			document.body.appendChild(notification);
			
			// Animate in
			setTimeout(() => {
				notification.style.opacity = '1';
			}, 100);
			
			// Remove after 3 seconds
			setTimeout(() => {
				notification.style.opacity = '0';
				setTimeout(() => {
					if (notification.parentNode) {
						notification.parentNode.removeChild(notification);
					}
				}, 300);
			}, 3000);
		}
		
		// Initialize when page loads
		document.addEventListener('DOMContentLoaded', function() {
			initSSE();
			
			// Debug: Check the orders-container styles
			setTimeout(() => {
				const container = document.getElementById('orders-container');
				const computedStyle = window.getComputedStyle(container);
				
				// Container is working fine - the issue was with HTML generation
				
				console.log('=== ORDERS CONTAINER DEBUG ===');
				console.log('Container element:', container);
				console.log('Container offsetHeight:', container.offsetHeight);
				console.log('Container offsetWidth:', container.offsetWidth);
				console.log('Container scrollHeight:', container.scrollHeight);
				console.log('Container innerHTML length:', container.innerHTML.length);
				console.log('Container display:', computedStyle.display);
				console.log('Container visibility:', computedStyle.visibility);
				console.log('Container height:', computedStyle.height);
				console.log('Container min-height:', computedStyle.minHeight);
				console.log('Container max-height:', computedStyle.maxHeight);
				console.log('Container position:', computedStyle.position);
				console.log('Container z-index:', computedStyle.zIndex);
				console.log('Container margin:', computedStyle.margin);
				console.log('Container padding:', computedStyle.padding);
				console.log('Container border:', computedStyle.border);
				console.log('Container overflow:', computedStyle.overflow);
				
				// Check for overlapping elements
				const containerRect = container.getBoundingClientRect();
				console.log('Container bounding rect:', containerRect);
				
				// Check all elements that might overlap
				const allElements = document.querySelectorAll('*');
				const overlappingElements = [];
				
				allElements.forEach(el => {
					if (el !== container && el.id !== 'orders-container') {
						const rect = el.getBoundingClientRect();
						const elStyle = window.getComputedStyle(el);
						
						// Check if element overlaps with orders-container
						if (rect.top < containerRect.bottom && rect.bottom > containerRect.top &&
							rect.left < containerRect.right && rect.right > containerRect.left) {
							
							// Check if it has higher z-index or is positioned
							if (parseInt(elStyle.zIndex) > 1 || 
								(elStyle.position !== 'static' && elStyle.position !== 'relative')) {
								overlappingElements.push({
									element: el,
									tagName: el.tagName,
									id: el.id,
									className: el.className,
									zIndex: elStyle.zIndex,
									position: elStyle.position,
									rect: rect
								});
							}
						}
					}
				});
				
				console.log('Overlapping elements:', overlappingElements);
				console.log('==============================');
			}, 3000);
		});
		
		// Clean up on page unload
		window.addEventListener('beforeunload', function() {
			if (eventSource) {
				eventSource.close();
			}
		});
	</script>

<jsp:include page="partials/footer.jsp" />