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
 * Servlet implementation class updateFoodServlet
 */
@MultipartConfig
public class UpdateFoodServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateFoodServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");
		
		FoodDAO foodDAO = FoodDAO.getInstance();
		Food food = foodDAO.getFoodByID(Integer.parseInt(id));
		
		request.setAttribute("foodUpdate", food);
		
		CategoryDAO categoryDAO = CategoryDAO.getInstance();
		ArrayList<Category> categories = categoryDAO.getAllActiveCategories();
		
		request.setAttribute("categories", categories);
		
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/food/update-food.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		FoodDAO foodDAO = FoodDAO.getInstance();
		
		if (request.getParameter("submit") != null) {
			String title = request.getParameter("title");
			String description = request.getParameter("description");
			double price = Double.parseDouble(request.getParameter("price"));
			int categoryID = Integer.parseInt(request.getParameter("category"));
	        String featured = request.getParameter("featured");
	        String active = request.getParameter("active");
	        int id = Integer.parseInt(request.getParameter("id"));
	        
	        //get the original name of the image
	        Part filePart = request.getPart("image");
			String originalFileName = filePart.getSubmittedFileName();
			
			// Get the servlet context path and build the project path dynamically
			String contextPath = getServletContext().getRealPath("/");
			String uploadPath = contextPath + "assets\\img\\food";
			
			// Ensure the directory exists
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			String newImage = null;
			
			if (originalFileName != null && !originalFileName.isEmpty()) {
				//If a new image is upload, change its name to sync the title
				String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
				newImage = title.strip() + fileExtension;
				
				// Delete the old image file
	            String currentImage = request.getParameter("current_image");
	            File oldFile = new File(uploadPath + currentImage);
	            if (oldFile.exists() && oldFile.delete()) {
	                    System.out.println("Deleted old image: " + currentImage);
                } else {
                    System.out.println("Failed to delete old image: " + currentImage);
                }
	            
	            // Full path for updating the file
	            String filePath = uploadPath + "\\" + newImage;
	            System.out.println("Updating file's path: " + filePath);
	            
	            //copy the uploaded file to the source project's asset folder
				try(InputStream inputStream = filePart.getInputStream()) {
					Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
				}
				catch(IOException e) {
					e.printStackTrace();
					System.out.println("Error updating file to asset folder: " + e.getMessage());
				}
	            System.out.println("Saved new image: " + newImage);
			} else {
				//If there is no new image upload, keep the old image
				newImage = request.getParameter("current_image");
			}
			
	        foodDAO.updateFood(id, title, description, price, newImage, categoryID, featured, active);
	        
	        response.sendRedirect(request.getContextPath() + "/restaurant/food/manage-food?message=Food Updated Successfully");
		}
	}
}
