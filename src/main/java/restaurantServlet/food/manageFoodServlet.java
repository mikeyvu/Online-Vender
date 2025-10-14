package restaurantServlet.food;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

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
 * Servlet implementation class manageFoodServlet
 */
@WebServlet("/manageFoodServlet")
public class manageFoodServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public manageFoodServlet() {
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
			deleteFood(request, response);
			break;
		default:
			getAllFood(request, response);
		}
	}
	
	private void getAllFood(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		FoodDAO foodDAO = FoodDAO.getInstance();
		
		ArrayList<Food> foods = new ArrayList<Food>();
		foods = foodDAO.getAll();
		
		request.setAttribute("foods", foods);
		
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/food/manage-food.jsp");
		rd.forward(request, response);
	}
	
	private void deleteFood(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		FoodDAO foodDAO = FoodDAO.getInstance();
		
		String imageName = request.getParameter("image_name");
		String imagePath = "C:/Users/minhv/OneDrive - University of Wollongong/Documents/Backend Intensive/0 - Online Vender/src/main/webapp/assets/img/food/" + imageName;
		File file = new File(imagePath);
		if (file.exists() && file.delete()) {
		    System.out.println("File deleted successfully: " + imagePath);
		} else {
		    System.out.println("Failed to delete file: " + imagePath);
		}
		
		
		String IDdelete = request.getParameter("id");
		foodDAO.deleteFood(IDdelete);
		
		response.sendRedirect(request.getContextPath() + "/manageFoodServlet?message=Admin Deleted Successfully");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
