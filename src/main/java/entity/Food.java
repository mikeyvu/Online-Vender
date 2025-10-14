package entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Food {
	private int id;
	private String title;
	private String description;
	private double price;
	private String imageName;
	private int categoryID;
	private String featured;
	private String active;
	
	public Food(String title, String description, double price, String imageName, int categoryID, String featured, String active) {
		this.title = title;
		this.description = description;
		this.price = price;
		this.imageName = imageName;
		this.categoryID = categoryID;
		this.featured = featured;
		this.active = active;
	}
}
