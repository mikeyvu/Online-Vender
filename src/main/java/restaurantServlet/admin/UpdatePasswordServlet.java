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
 * Servlet implementation class update_password
 */
public class UpdatePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdatePasswordServlet() {
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
		
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/admin/update-password.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AdminDAO adminDAO = new AdminDAO();
		String id = request.getParameter("id");
		Admin admin = adminDAO.getAdminByID(Integer.parseInt(id));
		
		if (request.getParameter("submit") != null) {
			
			String currentPassword = request.getParameter("current_password");
			
			if (!currentPassword.equals(admin.getPassword())) {
				System.out.println("current password: " + currentPassword);
				System.out.println(admin.getPassword());
				response.sendRedirect(request.getContextPath() + "/restaurant/admin/manage-admin?result=WRONGCURRENT");
				return;
			}
	        
			String newPassword = request.getParameter("new_password");
			if (newPassword.equals(currentPassword)) {
				response.sendRedirect(request.getContextPath() + "/restaurant/admin/manage-admin?result=SAMEPASSWORD");
				return;
			}
			
			String confirmPassword = request.getParameter("confirm_password");
			if (confirmPassword.equals(newPassword)) {
				response.sendRedirect(request.getContextPath() + "/restaurant/admin/manage-admin?result=PASSWORDCHANGED");
				adminDAO.updatePassword(Integer.parseInt(id), confirmPassword);
			} else {
				response.sendRedirect(request.getContextPath() + "/restaurant/admin/manage-admin?result=WRONGCONFIRM");
			}
		}
	}

}
