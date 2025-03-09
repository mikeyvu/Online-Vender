<jsp:include page="/restaurant/partials/menu.jsp" />
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<div class="main-content">
	<div class="wrapper">
		<h1>Add Food</h1>
		
		<br> <br>
		
		<!-- Add Food Form Starts -->
		<form action="<%= request.getContextPath() %>/addFoodServlet" method="POST" enctype="multipart/form-data">
		
			<table class="tbl-30">
			
				<tr>
					<td>Title: </td>
					<td>
						<input type="text" name="title" placeholder="Food Title">
					</td>
				</tr>
				
				<tr>
					<td>Description: </td>
					<td>
						<textarea name="description" col="30" rows="5" placeholder="Description of the food"></textarea>
					</td>
				</tr>
				
				<tr>
					<td>Price: </td>
					<td>
						<input type="number" step="0.01" name="price">
					</td>
				</tr>
				
				<tr>
					<td>Select Image: </td>
					<td>
						<input type="file" name="image" accept="image/*">
					</td>
				</tr>
				
				<tr>
					<td>Category: </td>
					<td>
						<select name="category">
							<c:forEach var="c" items="${categories}">
								<option value="${c.id }">${c.title }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				
				<tr>
					<td>Featured: </td>
					<td>
						<input type="radio" name="featured" value="Yes"> Yes
						<input type="radio" name="featured" value="No"> No
					</td>
				</tr>
				
				<tr>
					<td>Active: </td>
					<td>
						<input type="radio" name="active" value="Yes"> Yes
						<input type="radio" name="active" value="No"> No
					</td>
				</tr>
				
				<tr>
					<td colspan="2">
						<input type="submit" name="submit" value="Add Food" class="btn-secondary">
					</td>
				</tr>
				
			</table>
		</form>
		<!-- Add Food Form Ends -->
	</div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />