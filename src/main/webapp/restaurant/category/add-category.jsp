<jsp:include page="/restaurant/partials/menu.jsp" />
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<div class="main-content">
	<div class="wrapper">
		<h1>Add Category</h1>
		
		<br> <br>
		
		<!-- Add Category Form Starts -->
		<form action="<%= request.getContextPath() %>/addCategoryServlet" method="POST" enctype="multipart/form-data">
		
			<table class="tbl-30">
			
				<tr>
					<td>Title: </td>
					<td>
						<input type="text" name="title" placeholder="Category Title">
					</td>
				</tr>
				
				<tr>
					<td>Select Image: </td>
					<td>
						<input type="file" name="image" accept="image/*">
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
						<input type="submit" name="submit" value="Add Category" class="btn-secondary">
					</td>
				</tr>
				
			</table>
		</form>
		<!-- Add Category Form Ends -->
	</div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />