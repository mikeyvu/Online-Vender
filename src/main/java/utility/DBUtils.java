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
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(PATH, USERNAME, PASSWORD);
			return conn;
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
}
