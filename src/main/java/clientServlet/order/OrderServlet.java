package clientServlet.order;

import java.io.IOException;
import java.io.BufferedReader;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entity.Order;
import entity.OrderItem;
import dao.OrderDAO;
import restaurantServlet.order.OrderNotificationServlet;

public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("OrderServlet: Received POST request");
        
        try {
            String jsonData;
            
            // Check if it's form data or JSON data
            if (request.getContentType() != null && request.getContentType().contains("application/x-www-form-urlencoded")) {
                // Form data submission
                jsonData = request.getParameter("orderData");
                System.out.println("OrderServlet: Received form data: " + jsonData);
            } else {
                // JSON data submission
                StringBuilder jsonBuffer = new StringBuilder();
                BufferedReader reader = request.getReader();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuffer.append(line);
                }
                jsonData = jsonBuffer.toString();
                System.out.println("OrderServlet: Received JSON data: " + jsonData);
            }
            
            // Simple JSON parsing (without external libraries)
            String paymentMethod = extractJsonValue(jsonData, "paymentMethod");
            
            System.out.println("OrderServlet: paymentMethod = " + paymentMethod);
            
            // Extract items array
            String itemsJson = extractJsonArray(jsonData, "items");
            System.out.println("OrderServlet: items JSON = " + itemsJson);
            
            if (itemsJson == null || itemsJson.trim().isEmpty()) {
                System.out.println("OrderServlet: No items in cart - items JSON is null or empty");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No items in cart");
                return;
            }
            
            // Parse items from JSON array
            List<OrderItem> orderItems = parseItemsFromJson(itemsJson);
            double totalAmount = 0;
            
            for (OrderItem item : orderItems) {
                totalAmount += item.getPrice() * item.getQuantity();
            }
            
            // Get table_id from session
            Integer tableId = (Integer) request.getSession().getAttribute("table_id");
            if (tableId == null) {
                System.out.println("OrderServlet: No table_id in session - using default table 1");
                tableId = 1; // Default table if no QR code was scanned
            }
            
            // Create order
            Order order = new Order();
            order.setTotal(totalAmount);
            order.setOrderItems(orderItems);
            order.setStatus("pending");
            order.setTableId(tableId);
            
            // Save order to database
            System.out.println("OrderServlet: Attempting to create order");
            int orderId = orderDAO.createOrder(order);
            System.out.println("OrderServlet: Order creation result: " + orderId);
            
            if (orderId > 0) {
                // Order ID and date are already set in OrderDAO.createOrder()
                
                // Notify restaurant about new order
                try {
                    OrderNotificationServlet.notifyNewOrder(order);
                } catch (Exception e) {
                    System.err.println("Failed to notify restaurant about new order: " + e.getMessage());
                    e.printStackTrace();
                }
                
                // Return JSON response with redirect URL based on payment method
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                String redirectUrl;
                if ("transfer".equals(paymentMethod)) {
                    redirectUrl = request.getContextPath() + "/client/payment/transfer-payment.jsp";
                } else if ("cash".equals(paymentMethod)) {
                    redirectUrl = request.getContextPath() + "/client/payment/cash-payment.jsp";
                } else {
                    redirectUrl = request.getContextPath() + "/client/order/order-confirmation.jsp";
                }
                
                String jsonResponse = "{\"success\": true, \"orderId\": " + orderId + ", \"redirectUrl\": \"" + redirectUrl + "\"}";
                response.getWriter().write(jsonResponse);
                System.out.println("OrderServlet: Sent JSON response: " + jsonResponse);
            } else {
                System.out.println("OrderServlet: Order creation failed - orderId: " + orderId);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(500);
                response.getWriter().write("{\"success\": false, \"error\": \"Failed to create order\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(500);
            String errorMsg = escapeJson(e.getMessage() != null ? e.getMessage() : "Unknown error");
            response.getWriter().write("{\"success\": false, \"error\": \"Error processing order: " + errorMsg + "\"}");
        }
    }
    
    // Helper method to extract JSON value (handles both string and numeric values)
    private String extractJsonValue(String json, String key) {
        try {
            // First try to match quoted string values
            String stringPattern = "\"" + key + "\"\\s*:\\s*\"([^\"]+)\"";
            java.util.regex.Pattern stringP = java.util.regex.Pattern.compile(stringPattern);
            java.util.regex.Matcher stringM = stringP.matcher(json);
            if (stringM.find()) {
                return stringM.group(1);
            }
            
            // If no quoted string found, try to match numeric values
            String numericPattern = "\"" + key + "\"\\s*:\\s*([^,}\\s]+)";
            java.util.regex.Pattern numericP = java.util.regex.Pattern.compile(numericPattern);
            java.util.regex.Matcher numericM = numericP.matcher(json);
            if (numericM.find()) {
                return numericM.group(1);
            }
        } catch (Exception e) {
            System.err.println("Error extracting JSON value for key: " + key);
        }
        return null;
    }
    
    // Helper method to extract JSON array
    private String extractJsonArray(String json, String key) {
        try {
            String pattern = "\"" + key + "\"\\s*:\\s*\\[(.*?)\\]";
            java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern, java.util.regex.Pattern.DOTALL);
            java.util.regex.Matcher m = p.matcher(json);
            if (m.find()) {
                return m.group(1);
            }
        } catch (Exception e) {
            System.err.println("Error extracting JSON array for key: " + key);
        }
        return null;
    }
    
    // Helper method to parse items from JSON array
    private List<OrderItem> parseItemsFromJson(String itemsJson) {
        List<OrderItem> items = new java.util.ArrayList<>();
        try {
            System.out.println("OrderServlet: Parsing items JSON: " + itemsJson);
            
            // Split by object boundaries - handle the comma between objects
            String[] itemStrings = itemsJson.split("\\},\\s*\\{");
            System.out.println("OrderServlet: Split into " + itemStrings.length + " item strings");
            
            for (int i = 0; i < itemStrings.length; i++) {
                String itemStr = itemStrings[i];
                System.out.println("OrderServlet: Processing item string " + i + ": " + itemStr);
                
                // Clean up braces - add them back to make valid JSON objects
                if (!itemStr.startsWith("{")) {
                    itemStr = "{" + itemStr;
                }
                if (!itemStr.endsWith("}")) {
                    itemStr = itemStr + "}";
                }
                
                System.out.println("OrderServlet: Cleaned item string: " + itemStr);
                
                String foodName = extractJsonValue(itemStr, "foodName");
                String priceStr = extractJsonValue(itemStr, "price");
                String quantityStr = extractJsonValue(itemStr, "quantity");
                String notes = extractJsonValue(itemStr, "notes");
                
                System.out.println("OrderServlet: Extracted - foodName: " + foodName + ", price: " + priceStr + ", quantity: " + quantityStr + ", notes: " + notes);
                
                if (foodName != null && priceStr != null && quantityStr != null) {
                    double price = Double.parseDouble(priceStr);
                    int quantity = Integer.parseInt(quantityStr);
                    double total = price * quantity;
                    
                    OrderItem item = new OrderItem();
                    item.setItemName(foodName);
                    item.setPrice(price);
                    item.setQuantity(quantity);
                    item.setTotal(total);
                    item.setNote(notes != null ? notes : "");
                    items.add(item);
                    System.out.println("OrderServlet: Successfully created OrderItem: " + foodName);
                } else {
                    System.out.println("OrderServlet: Failed to extract required fields for item " + i);
                }
            }
            
            System.out.println("OrderServlet: Total items parsed: " + items.size());
        } catch (Exception e) {
            System.err.println("Error parsing items from JSON: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    // Helper method to escape JSON strings
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
