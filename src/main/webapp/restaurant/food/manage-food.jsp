<jsp:include page="/restaurant/partials/menu.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- Main Section Starts -->
<div class="main-section">
	<div class="wrapper">
		<h1>Manage Food</h1>
		<br>
		<br>
		<br>

		<!-- Button to Add Food -->
		<a href="<%=request.getContextPath()%>/restaurant/food/add-food" class="btn-primary">Add Food</a> <br>
		<br>
		<br>

		<table class="tbl-full">
			<tr>
				<th>S.N.</th>
				<th>Title</th>
				<th>Description</th>
				<th>Price</th>
				<th>Image</th>
				<th>Featured</th>
				<th>Active</th>
				<th>Action</th>
			</tr>

			<c:set var="sn" value="1" />
			<c:forEach var="c" items="${foods}">
				<tr>
					<td>${sn }</td>
					<td>${c.title}</td>
					<td>${c.description}</td>
					<td>$${c.price}</td>
					<td>
						<img src="<%= request.getContextPath() %>/assets/img/food/${c.imageName}" alt="Food Image" width="100px">
					</td>
					<td>${c.featured}</td>
					<td>${c.active}</td>
					<td>
						<a href="<%= request.getContextPath() %>/restaurant/food/update-food?id=${c.id }" class="btn-secondary">Update Food</a> 
						<a href="<%= request.getContextPath() %>/restaurant/food/manage-food?action=DELETE&id=${c.id}&image_name=${c.imageName}" class="btn-danger">Delete Food</a>
					</td>
				</tr>
				<c:set var="sn" value="${sn + 1}" />
			</c:forEach>
		</table>
	</div>
</div>
<!-- Main Section Ends -->


<jsp:include page="/restaurant/partials/footer.jsp" />