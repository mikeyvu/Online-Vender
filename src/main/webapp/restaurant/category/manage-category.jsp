<jsp:include page="/restaurant/partials/menu.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- Main Section Starts -->
<div class="main-section">
	<div class="wrapper">
		<h1>Manage Category</h1>
		<br>
		<br>
		<br>

		<!-- Button to Add Category -->
		<a href="<%=request.getContextPath()%>/addCategoryServlet"
			class="btn-primary">Add Category</a> <br>
		<br>
		<br>

		<table class="tbl-full">
			<tr>
				<th>S.N.</th>
				<th>Title</th>
				<th>Featured</th>
				<th>Active</th>
				<th>Action</th>
			</tr>

			<c:set var="sn" value="1" />
			<c:forEach var="c" items="${categories}">
				<tr>
					<td>${sn }</td>
					<td>${c.title}</td>
					<td>${c.featured}</td>
					<td>${c.active}</td>
					<td>
						<a href="<%= request.getContextPath() %>/updateCategoryServlet?id=${c.id }" class="btn-secondary">Update Category</a> 
						<a href="<%= request.getContextPath() %>/manageCategoryServlet?action=DELETE&id=${c.id}" class="btn-danger">Delete Category</a>
					</td>
				</tr>
				<c:set var="sn" value="${sn + 1}" />
			</c:forEach>
		</table>
	</div>
</div>
<!-- Main Section Ends -->


<jsp:include page="/restaurant/partials/footer.jsp" />