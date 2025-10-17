package clientServlet.home;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CategoryDAO;
import dao.FoodDAO;
import entity.Category;
import entity.Food;

/**
 * Servlet implementation class homeServlet
 */
public class HomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public HomeServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// Handle table_id from QR code
		String tableIdParam = request.getParameter("table_id");
		if (tableIdParam != null) {
			try {
				int tableId = Integer.parseInt(tableIdParam);
				if (tableId >= 1 && tableId <= 10) {
					// Store table_id in session
					request.getSession().setAttribute("table_id", tableId);
					System.out.println("Table ID " + tableId + " stored in session");
				} else {
					System.out.println("Invalid table ID: " + tableId);
				}
			} catch (NumberFormatException e) {
				System.out.println("Invalid table ID format: " + tableIdParam);
			}
		}
		
		CategoryDAO categoryDao = CategoryDAO.getInstance();
		FoodDAO foodDao = FoodDAO.getInstance();

		ArrayList<Category> activeCategories = categoryDao.getAllActiveCategories();
		HashMap<Category, ArrayList<Food>> foodMap = new HashMap<>();

		for (Category cate : activeCategories) {
			int categoryID = cate.getId();
			ArrayList<Food> categoryFoods = foodDao.getFoodByCateID(categoryID);
			foodMap.put(cate, categoryFoods);
		}

		request.setAttribute("menuItems", foodMap);

		RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
