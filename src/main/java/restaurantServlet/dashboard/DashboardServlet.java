package restaurantServlet.dashboard;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.CategoryDAO;
import dao.FoodDAO;
import dao.OrderDAO;
import entity.Category;
import entity.Food;
import entity.Order;

public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private CategoryDAO categoryDAO;
    private FoodDAO foodDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        categoryDAO = CategoryDAO.getInstance();
        foodDAO = FoodDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get today's date
            Date today = new Date(System.currentTimeMillis());

            // Calculate dashboard metrics
            double dailyRevenue = orderDAO.getRevenueForDate(today);
            double monthlyRevenue = orderDAO.getMonthlyRevenue();
            int dailyCompletedOrders = orderDAO.getCompletedOrdersCountForDate(today);
            int totalCategories = categoryDAO.getAllActiveCategories().size();
            int totalFoodItems = 0;
            
            // Count total food items across all categories
            List<Category> categories = categoryDAO.getAllActiveCategories();
            for (Category category : categories) {
                List<Food> foods = foodDAO.getFoodByCateID(category.getId());
                totalFoodItems += foods.size();
            }

            // Get recent orders (last 5 orders regardless of status)
            List<Order> recentOrders = orderDAO.getAllOrders();
            if (recentOrders.size() > 5) {
                recentOrders = recentOrders.subList(0, 5);
            }

            // Set attributes for JSP
            request.setAttribute("dailyRevenue", dailyRevenue);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("dailyCompletedOrders", dailyCompletedOrders);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("totalFoodItems", totalFoodItems);
            request.setAttribute("recentOrders", recentOrders);

            // Forward to dashboard JSP page
            request.getRequestDispatcher("/restaurant/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error loading dashboard data: " + e.getMessage());
            e.printStackTrace();
            // Forward to original index.jsp if there's an error
            request.getRequestDispatcher("/restaurant/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
