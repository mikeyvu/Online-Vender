package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import entity.Admin;
import entity.Category;
import utility.DBUtils;

public class CategoryDAO {
	
	// SINGLETON CATEGORYDAO INSTANCE
	private static CategoryDAO instance;
	
	private CategoryDAO() {}
	
	public static CategoryDAO getInstance() {
		if (CategoryDAO.instance == null) {
			CategoryDAO.instance = new CategoryDAO();
		}
		return CategoryDAO.instance;
	}
	
	
	// GET ALL CATEGORIES
	public ArrayList<Category> getAll() {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.category;";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			ArrayList<Category> categories = new ArrayList<Category>();
			
			while(resultSet.next()) {
				int id = resultSet.getInt("id");
				String title = resultSet.getString("title");
				String featured = resultSet.getString("featured");
				String active = resultSet.getString("active");
				
				categories.add(new Category(id, title, featured, active));
			}
			
			return categories;
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when getting all categories");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving categories from database");
			}
		}
		
		return new ArrayList<Category>();
	}
	
	// GET ALL ACTIVE CATEGORY
	public ArrayList<Category> getAllActiveCategories() {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.category WHERE active = 'Yes';";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			ArrayList<Category> categories = new ArrayList<Category>();
			
			while(resultSet.next()) {
				int id = resultSet.getInt("id");
				String title = resultSet.getString("title");
				String featured = resultSet.getString("featured");
				String active = resultSet.getString("active");
				
				categories.add(new Category(id, title, featured, active));
			}
			
			return categories;
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when getting all active categories");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving active categories from database");
			}
		}
		
		return new ArrayList<Category>();
	}
	
	// GET ONE CATEGORY BY ID 
		public Category getCategoryByID(int id) {
			Connection conn = null;
			PreparedStatement statement = null;
			
			try {
				conn = DBUtils.makeConnection();
				String SQL_Query = "SELECT * FROM food_order.category where id = " + id + ";";

				statement = conn.prepareStatement(SQL_Query);
				
				ResultSet resultSet = statement.executeQuery();
				
				while(resultSet.next()) {
					id = resultSet.getInt("id");
					String title = resultSet.getString("title");
					String featured = resultSet.getString("featured");
					String active = resultSet.getString("active");
					
					return new Category(id, title, featured, active);
				}
				
			} catch (Exception e ) {
				e.printStackTrace();
				System.out.println("Error happened when getting category " + id);
			} finally {
				try {
					if (statement != null) statement.close();
					if (conn != null) conn.close();
				} catch(SQLException e) {
					e.printStackTrace();
					System.out.println("error retrieving a single category from database");
				}
			}
			
			return null;
		}
	
	// ADD NEW CATEGORY
	public void addCategory(Category category) {
		Connection conn = null;
		Statement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "INSERT INTO `food_order`.`category` (`title`, `featured`, `active`) "
					+ "VALUES ('" + category.getTitle() +"', '"
							+ category.getFeatured() +"', '"
							+ category.getActive() + "');" ;

			statement = conn.createStatement();
			statement.executeUpdate(SQL_Query);
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when adding new category");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	
	// DELETE A CATEGORY
	public void deleteCategory(int id) {
		Connection conn = null;
		Statement statement = null;
		FoodDAO foodDAO = FoodDAO.getInstance();
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "DELETE FROM `food_order`.`category` WHERE (`id` = '" + id + "');";
			
			foodDAO.deleteFoodByCateID(id);

			statement = conn.createStatement();
			statement.executeUpdate(SQL_Query);
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when deleting category " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	
	// UPDATE A CATEGORY
	public void updateCategory(int id, String title, String featured, String active) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "UPDATE `food_order`.`category` SET `title` = '" + title 
															+ "', `featured` = '" + featured
															+ "', `active` = '" + active
															+ "' WHERE (`id` = " + id + ");";

			statement = conn.prepareStatement(SQL_Query);
			
			statement.executeUpdate(SQL_Query);
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when updating category " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error updating category " + id + " from database");
			}
		}
	}
}
