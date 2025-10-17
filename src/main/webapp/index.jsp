<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
// If no menuItems are set, redirect to HomeServlet
if (request.getAttribute("menuItems") == null) {
    response.sendRedirect(request.getContextPath() + "/home");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">


<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>Yummy</title>
<meta name="description" content="">
<meta name="keywords" content="">

<!-- Font Awesome CDN -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">


<!-- Favicons -->
<link href="assets/img/favicon.png" rel="icon">
<link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Inter:wght@100;200;300;400;500;600;700;800;900&family=Amatic+SC:wght@400;700&display=swap"
	rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="assets/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<link href="assets/vendor/bootstrap-icons/bootstrap-icons.css"
	rel="stylesheet">
<link href="assets/vendor/aos/aos.css" rel="stylesheet">
<link href="assets/vendor/glightbox/css/glightbox.min.css"
	rel="stylesheet">
<link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

<!-- Main CSS File -->
<link href="assets/css/main.css" rel="stylesheet">

</head>

<body class="index-page">

	<header id="header" class="header d-flex align-items-center sticky-top">
		<div
			class="container position-relative d-flex align-items-center justify-content-between">

			<a href="<%=request.getContextPath()%>/HomeServlet"
				class="logo d-flex align-items-center me-auto me-xl-0"> <!-- Uncomment the line below if you also wish to use an image logo -->
				<!-- <img src="assets/img/logo.png" alt=""> -->
				<h1 class="sitename">Yummy</h1> <span>.</span>
			</a>

			<nav id="navmenu" class="navmenu">
				<ul>
					<li><a href="#hero" class="active">Home<br></a></li>
					<li><a href="#menu">Menu</a></li>
				</ul>
				<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
			</nav>

			<!-- Shopping Cart Icon -->
			<a href="shopping_cart.jsp" class="btn btn-outline-primary ms-3"
				id="cart-button"> <i class="bi bi-cart-fill"></i> <span
				class="cart-count badge bg-danger">0</span>
			</a>

		</div>
	</header>

	<main class="main">

		<!-- Hero Section -->
		<section id="hero" class="hero section light-background">

			<div class="container">
				<div
					class="row gy-4 justify-content-center justify-content-lg-between">
					<div
						class="col-lg-5 order-2 order-lg-1 d-flex flex-column justify-content-center">
						<h1 data-aos="fade-up">
							Enjoy our delicious<br>Vietnamese Food
						</h1>
					</div>
					<div class="col-lg-5 order-1 order-lg-2 hero-img"
						data-aos="zoom-out">
						<img src="assets/img/hero-img.png" class="img-fluid animated"
							alt="">
					</div>
				</div>
			</div>

		</section>
		<!-- /Hero Section -->

		<!-- Menu Section -->
		<section id="menu" class="menu section">

			<div class="container section-title" data-aos="fade-up">
				<h2>Our Menu</h2>
				<p>
					<span>Check Our</span> <span class="description-title">Yummy
						Menu</span>
				</p>
			</div>

			<div class="container" data-aos="fade-up" data-aos-delay="100">

				<!-- Nav tabs -->
				<ul class="nav nav-tabs d-flex justify-content-center" id="menuTabs"
					role="tablist">
					<c:forEach var="entry" items="${menuItems}" varStatus="status">
						<li class="nav-item" role="presentation">
							<button
								class="nav-link <c:if test='${status.first}'>active</c:if>"
								id="tab-${entry.key.id}" data-bs-toggle="tab"
								data-bs-target="#menu-${entry.key.id}" type="button" role="tab"
								aria-controls="menu-${entry.key.id}"
								aria-selected="<c:out value='${status.first}'/>">
								${entry.key.title}</button>
						</li>
					</c:forEach>
				</ul>
				<!-- /Nav tabs -->

				<!-- Tab panes -->
				<div class="tab-content mt-4" id="menuTabsContent">
					<c:forEach var="entry" items="${menuItems}" varStatus="status">
						<div
							class="tab-pane fade <c:if test='${status.first}'>show active</c:if>"
							id="menu-${entry.key.id}" role="tabpanel"
							aria-labelledby="tab-${entry.key.id}">

							<div class="tab-header text-center">
								<p>Category</p>
								<h3>${entry.key.title}</h3>
							</div>

							<div class="row gy-5">
								<c:forEach var="food" items="${entry.value}">
									<div class="col-lg-4 menu-item">
										<a href="assets/img/food/${food.imageName}" class="glightbox"> <img
											src="assets/img/food/${food.imageName}" class="menu-img img-fluid"
											alt="${food.title}">
										</a>
										<h4 class="item-name">${food.title}</h4>
										<p class="ingredients">${food.description}</p>
										<p class="price">$${food.price}</p>
										<span class="plus-icon"><i class="fas fa-plus"></i></span>
									</div>
								</c:forEach>
							</div>

						</div>
					</c:forEach>
				</div>

			</div>

		</section>
		<!-- /Menu Section -->

	</main>

	<!-- Scroll Top -->
	<a href="#" id="scroll-top"
		class="scroll-top d-flex align-items-center justify-content-center"><i
		class="bi bi-arrow-up-short"></i></a>

	<!-- Add to Cart Popup Form -->
	<div id="form-overlay" class="form-overlay" onclick="closeForm()"></div>
	<div id="form-container" class="form-container">
		<div class="form-header">
			<h3>Add to Cart</h3>
			<button type="button" class="close-btn" onclick="closeForm()">&times;</button>
		</div>
		<div class="form-content">
			<div class="item-info">
				<h4 id="form-item-name"></h4>
				<p id="form-item-price"></p>
				<p id="form-item-ingredients"></p>
			</div>
			<form id="order-form">
				<div class="form-group">
					<label for="quantity">Quantity:</label>
					<input type="number" id="quantity" name="quantity" min="1" value="1" required>
				</div>
				<div class="form-group">
					<label for="note">Special Notes (Optional):</label>
					<textarea id="note" name="note" rows="3" placeholder="Any special instructions or modifications..."></textarea>
				</div>
				<div class="form-actions">
					<button type="button" class="cancel-btn" onclick="closeForm()">Cancel</button>
					<button type="submit" class="add-to-cart-btn">Add to Cart</button>
				</div>
			</form>
		</div>
	</div>

	<!-- Preloader -->
	<div id="preloader"></div>

	<!-- Vendor JS Files -->
	<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="assets/vendor/php-email-form/validate.js"></script>
	<script src="assets/vendor/aos/aos.js"></script>
	<script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
	<script src="assets/vendor/purecounter/purecounter_vanilla.js"></script>
	<script src="assets/vendor/swiper/swiper-bundle.min.js"></script>

	<!-- Main JS File -->
	<script src="assets/js/main.js"></script>

</body>