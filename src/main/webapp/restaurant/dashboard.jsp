<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="partials/menu.jsp" />

<!-- Main Section Starts -->
<div class="main-section">
    <div class="wrapper">
        <h1>DASHBOARD</h1>
        
        <!-- Dashboard Metrics Cards -->
        <div class="dashboard-metrics" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px;">
            
            <!-- Daily Revenue Card -->
            <div class="metric-card" style="background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <div style="font-size: 3em; margin-bottom: 10px;">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <h2 style="margin: 0; font-size: 2.5em;">$<fmt:formatNumber value="${dailyRevenue}" pattern="#,##0.00"/></h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Daily Revenue</p>
                <small>Today's completed orders</small>
            </div>

            <!-- Monthly Revenue Card -->
            <div class="metric-card" style="background: linear-gradient(135deg, #007bff, #6610f2); color: white; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <div style="font-size: 3em; margin-bottom: 10px;">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h2 style="margin: 0; font-size: 2.5em;">$<fmt:formatNumber value="${monthlyRevenue}" pattern="#,##0.00"/></h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Monthly Revenue</p>
                <small>This month's total</small>
            </div>

            <!-- Completed Orders Card -->
            <div class="metric-card" style="background: linear-gradient(135deg, #ffc107, #fd7e14); color: black; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <div style="font-size: 3em; margin-bottom: 10px;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2 style="margin: 0; font-size: 2.5em;">${dailyCompletedOrders}</h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Completed Orders</p>
                <small>Orders finished today</small>
            </div>

            <!-- Categories Card -->
            <div class="metric-card" style="background: linear-gradient(135deg, #6f42c1, #e83e8c); color: white; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <div style="font-size: 3em; margin-bottom: 10px;">
                    <i class="fas fa-tags"></i>
                </div>
                <h2 style="margin: 0; font-size: 2.5em;">${totalCategories}</h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Categories</p>
                <small>Active menu categories</small>
            </div>

            <!-- Food Items Card -->
            <div class="metric-card" style="background: linear-gradient(135deg, #dc3545, #fd7e14); color: white; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <div style="font-size: 3em; margin-bottom: 10px;">
                    <i class="fas fa-utensils"></i>
                </div>
                <h2 style="margin: 0; font-size: 2.5em;">${totalFoodItems}</h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Food Items</p>
                <small>Total menu items</small>
            </div>

            <!-- Average Order Value Card -->
            <div class="metric-card" style="background: linear-gradient(135deg, #20c997, #17a2b8); color: white; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <div style="font-size: 3em; margin-bottom: 10px;">
                    <i class="fas fa-calculator"></i>
                </div>
                <h2 style="margin: 0; font-size: 2.5em;">
                    <c:choose>
                        <c:when test="${dailyCompletedOrders > 0}">
                            $<fmt:formatNumber value="${dailyRevenue / dailyCompletedOrders}" pattern="#,##0.00"/>
                        </c:when>
                        <c:otherwise>
                            $0.00
                        </c:otherwise>
                    </c:choose>
                </h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Avg Order Value</p>
                <small>Today's average</small>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions" style="margin-bottom: 30px;">
            <h2>Quick Actions</h2>
            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/restaurant/revenue/" 
                   style="background: #28a745; color: white; padding: 15px 25px; text-decoration: none; border-radius: 8px; display: flex; align-items: center; gap: 8px; transition: transform 0.2s;">
                    <i class="fas fa-chart-bar"></i>
                    View Revenue Report
                </a>
                <a href="<%= request.getContextPath() %>/restaurant/order/manage-order" 
                   style="background: #007bff; color: white; padding: 15px 25px; text-decoration: none; border-radius: 8px; display: flex; align-items: center; gap: 8px; transition: transform 0.2s;">
                    <i class="fas fa-list-alt"></i>
                    Manage Orders
                </a>
                <a href="<%= request.getContextPath() %>/restaurant/food/manage-food" 
                   style="background: #6f42c1; color: white; padding: 15px 25px; text-decoration: none; border-radius: 8px; display: flex; align-items: center; gap: 8px; transition: transform 0.2s;">
                    <i class="fas fa-utensils"></i>
                    Manage Menu
                </a>
                <a href="<%= request.getContextPath() %>/restaurant/category/manage-category" 
                   style="background: #fd7e14; color: white; padding: 15px 25px; text-decoration: none; border-radius: 8px; display: flex; align-items: center; gap: 8px; transition: transform 0.2s;">
                    <i class="fas fa-tags"></i>
                    Manage Categories
                </a>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="recent-orders">
            <h2>Recent Orders</h2>
            <c:choose>
                <c:when test="${empty recentOrders}">
                    <div style="text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px; margin: 20px 0;">
                        <i class="fas fa-inbox" style="font-size: 3em; color: #6c757d; margin-bottom: 15px;"></i>
                        <h3 style="color: #6c757d;">No orders yet</h3>
                        <p style="color: #6c757d;">Orders will appear here as customers place them.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="orders-table" style="background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead style="background: #343a40; color: white;">
                                <tr>
                                    <th style="padding: 15px; text-align: left;">Order ID</th>
                                    <th style="padding: 15px; text-align: left;">Table</th>
                                    <th style="padding: 15px; text-align: left;">Status</th>
                                    <th style="padding: 15px; text-align: left;">Time</th>
                                    <th style="padding: 15px; text-align: right;">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${recentOrders}">
                                    <tr style="border-bottom: 1px solid #dee2e6;">
                                        <td style="padding: 15px; font-weight: bold;">#${order.id}</td>
                                        <td style="padding: 15px;">Table ${order.tableId}</td>
                                        <td style="padding: 15px;">
                                            <span style="padding: 4px 8px; border-radius: 4px; font-size: 0.8em; font-weight: bold; 
                                                background: ${order.status == 'completed' ? '#d4edda' : (order.status == 'pending' ? '#fff3cd' : '#f8d7da')}; 
                                                color: ${order.status == 'completed' ? '#155724' : (order.status == 'pending' ? '#856404' : '#721c24')};">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td style="padding: 15px;">
                                            <fmt:parseDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy HH:mm a"/>
                                        </td>
                                        <td style="padding: 15px; text-align: right; font-weight: bold; color: #28a745;">
                                            $<fmt:formatNumber value="${order.total}" pattern="#,##0.00"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<!-- Main Section Ends -->

<jsp:include page="partials/footer.jsp" />

<style>
/* Enhanced styling */
.metric-card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.metric-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 15px rgba(0,0,0,0.2);
}

.quick-actions a:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

.orders-table tr:hover {
    background-color: #f8f9fa;
}

.dashboard-metrics {
    margin-bottom: 40px;
}

@media (max-width: 768px) {
    .dashboard-metrics {
        grid-template-columns: 1fr;
    }
    
    .quick-actions > div {
        flex-direction: column;
    }
    
    .quick-actions a {
        justify-content: center;
    }
}

/* Auto-refresh dashboard every 30 seconds */
.dashboard-metrics::after {
    content: "";
    display: block;
    height: 0;
    overflow: hidden;
}

/* Add a subtle animation to the metrics */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.metric-card {
    animation: fadeInUp 0.6s ease-out;
}

.metric-card:nth-child(1) { animation-delay: 0.1s; }
.metric-card:nth-child(2) { animation-delay: 0.2s; }
.metric-card:nth-child(3) { animation-delay: 0.3s; }
.metric-card:nth-child(4) { animation-delay: 0.4s; }
.metric-card:nth-child(5) { animation-delay: 0.5s; }
.metric-card:nth-child(6) { animation-delay: 0.6s; }
</style>

<script>
// Auto-refresh dashboard every 30 seconds
setInterval(function() {
    location.reload();
}, 30000);
</script>
