package restaurantServlet.admin;

import java.io.IOException;

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
 * Servlet implementation class login
 */
@WebServlet("/authenticationServlet")
public class authenticationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public authenticationServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action") == null? "LOGIN": "LOGOUT";
		
		switch(action) {
		case "LOGOUT": 
			doLogout(request, response);
			break;
		default: 
			doLogin(request, response);
			break;
		}
	}
	
	private void doLogout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		session.removeAttribute("admin");
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/admin/login.jsp");
		rd.forward(request, response);
		return;
	}
	
	private void doLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		Admin admin = new Admin(username, password);
		AdminDAO adminDAO = new AdminDAO();
		
		admin = adminDAO.adminLogin(admin);
		
		if (admin == null) {
			RequestDispatcher rd = request.getRequestDispatcher("/restaurant/admin/login.jsp");
			rd.forward(request, response);
		} else {
			HttpSession session = request.getSession();
			session.setAttribute("admin", admin);
			RequestDispatcher rd = request.getRequestDispatcher("/restaurant/index.jsp");
			rd.forward(request, response);
		}
		return;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
