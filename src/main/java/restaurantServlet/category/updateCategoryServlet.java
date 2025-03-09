package restaurantServlet.category;

import java.io.File;
import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import dao.CategoryDAO;
import entity.Category;

/**
 * Servlet implementation class updateCategoryServlet
 */
@WebServlet("/updateCategoryServlet")
@MultipartConfig
public class updateCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public updateCategoryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");
		
		CategoryDAO categoryDAO = CategoryDAO.getInstance();
		Category category = categoryDAO.getCategoryByID(Integer.parseInt(id));
		
		request.setAttribute("categoryUpdate", category);
		
		RequestDispatcher rd = request.getRequestDispatcher("/restaurant/category/update-category.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		CategoryDAO categoryDAO = CategoryDAO.getInstance();
		
		if (request.getParameter("submit") != null) {
			String title = request.getParameter("title");
	        String featured = request.getParameter("featured");
	        String active = request.getParameter("active");
	        int id = Integer.parseInt(request.getParameter("id"));
	        
	        //get the original name of the image
	        Part filePart = request.getPart("image");
			String originalFileName = filePart.getSubmittedFileName();
			
			//Define upload directory path
			String uploadPath = "C:/Users/minhv/"
					+ "OneDrive - University of Wollongong/Documents/Backend Intensive/0 - "
					+ "Online Vender/online-vender/src/main/webapp/assets/img/category/";
			
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
	            
	            // Save new image file
	            File newFile = new File(uploadPath + newImage);
	            filePart.write(newFile.getAbsolutePath());
	            System.out.println("Saved new image: " + newImage);
			} else {
				//If there is no new image upload, keep the old image
				newImage = request.getParameter("current_image");
			}
			
	        categoryDAO.updateCategory(id, title, newImage, featured, active);
	        
	        response.sendRedirect(request.getContextPath() + "/manageCategoryServlet?message=Admin Updated Successfully");
		}
	}

}
