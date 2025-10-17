<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html>


<html>
	<head>
		<meta charset="UTF-8">
		<title>Login - Fodd Order System</title>
		<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
	</head>
	
	<body>
		<div class="login">
			<h1 class="text-center">Login</h1>
			<br> <br>
			
			<!-- Login form starts here -->
			<form action="<%= request.getContextPath() %>/restaurant/admin/authentication" method="POST" class="text-center">
				
				Username: <br>
				<input type="text" name="username" placeholder="Enter Username: "> <br> <br>
				
				Password: <br>
				<input type="password" name="password" placeholder="Enter Password: "> <br> <br>
				
				<input type="submit" name="submit" value="Login" class="btn-primary">
			
			</form>
			<!-- Login form ends here -->
		</div>
	</body>
</html>