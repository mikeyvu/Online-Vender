<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<jsp:include page="/restaurant/partials/menu.jsp"/>

<div class="main-content">
    <div class="wrapper">
        <h1>Update Category</h1>
        <br><br>

        <form action="<%= request.getContextPath() %>/updateCategoryServlet" method="POST" enctype="multipart/form-data">

            <table class="tbl-30">
                <tr>
                    <td>Title: </td>
                    <td>
                        <input type="text" name="title" value="${categoryUpdate.title }">
                    </td>
                </tr>

                <tr>
                    <td>Current Image: </td>
                    <td>
                        <img alt="Current Image" src="/assets/img/category/${categoryUpdate.imageName }" width=150px>
                    </td>
                </tr>

				<tr>
                    <td>New Image : </td>
                    <td>
                        <input type="file" name="image">
                    </td>
                </tr>
                
                <tr>
					<td>Featured: </td>
					<td>
						<input type="radio" name="featured" value="Yes" 
							<c:if test="${categoryUpdate.featured == 'Yes'}">checked</c:if> > Yes
						<input type="radio" name="featured" value="No"
							<c:if test="${categoryUpdate.featured == 'No'}">checked</c:if> > No
					</td>
				</tr>
				
				<tr>
					<td>Active: </td>
					<td>
						<input type="radio" name="active" value="Yes"
							<c:if test="${categoryUpdate.active == 'Yes'}">checked</c:if> > Yes
						<input type="radio" name="active" value="No"
							<c:if test="${categoryUpdate.active == 'No'}">checked</c:if> > No
					</td>
				</tr>
				
                <tr>
                    <td colspan="2">
                    	<input type="hidden" name="current_image" value="${categoryUpdate.imageName }">
                    	<input type="hidden" name="id" value="${categoryUpdate.id }">
                        <input type="submit" name="submit" value="Update Category" class="btn-secondary">
                    </td>
                </tr>
            </table>

        </form>
    </div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />