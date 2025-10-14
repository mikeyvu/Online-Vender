package utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBUtils {
	
	//connection pool = 20 (default)
	
	public static Connection makeConnection() {
		String PATH = "jdbc:mysql://localhost:3307/food_order";
		String USERNAME = "root";
		String PASSWORD = "root";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection(PATH, USERNAME, PASSWORD);
			System.out.println("Database connection successful");
			return conn;
		} catch (ClassNotFoundException | SQLException e) {
			System.err.println("Database connection failed: " + e.getMessage());
			e.printStackTrace();
		}
		return null;
	}
	
}
