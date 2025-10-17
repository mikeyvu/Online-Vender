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
 * Servlet implementation class update_admin
 */
public class UpdateAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateAdminServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");
		
		AdminDAO adminDAO = new AdminDAO();
		Admin admin = adminDAO.getAdminByID(Integer.parseInt(id));
		
		request.setAttribute("adminUpdate", admin);
		
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/admin/update-admin.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AdminDAO adminDAO = new AdminDAO();
		
		if (request.getParameter("submit") != null) {
			String full_name = request.getParameter("full_name");
	        String username = request.getParameter("username");
	        int id = Integer.parseInt(request.getParameter("id"));
	        
	        adminDAO.updateAdmin(id, full_name, username);
	        
		response.sendRedirect(request.getContextPath() + "/restaurant/admin/manage-admin?message=Admin Updated Successfully");
		}
	}

}
