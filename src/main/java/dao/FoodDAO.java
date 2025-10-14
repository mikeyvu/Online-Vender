package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import entity.Category;
import entity.Food;
import utility.DBUtils;

public class FoodDAO {
	
	// SINGLETON CATEGORYDAO INSTANCE
	private static FoodDAO instance;
	
	private FoodDAO() {}
	
	public static FoodDAO getInstance() {
		if (FoodDAO.instance == null) {
			FoodDAO.instance = new FoodDAO();
		}
		return FoodDAO.instance;
	}
	
	// GET ALL FOOD
	public ArrayList<Food> getAll() {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.food;";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			ArrayList<Food> foods = new ArrayList<Food>();
			
			while(resultSet.next()) {
				int id = resultSet.getInt("id");
				String title = resultSet.getString("title");
				String description = resultSet.getString("description");
				double price = resultSet.getDouble("price");
				String imageName = resultSet.getString("image_name");
				String featured = resultSet.getString("featured");
				String active = resultSet.getString("active");
				
				foods.add(new Food(id, title, description, price, imageName, id, featured, active));
			}
			
			return foods;
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when getting all foods");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving foods from database");
			}
		}
		
		return new ArrayList<Food>();
	}
	
	
	
	
	// GET ONE FOOD BY ID 
	public Food getFoodByID(int id) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.food where id = " + id + ";";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			while(resultSet.next()) {
				id = resultSet.getInt("id");
				String title = resultSet.getString("title");
				String description = resultSet.getString("description");
				double price = resultSet.getDouble("price");
				String imageName = resultSet.getString("image_name");
				String featured = resultSet.getString("featured");
				String active = resultSet.getString("active");
				
				return new Food(id, title, description, price, imageName, id, featured, active);
			}
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when getting food " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving a single food from database");
			}
		}
		
		return null;
	}
	
	
	//GET FOOD BY CATEGORY ID
	public ArrayList<Food> getFoodByCateID(int categoryID) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.food WHERE category_id = " + categoryID + " AND active = 'Yes';";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			ArrayList<Food> foods = new ArrayList<Food>();
			
			while(resultSet.next()) {
				int id = resultSet.getInt("id");
				String title = resultSet.getString("title");
				String description = resultSet.getString("description");
				double price = resultSet.getDouble("price");
				String imageName = resultSet.getString("image_name");
				String featured = resultSet.getString("featured");
				String active = resultSet.getString("active");
				
				foods.add(new Food(id, title, description, price, imageName, id, featured, active));
			}
			
			return foods;
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when getting foods by categoryID");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving foods by categoryID from database");
			}
		}
		
		return new ArrayList<Food>();
	}
	
	
	
	// ADD A FOOD
	public void addFood(Food food) {
		Connection conn = null;
		Statement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "INSERT INTO `food_order`.`food` "
					+ "(`title`, `description`, `price`, `image_name`, `category_id`, `featured`, `active`) "
					+ "VALUES ('"
					+ food.getTitle() + "', '"
					+ food.getDescription() + "', "
					+ food.getPrice() + ", '"
					+ food.getImageName() + "', "
					+ food.getCategoryID() + ", '"
					+ food.getFeatured() + "', '"
					+ food.getActive() + "');";

			statement = conn.createStatement();
			statement.executeUpdate(SQL_Query);
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when adding new food");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	
	// DELETE A FOOD 
	public void deleteFood(String id) {
		Connection conn = null;
		Statement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "DELETE FROM `food_order`.`food` WHERE (`id` = '" + id + "');";

			statement = conn.createStatement();
			statement.executeUpdate(SQL_Query);
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when deleting food " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	// DELETE FOOD ASSOCIATED WITH A CATEGORY ID
	public void deleteFoodByCateID(int categoryId) {
		Connection conn = null;
		Statement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "DELETE FROM `food_order`.`food` WHERE (`category_id` = '" + categoryId + "');";

			statement = conn.createStatement();
			statement.executeUpdate(SQL_Query);
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when deleting food associating with category id: " + categoryId);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
		
	// UPDATE A FOOD
	public void updateFood(int id, String title, String description, double price, String imageName, int categoryID, String featured, String active) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "UPDATE `food_order`.`food` SET `title` = '" + title 
															+ "', `description` = '" + description
															+ "', `price` = " + price
															+ ", `image_name` = '" + imageName 
															+ "', `category_id` = " + categoryID
															+ ", `featured` = '" + featured
															+ "', `active` = '" + active
															+ "' WHERE (`id` = " + id + ");";

			statement = conn.prepareStatement(SQL_Query);
			
			statement.executeUpdate(SQL_Query);
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when updating food " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error updating food " + id + " from database");
			}
		}
	}
}
