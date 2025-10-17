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
					<li><a href="<%= request.getContextPath() %>/restaurant/">Home</a></li>
					<li><a href="<%= request.getContextPath() %>/restaurant/admin/manage-admin">Admin</a></li>
					<li><a href="<%= request.getContextPath() %>/restaurant/category/manage-category">Category</a></li>
					<li><a href="<%= request.getContextPath() %>/restaurant/food/manage-food">Food</a></li>
					<li><a href="<%= request.getContextPath() %>/restaurant/order/manage-order">Order</a></li>
					<li><a href="<%= request.getContextPath() %>/restaurant/revenue/">Revenue</a></li>
					<li><a href="<%= request.getContextPath() %>/restaurant/admin/authentication?action=LOGOUT">Logout</a></li>
				</ul>
			</div>
		</div>
		<!-- Menu Section Ends -->