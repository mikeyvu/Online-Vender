<jsp:include page="/restaurant/partials/menu.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="main-content">
	<div class="wrapper">
		<h1>Add Category</h1>

		<br><br>

		<!-- Show error message if validation failed -->
		<c:if test="${not empty errorMessage}">
			<div style="color: red; font-weight: bold; margin-bottom: 10px;">
				${errorMessage}
			</div>
		</c:if>

		<!-- Add Category Form Starts -->
		<form action="<%= request.getContextPath() %>/addCategoryServlet" 
			  method="POST" 
			  enctype="multipart/form-data" 
			  onsubmit="return validateForm()">

			<table class="tbl-30">
				<tr>
					<td>Title:</td>
					<td>
						<input type="text" name="title" id="title" placeholder="Category Title" required>
					</td>
				</tr>

				<tr>
					<td>Featured:</td>
					<td>
						<input type="radio" name="featured" value="Yes" id="featuredYes"> Yes
						<input type="radio" name="featured" value="No" id="featuredNo"> No
					</td>
				</tr>

				<tr>
					<td>Active:</td>
					<td>
						<input type="radio" name="active" value="Yes" id="activeYes"> Yes
						<input type="radio" name="active" value="No" id="activeNo"> No
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

<script>
function validateForm() {
	const title = document.getElementById("title").value.trim();
	const featuredYes = document.getElementById("featuredYes").checked;
	const featuredNo = document.getElementById("featuredNo").checked;
	const activeYes = document.getElementById("activeYes").checked;
	const activeNo = document.getElementById("activeNo").checked;

	if (title === "") {
		alert("Please enter a category title.");
		return false;
	}

	if (!(featuredYes || featuredNo)) {
		alert("Please select whether the category is featured.");
		return false;
	}

	if (!(activeYes || activeNo)) {
		alert("Please select whether the category is active.");
		return false;
	}

	return true; // Allow submission
}
</script>
