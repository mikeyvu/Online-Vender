<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<jsp:include page="/restaurant/partials/menu.jsp"/>
		
	<!-- Main Section Starts -->
	<div class="main-section">
		<div class="wrapper">
			<h1>Manage Admin</h1>
			<br>
			
			<div>${message }</div>
			<br><br>
            <!-- Button to Add Admin -->
            <a href="<%= request.getContextPath() %>/add_admin" class="btn-primary">Add Admin</a>
            <br><br><br>

			<table class="tbl-full">
				<tr>
                    <th>S.N.</th>
                    <th>Full name</th>
                    <th>Username</th>
                    <th>Action</th>
                </tr>

				<c:set var="sn" value="1" />
                <c:forEach var="a" items="${admins}">
                <tr>
               		<td>${sn }</td>
               		<td>${a.fullName}</td>
               		<td>${a.username}</td>
               		<td>
               			<a href="<%= request.getContextPath() %>/update_password?id=${a.id }" class="btn-primary">Change Password</a>
                        <a href="<%= request.getContextPath() %>/update_admin?id=${a.id }" class="btn-secondary">Update Admin</a>
                        <a href="<%= request.getContextPath() %>/manage_admin?action=DELETE&id=${a.id}" class="btn-danger">Delete Admin</a>
                    </td>
                </tr>
                <c:set var="sn" value="${sn + 1}" />
               </c:forEach>
			</table>
		</div>
	</div>
	<!-- Main Section Ends -->
		
<jsp:include page="/restaurant/partials/footer.jsp" />

