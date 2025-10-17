package restaurantServlet.order;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entity.Order;
import dao.OrderDAO;

public class OrderNotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final List<PrintWriter> clients = new ArrayList<>();
    private static final Object clientsLock = new Object();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set up Server-Sent Events
        response.setContentType("text/event-stream");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Connection", "keep-alive");
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        PrintWriter writer = response.getWriter();
        
        // Add client to the list
        synchronized (clientsLock) {
            clients.add(writer);
            System.out.println("OrderNotificationServlet: Client connected. Total clients: " + clients.size());
        }
        
        try {
            // Send initial orders to the new client
            sendOrdersToClient(writer);
            
            // Keep connection alive
            while (!Thread.currentThread().isInterrupted()) {
                writer.println("data: {\"type\":\"heartbeat\"}");
                writer.println();
                writer.flush();
                
                try {
                    Thread.sleep(30000); // Send heartbeat every 30 seconds
                } catch (InterruptedException e) {
                    break;
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error in SSE connection: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Remove client from the list
            synchronized (clientsLock) {
                clients.remove(writer);
                System.out.println("OrderNotificationServlet: Client disconnected. Total clients: " + clients.size());
            }
        }
    }
    
    public static void notifyNewOrder(Order order) {
        System.out.println("OrderNotificationServlet: notifyNewOrder called for order ID: " + order.getId());
        String jsonData = buildOrderJson(order);
        String message = "data: " + jsonData + "\n\n";
        
        System.out.println("OrderNotificationServlet: JSON data: " + jsonData);
        
        synchronized (clientsLock) {
            System.out.println("OrderNotificationServlet: Number of connected clients: " + clients.size());
            List<PrintWriter> toRemove = new ArrayList<>();
            for (PrintWriter client : clients) {
                try {
                    client.println(message);
                    client.flush();
                    System.out.println("OrderNotificationServlet: Message sent to client");
                } catch (Exception e) {
                    System.out.println("OrderNotificationServlet: Error sending to client: " + e.getMessage());
                    toRemove.add(client);
                }
            }
            if (!toRemove.isEmpty()) {
                clients.removeAll(toRemove);
                System.out.println("OrderNotificationServlet: Removed " + toRemove.size() + " dead connections. Total clients: " + clients.size());
            }
        }
    }
    
    public static void notifyOrderUpdate(Order order) {
        String jsonData = buildOrderJson(order);
        String message = "data: " + jsonData + "\n\n";
        
        synchronized (clientsLock) {
            List<PrintWriter> toRemove = new ArrayList<>();
            for (PrintWriter client : clients) {
                try {
                    client.println(message);
                    client.flush();
                } catch (Exception e) {
                    toRemove.add(client);
                }
            }
            clients.removeAll(toRemove);
        }
    }
    
    private static void sendOrdersToClient(PrintWriter writer) {
        try {
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = orderDAO.getAllOrders();
            
            String jsonData = buildOrdersJson(orders);
            String message = "data: " + jsonData + "\n\n";
            
            writer.println(message);
            writer.flush();
            
        } catch (Exception e) {
            System.err.println("Error sending initial orders: " + e.getMessage());
        }
    }
    
    private static String buildOrderJson(Order order) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"type\":\"new_order\",");
        json.append("\"order\":{");
        json.append("\"id\":").append(order.getId()).append(",");
        json.append("\"tableId\":").append(order.getTableId() != null ? order.getTableId() : 0).append(",");
        json.append("\"total\":").append(order.getTotal()).append(",");
        json.append("\"status\":\"").append(escapeJson(order.getStatus())).append("\",");
        json.append("\"orderDate\":\"").append(escapeJson(order.getOrderDate() != null ? order.getOrderDate() : "N/A")).append("\",");
        json.append("\"customerName\":\"").append(escapeJson(order.getCustomerName())).append("\",");
        json.append("\"paymentMethod\":\"").append(escapeJson(order.getPaymentMethod())).append("\"");
        
        // Add order items if available
        if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
            json.append(",\"orderItems\":[");
            for (int i = 0; i < order.getOrderItems().size(); i++) {
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"itemName\":\"").append(escapeJson(order.getOrderItems().get(i).getItemName())).append("\",");
                json.append("\"quantity\":").append(order.getOrderItems().get(i).getQuantity()).append(",");
                json.append("\"price\":").append(order.getOrderItems().get(i).getPrice()).append(",");
                json.append("\"total\":").append(order.getOrderItems().get(i).getTotal());
                json.append("}");
            }
            json.append("]");
        }
        
        json.append("}");
        json.append("}");
        return json.toString();
    }
    
    private static String buildOrdersJson(List<Order> orders) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"type\":\"initial_orders\",");
        json.append("\"orders\":[");
        
        for (int i = 0; i < orders.size(); i++) {
            Order order = orders.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"id\":").append(order.getId()).append(",");
            json.append("\"tableId\":").append(order.getTableId() != null ? order.getTableId() : 0).append(",");
            json.append("\"total\":").append(order.getTotal()).append(",");
            json.append("\"status\":\"").append(escapeJson(order.getStatus())).append("\",");
            json.append("\"orderDate\":\"").append(escapeJson(order.getOrderDate() != null ? order.getOrderDate() : "N/A")).append("\",");
            json.append("\"customerName\":\"").append(escapeJson(order.getCustomerName())).append("\",");
            json.append("\"paymentMethod\":\"").append(escapeJson(order.getPaymentMethod())).append("\"");
            
            // Add order items if available
            if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
                json.append(",\"orderItems\":[");
                for (int j = 0; j < order.getOrderItems().size(); j++) {
                    if (j > 0) json.append(",");
                    json.append("{");
                    json.append("\"itemName\":\"").append(escapeJson(order.getOrderItems().get(j).getItemName())).append("\",");
                    json.append("\"quantity\":").append(order.getOrderItems().get(j).getQuantity()).append(",");
                    json.append("\"price\":").append(order.getOrderItems().get(j).getPrice()).append(",");
                    json.append("\"total\":").append(order.getOrderItems().get(j).getTotal());
                    json.append("}");
                }
                json.append("]");
            }
            
            json.append("}");
        }
        
        json.append("]");
        json.append("}");
        return json.toString();
    }
    
    private static String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}

