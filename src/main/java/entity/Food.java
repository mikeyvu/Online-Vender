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
	private String categoryID;
	private String featured;
	private String active;
}
