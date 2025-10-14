package restaurantServlet.admin;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.AdminDAO;
import entity.Admin;

/**
 * Servlet implementation class add_admin
 */
@WebServlet("/add_admin")
public class add_admin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public add_admin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("restaurant/admin/add-admin.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (request.getParameter("submit") != null) {
			//Button Clicked
			
	        //Get the data from form
	        String full_name = request.getParameter("full_name");
	        String username = request.getParameter("username");
	        String password = request.getParameter("password");
	        
	        // SQL Query to Save the data into database
	        Admin admin = new Admin(full_name, username, password);
	        AdminDAO adminDAO = new AdminDAO();
	        adminDAO.addAdmin(admin);
	        
	        response.sendRedirect(request.getContextPath() + "/manage_admin");
		} else {
			response.sendRedirect(request.getContextPath() + "/add-admin.jsp");
		}
	}

}
