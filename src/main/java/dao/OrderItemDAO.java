package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utility.DBUtils;
import entity.OrderItem;

public class OrderItemDAO {
    
    public boolean createOrderItems(List<OrderItem> orderItems, int orderId, Connection conn) {
        PreparedStatement stmt = null;
        
        try {
            String sql = "INSERT INTO order_items (item_name, price, quantity, total, note, order_id) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            
            for (OrderItem item : orderItems) {
                stmt.setString(1, item.getItemName());
                stmt.setDouble(2, item.getPrice());
                stmt.setInt(3, item.getQuantity());
                stmt.setDouble(4, item.getTotal());
                stmt.setString(5, item.getNote());
                stmt.setInt(6, orderId);
                
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            
            // Check if all inserts were successful
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error creating order items: " + e.getMessage());
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
    
    // Overloaded method for backward compatibility
    public boolean createOrderItems(List<OrderItem> orderItems, int orderId) {
        Connection conn = null;
        try {
            conn = DBUtils.makeConnection();
            return createOrderItems(orderItems, orderId, conn);
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.makeConnection();
            String sql = "SELECT * FROM order_items WHERE order_id = ? ORDER BY id";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setItemName(rs.getString("item_name"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setTotal(rs.getDouble("total"));
                item.setNote(rs.getString("note"));
                item.setOrderId(rs.getInt("order_id"));
                
                orderItems.add(item);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving order items: " + e.getMessage());
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
        
        return orderItems;
    }
    
    public double calculateOrderTotal(int orderId, Connection conn) {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT SUM(total) as order_total FROM order_items WHERE order_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("order_total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating order total: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return 0.0;
    }
    
    // Overloaded method for backward compatibility
    public double calculateOrderTotal(int orderId) {
        Connection conn = null;
        try {
            conn = DBUtils.makeConnection();
            return calculateOrderTotal(orderId, conn);
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
