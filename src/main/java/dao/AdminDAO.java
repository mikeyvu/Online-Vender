package dao;

import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import entity.Admin;
import utility.DBUtils;

public class AdminDAO {
	
	public ArrayList<Admin> getAll() {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.admin;";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			ArrayList<Admin> admins = new ArrayList<Admin>();
			
			while(resultSet.next()) {
				int id = resultSet.getInt("id");
				String fullName = resultSet.getString("full_name");
				String username = resultSet.getString("username");
				
				admins.add(new Admin(id, fullName, username));
			}
			
			return admins;
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when getting all admins");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving admins from database");
			}
		}
		
		return new ArrayList<Admin>();
	}
	
	public void addAdmin(Admin admin) {
		Connection conn = null;
		Statement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "INSERT INTO `food_order`.`admin` (`full_name`, `username`, `password`) VALUES ('" + admin.getFullName() + "', '" + admin.getUsername() + "', '" + admin.getPassword() +"');";

			statement = conn.createStatement();
			statement.executeUpdate(SQL_Query);
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when adding new admin");
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public void deleteAdmin(String id) {
		Connection conn = null;
		Statement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "DELETE FROM `food_order`.`admin` WHERE (`id` = '" + id + "');";

			statement = conn.createStatement();
			statement.executeUpdate(SQL_Query);
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when deleting admin " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public Admin getAdminByID(int id) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.admin where id = " + id + ";";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			while(resultSet.next()) {
				id = resultSet.getInt("id");
				String fullName = resultSet.getString("full_name");
				String username = resultSet.getString("username");
				String password = resultSet.getString("password");
				
				return new Admin(id, fullName, username, password);
			}
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when getting admin " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving admins from database");
			}
		}
		
		return null;
	}
	
	public void updateAdmin(int id, String fullName, String userName) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "UPDATE `food_order`.`admin` SET `full_name` = '" + fullName 
															+ "', `username` = '" + userName 
															+ "' WHERE (`id` = " + id + ");";

			statement = conn.prepareStatement(SQL_Query);
			
			statement.executeUpdate(SQL_Query);
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when updating admin " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving admins from database");
			}
		}
	}
	
	public void updatePassword(int id, String newPassword) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "UPDATE `food_order`.`admin` SET `password` = '" + newPassword 
															+ "' WHERE (`id` = " + id + ");";

			statement = conn.prepareStatement(SQL_Query);
			
			statement.executeUpdate(SQL_Query);
			
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when updating password for admin " + id);
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving admins from database");
			}
		}
	}
	
	public Admin adminLogin(Admin admin) {
		Connection conn = null;
		PreparedStatement statement = null;
		
		try {
			conn = DBUtils.makeConnection();
			String SQL_Query = "SELECT * FROM food_order.admin where username = '" + admin.getUsername() + "' and password = '" + admin.getPassword() + "';";

			statement = conn.prepareStatement(SQL_Query);
			
			ResultSet resultSet = statement.executeQuery();
			
			while(resultSet.next()) {
				int id = resultSet.getInt("id");
				String fullName = resultSet.getString("full_name");
				String username = resultSet.getString("username");
				String password = resultSet.getString("password");
				
				return new Admin(id, fullName, username, password);
			}
		} catch (Exception e ) {
			e.printStackTrace();
			System.out.println("Error happened when logging in for admin " + admin.getUsername());
		} finally {
			try {
				if (statement != null) statement.close();
				if (conn != null) conn.close();
			} catch(SQLException e) {
				e.printStackTrace();
				System.out.println("error retrieving admins from database");
			}
		}
		return null;
	}
}
