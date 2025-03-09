package restaurantServlet.category;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;

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
 * Servlet implementation class addCategoryServlet
 */
@WebServlet("/addCategoryServlet")
@MultipartConfig
public class addCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addCategoryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("restaurant/category/add-category.jsp");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (request.getParameter("submit") != null) {
			String title = request.getParameter("title");
			String featured = request.getParameter("featured");
			String active = request.getParameter("active");
			
			
			Part filePart = request.getPart("image");
			String originalFileName = filePart.getSubmittedFileName();
			
			String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
			String newFileName = title.strip() + fileExtension;
			
			String uploadPath = "C:/Users/minhv/OneDrive - University of Wollongong/Documents/Backend Intensive/0 - Online Vender/online-vender/src/main/webapp/assets/img/category";
			File uploadDir = new File(uploadPath);

			// Ensure directory exists
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			// Full path for saving the file
			String filePath = uploadPath + File.separator + newFileName;
			filePart.write(filePath);
			
			
			Category category = new Category(title, newFileName, featured, active);
			
			CategoryDAO dao = CategoryDAO.getInstance();
			dao.addCategory(category);
			
			response.sendRedirect(request.getContextPath() + "/manageCategoryServlet");
		}
	}
}
