<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Yummy Admin</title>
		
		<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
	</head>
	
	<body>
		<!-- Menu Section Starts -->
		<div class="menu text-center">
			<div class="wrapper">
				<ul>
					<li><a href="<%= request.getContextPath() %>/dashboardServlet">Home</a></li>
					<li><a href="<%= request.getContextPath() %>/manage_admin">Admin</a></li>
					<li><a href="<%= request.getContextPath() %>/manageCategoryServlet">Category</a></li>
					<li><a href="<%= request.getContextPath() %>/manageFoodServlet">Food</a></li>
					<li><a href="<%= request.getContextPath() %>/manageOrderServlet">Order</a></li>
					<li><a href="<%= request.getContextPath() %>/revenueServlet">Revenue</a></li>
					<li><a href="authenticationServlet?action=LOGOUT">Logout</a></li>
				</ul>
			</div>
		</div>
		<!-- Menu Section Ends -->