package restaurantServlet.admin;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.AdminDAO;
import entity.Admin;

/**
 * Servlet implementation class manage_admin
 */
@WebServlet("/manage_admin")
public class manage_admin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public manage_admin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		Admin admin = (Admin) session.getAttribute("admin");
		
		if (admin == null) {
			response.sendRedirect(request.getContextPath() + "/authenticationServlet");
			return;
		}
		
		String action = request.getParameter("action") == null ? "DEFAULT_ACTION" : request.getParameter("action");
		
		request.setAttribute("message", request.getParameter("message"));
		
		String passwordChangeResult = request.getParameter("result") == null ? null : request.getParameter("result");
		if (passwordChangeResult != null) {
			String passwordChangeMessage = passwordChangeMessage(passwordChangeResult);
			request.setAttribute("message", passwordChangeMessage);
		}
		
		switch(action) {
		case "DELETE":
			deleteAdmin(request, response);
			break;
		default:
			getAllAdmin(request, response);
		}
		
	}
	
	private void getAllAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AdminDAO adminDAO = new AdminDAO();
		
		ArrayList<Admin> admins = new ArrayList<Admin>();
		admins = adminDAO.getAll();
		
		request.setAttribute("admins", admins);
		
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/admin/manage-admin.jsp");
		rd.forward(request, response);
	}
	
	private void deleteAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AdminDAO adminDAO = new AdminDAO();
		
		String IDdelete = request.getParameter("id");
		adminDAO.deleteAdmin(IDdelete);
		
		response.sendRedirect(request.getContextPath() + "/manage_admin?message=Admin Deleted Successfully");
	}
	
	private String passwordChangeMessage(String status) {
		switch(status) {
		case "WRONGCURRENT":
			return "Wrong password. Please try again.";
		case "SAMEPASSWORD":
			return "The new password cannot be the same as the old password.";
		case "WRONGCONFIRM":
			return "The password confirming was incorrect. Please try again.";
		case "PASSWORDCHANGED":
			return "Succeed. Password changed";
		}
		
		return "";
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
