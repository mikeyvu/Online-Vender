package entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Admin {
	private int id;
	private String fullName;
	private String username;
	private String password;
	
	public Admin(String fullName, String username, String password) {
		this.fullName = fullName;
		this.username = username;
		this.password = password;
	}

	public Admin(int id2, String fullName2, String username2) {
		this.id = id2;
		this.fullName = fullName2;
		this.username = username2;
	}
	
	public Admin(String username, String password) {
		this.username = username;
		this.password = password;
	}
}
