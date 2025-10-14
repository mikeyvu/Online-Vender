package restaurantServlet.food;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import dao.CategoryDAO;
import dao.FoodDAO;
import entity.Category;
import entity.Food;

/**
 * Servlet implementation class addFoodServlet
 */
@WebServlet("/addFoodServlet")
@MultipartConfig
public class addFoodServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addFoodServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		CategoryDAO categoryDAO = CategoryDAO.getInstance();
		ArrayList<Category> categories = categoryDAO.getAllActiveCategories();
		
		request.setAttribute("categories", categories);
		
		RequestDispatcher rd = request.getRequestDispatcher("restaurant/food/add-food.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (request.getParameter("submit") != null) {
			String title = request.getParameter("title");
			String description = request.getParameter("description");
			double price = Double.parseDouble(request.getParameter("price"));
			int categoryID = Integer.parseInt(request.getParameter("category"));
			String featured = request.getParameter("featured");
			String active = request.getParameter("active");
			
			Part filePart = request.getPart("image");
			String originalFileName = filePart.getSubmittedFileName();
			
			String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
			String newFileName = title.strip() + fileExtension;
			
//			String uploadPath ="src/main/webapp/assets/img/food";
			String uploadPath = System.getProperty("user.home") + "\\online-vender\\src\\main\\webapp\\assets\\img\\food";
			
			// Full path for saving the file
			String filePath = uploadPath + "\\" + newFileName;
			System.out.println("Saving file's path: " + filePath);
			
			//copy the uploaded file to the source project's asset folder
			try(InputStream inputStream = filePart.getInputStream()) {
				Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
			}
			catch(IOException e) {
				e.printStackTrace();
				System.out.println("Error copying file to asset folder: " + e.getMessage());
			}
			
			FoodDAO foodDAO = FoodDAO.getInstance();
			foodDAO.addFood(new Food(title, description, price, newFileName, categoryID, featured, active));
			response.sendRedirect(request.getContextPath() + "/manageFoodServlet?message=Food Added Successfully");
		}
	}

}
