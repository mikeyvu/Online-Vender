package entity;

import java.util.List;

public class Order {
    private int id;
    private double total;
    private String orderDate;
    private String status; // "pending", "confirmed", "completed", "cancelled"
    private Integer tableId;
    private List<OrderItem> orderItems;
    
    public Order() {}
    
    public Order(double total, String status, Integer tableId) {
        this.total = total;
        this.status = status;
        this.tableId = tableId;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public double getTotal() {
        return total;
    }
    
    public void setTotal(double total) {
        this.total = total;
    }
    
    public String getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getTableId() {
        return tableId;
    }
    
    public void setTableId(Integer tableId) {
        this.tableId = tableId;
    }
    
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
    
    // Legacy methods for backward compatibility with OrderNotificationServlet
    public String getCustomerName() {
        return "Table " + (tableId != null ? tableId : "N/A");
    }
    
    public double getTotalAmount() {
        return total;
    }
    
    public String getPaymentMethod() {
        return "QR Order"; // Default payment method for QR-based orders
    }
}

