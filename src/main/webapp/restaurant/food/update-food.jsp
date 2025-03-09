<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<jsp:include page="/restaurant/partials/menu.jsp"/>

<div class="main-content">
    <div class="wrapper">
        <h1>Update Food</h1>
        <br><br>

        <form action="<%= request.getContextPath() %>/updateFoodServlet" method="POST" enctype="multipart/form-data">

            <table class="tbl-30">
                <tr>
                    <td>Title: </td>
                    <td>
                        <input type="text" name="title" value="${foodUpdate.title }">
                    </td>
                </tr>
                
                <tr>
					<td>Description: </td>
					<td>
						<textarea name="description" col="30" rows="5">${foodUpdate.description }</textarea>
					</td>
				</tr>
				
				<tr>
					<td>Price: </td>
					<td>
						<input type="number" step="0.01" name="price" value="${foodUpdate.price }">
					</td>
				</tr>

                <tr>
                    <td>Current Image: </td>
                    <td>
                        <img alt="Current Image" src="/assets/img/food/${foodUpdate.imageName }" width=150px>
                    </td>
                </tr>

				<tr>
                    <td>New Image : </td>
                    <td>
                        <input type="file" name="image">
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
						<input type="radio" name="featured" value="Yes" 
							<c:if test="${foodUpdate.featured == 'Yes'}">checked</c:if> > Yes
						<input type="radio" name="featured" value="No"
							<c:if test="${foodUpdate.featured == 'No'}">checked</c:if> > No
					</td>
				</tr>
				
				<tr>
					<td>Active: </td>
					<td>
						<input type="radio" name="active" value="Yes"
							<c:if test="${foodUpdate.active == 'Yes'}">checked</c:if> > Yes
						<input type="radio" name="active" value="No"
							<c:if test="${foodUpdate.active == 'No'}">checked</c:if> > No
					</td>
				</tr>
				
                <tr>
                    <td colspan="2">
                    	<input type="hidden" name="current_image" value="${foodUpdate.imageName }">
                    	<input type="hidden" name="id" value="${foodUpdate.id }">
                        <input type="submit" name="submit" value="Update Category" class="btn-secondary">
                    </td>
                </tr>
            </table>

        </form>
    </div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />