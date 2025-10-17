<jsp:include page="/restaurant/partials/menu.jsp" />
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<div class="main-content">
	<div class="wrapper">
		<h1>Add Food</h1>
		
		<br> <br>
		
		<!-- Add Food Form Starts -->
		<form action="<%= request.getContextPath() %>/restaurant/food/add-food" 
		      method="POST" 
		      enctype="multipart/form-data"
		      onsubmit="return validateForm()">
		
		  <table class="tbl-30">
		
		    <tr>
		      <td>Title: </td>
		      <td>
		        <input type="text" id="title" name="title" placeholder="Food Title">
		      </td>
		    </tr>
		
		    <tr>
		      <td>Description: </td>
		      <td>
		        <textarea id="description" name="description" cols="30" rows="5" placeholder="Description of the food"></textarea>
		      </td>
		    </tr>
		
		    <tr>
		      <td>Price: </td>
		      <td>
		        <input type="number" id="price" step="0.01" name="price">
		      </td>
		    </tr>
		
		    <tr>
		      <td>Select Image: </td>
		      <td>
		        <input type="file" id="image" name="image" accept="image/*">
		      </td>
		    </tr>
		
		    <tr>
		      <td>Category: </td>
		      <td>
		        <select id="category" name="category">
		          <c:forEach var="c" items="${categories}">
		            <option value="${c.id}">${c.title}</option>
		          </c:forEach>
		        </select>
		      </td>
		    </tr>
		
		    <tr>
		      <td>Featured: </td>
		      <td>
		        <input type="radio" id="featuredYes" name="featured" value="Yes"> Yes
		        <input type="radio" id="featuredNo" name="featured" value="No"> No
		      </td>
		    </tr>
		
		    <tr>
		      <td>Active: </td>
		      <td>
		        <input type="radio" id="activeYes" name="active" value="Yes"> Yes
		        <input type="radio" id="activeNo" name="active" value="No"> No
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
		
		<script>
		function validateForm() {
		  const title = document.getElementById("title").value.trim();
		  const description = document.getElementById("description").value.trim();
		  const price = document.getElementById("price").value.trim();
		  const image = document.getElementById("image").value.trim();
		  const category = document.getElementById("category").value.trim();
		
		  const featuredYes = document.getElementById("featuredYes").checked;
		  const featuredNo = document.getElementById("featuredNo").checked;
		  const activeYes = document.getElementById("activeYes").checked;
		  const activeNo = document.getElementById("activeNo").checked;
		
		  // Title
		  if (title === "") {
		    alert("Please enter a food title.");
		    return false;
		  }
		
		  // Description
		  if (description === "") {
		    alert("Please enter a food description.");
		    return false;
		  }
		
		  // Price
		  if (price === "" || isNaN(price) || parseFloat(price) <= 0) {
		    alert("Please enter a valid price greater than 0.");
		    return false;
		  }
		
		  // Image
		  if (image === "") {
		    alert("Please select an image file.");
		    return false;
		  }
		
		  // Category
		  if (category === "") {
		    alert("Please select a category.");
		    return false;
		  }
		
		  // Featured
		  if (!featuredYes && !featuredNo) {
		    alert("Please choose whether the food is featured.");
		    return false;
		  }
		
		  // Active
		  if (!activeYes && !activeNo) {
		    alert("Please choose whether the food is active.");
		    return false;
		  }
		
		  return true;
		}
		</script>
	</div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />