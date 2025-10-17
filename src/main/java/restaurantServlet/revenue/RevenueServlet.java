package restaurantServlet.revenue;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.OrderDAO;
import entity.Order;

public class RevenueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get date parameter (default to today)
        String dateParam = request.getParameter("date");
        Date selectedDate;
        
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                selectedDate = new Date(sdf.parse(dateParam).getTime());
            } catch (ParseException e) {
                System.err.println("Invalid date format: " + dateParam);
                selectedDate = new Date(System.currentTimeMillis());
            }
        } else {
            selectedDate = new Date(System.currentTimeMillis());
        }

        // Calculate revenue metrics
        double dailyRevenue = orderDAO.getRevenueForDate(selectedDate);
        double monthlyRevenue = orderDAO.getMonthlyRevenue();
        int dailyCompletedOrders = orderDAO.getCompletedOrdersCountForDate(selectedDate);
        List<Order> completedOrders = orderDAO.getCompletedOrdersListForDate(selectedDate);

        // Set attributes for JSP
        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("dailyRevenue", dailyRevenue);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("dailyCompletedOrders", dailyCompletedOrders);
        request.setAttribute("completedOrders", completedOrders);

        // Forward to revenue JSP page
        request.getRequestDispatcher("/restaurant/revenue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
