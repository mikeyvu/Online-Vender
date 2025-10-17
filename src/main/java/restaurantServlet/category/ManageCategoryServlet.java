package restaurantServlet.category;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.AdminDAO;
import dao.CategoryDAO;
import entity.Admin;
import entity.Category;

/**
 * Servlet implementation class manageCategoryServlet
 */
public class ManageCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ManageCategoryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action") == null ? "DEFAULT_ACTION" : request.getParameter("action");
		
		switch(action) {
		case "DELETE":
			deleteCategory(request, response);
			break;
		default:
			getAllCategory(request, response);
		}
	}

	private void getAllCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		CategoryDAO categoryDAO = CategoryDAO.getInstance();
		
		ArrayList<Category> categories = new ArrayList<Category>();
		categories = categoryDAO.getAll();
		
		request.setAttribute("categories", categories);
		
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/category/manage-category.jsp");
		rd.forward(request, response);
	}
	
	private void deleteCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		CategoryDAO categoryDAO = CategoryDAO.getInstance();
		
		int IDdelete = Integer.parseInt(request.getParameter("id"));
		categoryDAO.deleteCategory(IDdelete);
		
		response.sendRedirect(request.getContextPath() + "/restaurant/category/manage-category?message=Category Deleted Successfully");
	}
	
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
