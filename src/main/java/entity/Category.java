package entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Category {
	private int id;
	private String title;
	private String featured;
	private String active;
	
	public Category(String title, String featured, String active) {
		this.title = title;
		this.featured = featured;
		this.active = active;
	}
}
