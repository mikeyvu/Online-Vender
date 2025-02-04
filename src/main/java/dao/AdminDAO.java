package dao;

import java.sql.SQLException;
import java.sql.Statement;

import java.sql.Connection;

import entity.Admin;
import utility.DBUtils;

public class AdminDAO {
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
}
