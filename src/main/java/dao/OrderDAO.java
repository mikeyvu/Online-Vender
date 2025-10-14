package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import utility.DBUtils;
import entity.Order;
import entity.OrderItem;

public class OrderDAO {
    
    private OrderItemDAO orderItemDAO;
    
    public OrderDAO() {
        this.orderItemDAO = new OrderItemDAO();
    }
    
    public int createOrder(Order order) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.makeConnection();
            conn.setAutoCommit(false); // Start transaction
            System.out.println("Database connection established for order creation");
            
            // Phase 1: Create order with total = 0
            String sql = "INSERT INTO `order` (total, order_date, status, table_id) VALUES (0, NOW(), ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setString(1, order.getStatus());
            stmt.setInt(2, order.getTableId());
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Status: " + order.getStatus());
            System.out.println("Table ID: " + order.getTableId());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    System.out.println("Order created with ID: " + orderId);
                    
                    // Set the order ID and date for the order object
                    order.setId(orderId);
                    order.setOrderDate(new java.sql.Timestamp(System.currentTimeMillis()).toString());
                    
                    // Phase 2: Insert order items
                    if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
                        // Calculate individual item totals
                        for (OrderItem item : order.getOrderItems()) {
                            item.setTotal(item.getPrice() * item.getQuantity());
                            item.setOrderId(orderId);
                        }
                        
                        boolean itemsCreated = orderItemDAO.createOrderItems(order.getOrderItems(), orderId, conn);
                        if (!itemsCreated) {
                            throw new SQLException("Failed to create order items");
                        }
                        
                        // Phase 3: Update order with calculated total
                        double calculatedTotal = orderItemDAO.calculateOrderTotal(orderId, conn);
                        boolean totalUpdated = updateOrderTotal(orderId, calculatedTotal, conn);
                        if (!totalUpdated) {
                            throw new SQLException("Failed to update order total");
                        }
                        
                        System.out.println("Order total updated to: " + calculatedTotal);
                    }
                    
                    conn.commit(); // Commit transaction
                    return orderId;
                }
            }
            
            conn.rollback(); // Rollback if no order ID generated
            return -1;
            
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback on error
                }
            } catch (SQLException rollbackEx) {
                System.err.println("Error during rollback: " + rollbackEx.getMessage());
            }
            System.err.println("Error creating order: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private boolean updateOrderTotal(int orderId, double total, Connection conn) {
        PreparedStatement stmt = null;
        
        try {
            String sql = "UPDATE `order` SET total = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDouble(1, total);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating order total: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.makeConnection();
            String sql = "SELECT * FROM `order` ORDER BY order_date DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setTotal(rs.getDouble("total"));
                order.setStatus(rs.getString("status"));
                order.setOrderDate(rs.getString("order_date"));
                order.setTableId(rs.getInt("table_id"));
                
                // Get order items for this order
                List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(order.getId());
                order.setOrderItems(orderItems);
                
                orders.add(order);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving orders: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return orders;
    }
    
    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBUtils.makeConnection();
            String sql = "UPDATE `order` SET status = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("OrderDao: Error updating order status: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Revenue calculation methods
    public double getDailyRevenue() {
        return getRevenueForDate(new java.sql.Date(System.currentTimeMillis()));
    }

    public double getRevenueForDate(java.sql.Date date) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.makeConnection();
            String sql = "SELECT SUM(total) as daily_revenue FROM `order` WHERE status = 'completed' AND DATE(order_date) = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, date);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("daily_revenue");
            }

        } catch (SQLException e) {
            System.err.println("Error calculating daily revenue: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return 0.0;
    }

    public double getMonthlyRevenue() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.makeConnection();
            String sql = "SELECT SUM(total) as monthly_revenue FROM `order` WHERE status = 'completed' AND MONTH(order_date) = MONTH(CURDATE()) AND YEAR(order_date) = YEAR(CURDATE())";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("monthly_revenue");
            }

        } catch (SQLException e) {
            System.err.println("Error calculating monthly revenue: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return 0.0;
    }

    public int getDailyCompletedOrders() {
        return getCompletedOrdersCountForDate(new java.sql.Date(System.currentTimeMillis()));
    }

    public int getCompletedOrdersCountForDate(java.sql.Date date) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.makeConnection();
            String sql = "SELECT COUNT(*) as completed_orders FROM `order` WHERE status = 'completed' AND DATE(order_date) = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, date);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("completed_orders");
            }

        } catch (SQLException e) {
            System.err.println("Error counting completed orders: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return 0;
    }

    public List<Order> getCompletedOrdersListForDate(java.sql.Date date) {
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.makeConnection();
            String sql = "SELECT * FROM `order` WHERE status = 'completed' AND DATE(order_date) = ? ORDER BY order_date DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, date);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setTotal(rs.getDouble("total"));
                order.setStatus(rs.getString("status"));
                order.setOrderDate(rs.getString("order_date"));
                order.setTableId(rs.getInt("table_id"));

                // Get order items for this order
                List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(order.getId());
                order.setOrderItems(orderItems);

                orders.add(order);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving completed orders for date: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return orders;
    }
}
