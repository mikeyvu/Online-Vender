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
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    
	    CategoryDAO categoryDAO = CategoryDAO.getInstance();
	    request.setCharacterEncoding("UTF-8"); // handle Unicode titles properly

	    if (request.getParameter("submit") != null) {
	        String title = request.getParameter("title");
	        String featured = request.getParameter("featured");
	        String active = request.getParameter("active");
	        String idParam = request.getParameter("id");

	        String errorMessage = null;
	        int id = -1;

	        // 🔍 Validate ID
	        try {
	            id = Integer.parseInt(idParam);
	        } catch (NumberFormatException e) {
	            errorMessage = "Invalid category ID.";
	        }

	        // 🔍 Validate input fields
	        if (errorMessage == null && (title == null || title.trim().isEmpty())) {
	            errorMessage = "Title cannot be empty.";
	        } else if (errorMessage == null && (featured == null || featured.isEmpty())) {
	            errorMessage = "Please select whether the category is featured.";
	        } else if (errorMessage == null && (active == null || active.isEmpty())) {
	            errorMessage = "Please select whether the category is active.";
	        }

	        if (errorMessage != null) {
	            // ❌ If validation fails, reload the update form with error message
	            Category category = categoryDAO.getCategoryByID(id);
	            request.setAttribute("categoryUpdate", category);
	            request.setAttribute("errorMessage", errorMessage);
	            RequestDispatcher rd = request.getRequestDispatcher("/restaurant/category/update-category.jsp");
	            rd.forward(request, response);
	            return;
	        }

	        // ✅ Passed validation → Update category
	        categoryDAO.updateCategory(id, title.trim(), featured, active);

	        // Redirect back to manage page with a success message
	        response.sendRedirect(request.getContextPath() + "/manageCategoryServlet?message=Category Updated Successfully");
	    }
	}

}
