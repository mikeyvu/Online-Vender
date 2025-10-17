<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="partials/menu.jsp" />

<!-- Main Section Starts -->
<div class="main-section">
    <div class="wrapper">
        <h1>REVENUE REPORT</h1>
        
        <!-- Date Selector -->
        <div class="date-selector" style="margin: 20px 0; padding: 20px; background: #f8f9fa; border-radius: 8px;">
            <form method="GET" action="<%= request.getContextPath() %>/restaurant/revenue/" style="display: flex; align-items: center; gap: 10px;">
                <label for="date" style="font-weight: bold;">Select Date:</label>
                <input type="date" id="date" name="date" value="<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>" 
                       style="padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                <button type="submit" style="padding: 8px 16px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">
                    View Revenue
                </button>
            </form>
        </div>

        <!-- Revenue Summary Cards -->
        <div class="revenue-summary" style="display: flex; gap: 20px; margin-bottom: 30px;">
            <div class="revenue-card" style="flex: 1; background: #28a745; color: white; padding: 30px; border-radius: 8px; text-align: center;">
                <h2 style="margin: 0; font-size: 2.5em;">$<fmt:formatNumber value="${dailyRevenue}" pattern="#,##0.00"/></h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Daily Revenue</p>
                <small><fmt:formatDate value="${selectedDate}" pattern="EEEE, MMMM dd, yyyy"/></small>
            </div>
            
            <div class="revenue-card" style="flex: 1; background: #007bff; color: white; padding: 30px; border-radius: 8px; text-align: center;">
                <h2 style="margin: 0; font-size: 2.5em;">$<fmt:formatNumber value="${monthlyRevenue}" pattern="#,##0.00"/></h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Monthly Revenue</p>
                <small><fmt:formatDate value="${selectedDate}" pattern="MMMM yyyy"/></small>
            </div>
            
            <div class="revenue-card" style="flex: 1; background: #ffc107; color: black; padding: 30px; border-radius: 8px; text-align: center;">
                <h2 style="margin: 0; font-size: 2.5em;">${dailyCompletedOrders}</h2>
                <p style="margin: 10px 0 0 0; font-size: 1.2em;">Completed Orders</p>
                <small>Today</small>
            </div>
        </div>

        <!-- Completed Orders List -->
        <div class="completed-orders">
            <h2>Completed Orders for <fmt:formatDate value="${selectedDate}" pattern="MMMM dd, yyyy"/></h2>
            
            <c:choose>
                <c:when test="${empty completedOrders}">
                    <div style="text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px; margin: 20px 0;">
                        <h3 style="color: #6c757d;">No completed orders found</h3>
                        <p style="color: #6c757d;">No orders were completed on the selected date.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="orders-table" style="background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead style="background: #343a40; color: white;">
                                <tr>
                                    <th style="padding: 15px; text-align: left;">Order ID</th>
                                    <th style="padding: 15px; text-align: left;">Table</th>
                                    <th style="padding: 15px; text-align: left;">Time</th>
                                    <th style="padding: 15px; text-align: left;">Items</th>
                                    <th style="padding: 15px; text-align: right;">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${completedOrders}">
                                    <tr style="border-bottom: 1px solid #dee2e6;">
                                        <td style="padding: 15px; font-weight: bold;">#${order.id}</td>
                                        <td style="padding: 15px;">Table ${order.tableId}</td>
                                        <td style="padding: 15px;">
                                            <fmt:parseDate value="${order.orderDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="HH:mm"/>
                                        </td>
                                        <td style="padding: 15px;">
                                            <c:forEach var="item" items="${order.orderItems}" varStatus="status">
                                                ${item.quantity}x ${item.itemName}<c:if test="${!status.last}">, </c:if>
                                            </c:forEach>
                                        </td>
                                        <td style="padding: 15px; text-align: right; font-weight: bold; color: #28a745;">
                                            $<fmt:formatNumber value="${order.total}" pattern="#,##0.00"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot style="background: #f8f9fa; font-weight: bold;">
                                <tr>
                                    <td colspan="4" style="padding: 15px; text-align: right;">Total Revenue:</td>
                                    <td style="padding: 15px; text-align: right; color: #28a745; font-size: 1.2em;">
                                        $<fmt:formatNumber value="${dailyRevenue}" pattern="#,##0.00"/>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Revenue Trends (Optional - for future enhancement) -->
        <div class="revenue-trends" style="margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 8px;">
            <h3>Quick Stats</h3>
            <div style="display: flex; gap: 20px; margin-top: 15px;">
                <div style="flex: 1; text-align: center;">
                    <strong>Average Order Value:</strong><br>
                    <c:choose>
                        <c:when test="${dailyCompletedOrders > 0}">
                            $<fmt:formatNumber value="${dailyRevenue / dailyCompletedOrders}" pattern="#,##0.00"/>
                        </c:when>
                        <c:otherwise>
                            $0.00
                        </c:otherwise>
                    </c:choose>
                </div>
                <div style="flex: 1; text-align: center;">
                    <strong>Orders per Hour:</strong><br>
                    <c:choose>
                        <c:when test="${dailyCompletedOrders > 0}">
                            <fmt:formatNumber value="${dailyCompletedOrders / 12.0}" pattern="#,##0.1"/>
                        </c:when>
                        <c:otherwise>
                            0.0
                        </c:otherwise>
                    </c:choose>
                </div>
                <div style="flex: 1; text-align: center;">
                    <strong>Revenue per Hour:</strong><br>
                    $<fmt:formatNumber value="${dailyRevenue / 12.0}" pattern="#,##0.00"/>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Main Section Ends -->

<jsp:include page="partials/footer.jsp" />

<style>
/* Additional styling for better appearance */
.revenue-summary {
    flex-wrap: wrap;
}

.revenue-card {
    min-width: 200px;
    transition: transform 0.2s ease;
}

.revenue-card:hover {
    transform: translateY(-2px);
}

.orders-table table {
    font-size: 14px;
}

.orders-table th {
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.orders-table tr:hover {
    background-color: #f8f9fa;
}

@media (max-width: 768px) {
    .revenue-summary {
        flex-direction: column;
    }
    
    .date-selector form {
        flex-direction: column;
        align-items: stretch;
    }
    
    .date-selector form > * {
        margin-bottom: 10px;
    }
}
</style>
