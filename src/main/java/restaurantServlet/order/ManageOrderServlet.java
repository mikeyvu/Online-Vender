package restaurantServlet.order;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.OrderDAO;
import restaurantServlet.order.OrderNotificationServlet;

/**
 * Servlet implementation class manageOrderServlet
 */
public class ManageOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private OrderDAO orderDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ManageOrderServlet() {
        super();
        orderDAO = new OrderDAO();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/manage-order.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		
		if ("update_status".equals(action)) {
			updateOrderStatus(request, response);
		} else {
			// Default to GET behavior for unknown actions
			doGet(request, response);
		}
	}
	
	private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		PrintWriter out = response.getWriter();
		
		try {
			// Get parameters
			String orderIdStr = request.getParameter("orderId");
			String newStatus = request.getParameter("status");
			
			if (orderIdStr == null || newStatus == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				out.print("{\"success\": false, \"message\": \"Missing orderId or status parameter\"}");
				return;
			}
			
			int orderId = Integer.parseInt(orderIdStr);
			
			// Validate status
			if (!isValidStatus(newStatus)) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				out.print("{\"success\": false, \"message\": \"Invalid status: " + newStatus + "\"}");
				return;
			}
			
			// Update order status in database
			boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
			
			if (success) {
				System.out.println("Order " + orderId + " status updated to: " + newStatus);
				
				// Notify all connected clients about the status update
				try {
					// Create a mock order object for notification
					entity.Order order = new entity.Order();
					order.setId(orderId);
					order.setStatus(newStatus);
					
					// Send notification to all connected clients
					OrderNotificationServlet.notifyOrderUpdate(order);
				} catch (Exception e) {
					System.err.println("Failed to notify clients about order update: " + e.getMessage());
					// Don't fail the request if notification fails
				}
				
				response.setStatus(HttpServletResponse.SC_OK);
				out.print("{\"success\": true, \"message\": \"Order status updated successfully\"}");
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				out.print("{\"success\": false, \"message\": \"Failed to update order status\"}");
			}
			
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.print("{\"success\": false, \"message\": \"Invalid order ID format\"}");
		} catch (Exception e) {
			System.err.println("Error updating order status: " + e.getMessage());
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"success\": false, \"message\": \"Internal server error\"}");
		} finally {
			out.close();
		}
	}
	
	private boolean isValidStatus(String status) {
		return "pending".equals(status) || 
			   "confirmed".equals(status) || 
			   "completed".equals(status) || 
			   "cancelled".equals(status) ||
			   "not_paid".equals(status);
	}

}
