<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<jsp:include page="/restaurant/partials/menu.jsp"/>

<div class="main-content">
    <div class="wrapper">
        <h1>Update Category</h1>
        <br><br>

        <form action="<%= request.getContextPath() %>/restaurant/category/update-category" 
		      method="POST" 
		      enctype="multipart/form-data" 
		      onsubmit="return validateForm()">
		
		    <table class="tbl-30">
		        <tr>
		            <td>Title:</td>
		            <td>
		                <input type="text" name="title" id="title" 
		                       value="${categoryUpdate.title}" 
		                       required 
		                       minlength="2" 
		                       maxlength="100"
		                       placeholder="Enter category title">
		            </td>
		        </tr>
		
		        <tr>
		            <td>Featured:</td>
		            <td>
		                <input type="radio" name="featured" value="Yes" id="featuredYes"
		                    <c:if test="${categoryUpdate.featured == 'Yes'}">checked</c:if>> Yes
		                <input type="radio" name="featured" value="No" id="featuredNo"
		                    <c:if test="${categoryUpdate.featured == 'No'}">checked</c:if>> No
		            </td>
		        </tr>
		
		        <tr>
		            <td>Active:</td>
		            <td>
		                <input type="radio" name="active" value="Yes" id="activeYes"
		                    <c:if test="${categoryUpdate.active == 'Yes'}">checked</c:if>> Yes
		                <input type="radio" name="active" value="No" id="activeNo"
		                    <c:if test="${categoryUpdate.active == 'No'}">checked</c:if>> No
		            </td>
		        </tr>
		
		        <tr>
		            <td colspan="2">
		                <input type="hidden" name="id" value="${categoryUpdate.id}">
		                <input type="submit" name="submit" value="Update Category" class="btn-secondary">
		            </td>
		        </tr>
		    </table>
		</form>
		
		<script>
		function validateForm() {
		    const title = document.getElementById("title").value.trim();
		    const featuredYes = document.getElementById("featuredYes").checked;
		    const featuredNo = document.getElementById("featuredNo").checked;
		    const activeYes = document.getElementById("activeYes").checked;
		    const activeNo = document.getElementById("activeNo").checked;
		
		    if (title === "") {
		        alert("Please enter a title.");
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
		
		    return true; // allow submit
		}
		</script>

    </div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />