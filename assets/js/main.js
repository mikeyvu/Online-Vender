/**
* Template Name: Yummy
* Template URL: https://bootstrapmade.com/yummy-bootstrap-restaurant-website-template/
* Updated: Aug 07 2024 with Bootstrap v5.3.3
* Author: BootstrapMade.com
* License: https://bootstrapmade.com/license/
*/

(function() {
  "use strict";

  /**
   * Apply .scrolled class to the body as the page is scrolled down
   */
  function toggleScrolled() {
    const selectBody = document.querySelector('body');
    const selectHeader = document.querySelector('#header');
    if (!selectHeader.classList.contains('scroll-up-sticky') && !selectHeader.classList.contains('sticky-top') && !selectHeader.classList.contains('fixed-top')) return;
    window.scrollY > 100 ? selectBody.classList.add('scrolled') : selectBody.classList.remove('scrolled');
  }

  document.addEventListener('scroll', toggleScrolled);
  window.addEventListener('load', toggleScrolled);

  /**
   * Mobile nav toggle
   */
  const mobileNavToggleBtn = document.querySelector('.mobile-nav-toggle');

  function mobileNavToogle() {
    document.querySelector('body').classList.toggle('mobile-nav-active');
    mobileNavToggleBtn.classList.toggle('bi-list');
    mobileNavToggleBtn.classList.toggle('bi-x');
  }
  mobileNavToggleBtn.addEventListener('click', mobileNavToogle);

  /**
   * Hide mobile nav on same-page/hash links
   */
  document.querySelectorAll('#navmenu a').forEach(navmenu => {
    navmenu.addEventListener('click', () => {
      if (document.querySelector('.mobile-nav-active')) {
        mobileNavToogle();
      }
    });

  });

  /**
   * Toggle mobile nav dropdowns
   */
  document.querySelectorAll('.navmenu .toggle-dropdown').forEach(navmenu => {
    navmenu.addEventListener('click', function(e) {
      e.preventDefault();
      this.parentNode.classList.toggle('active');
      this.parentNode.nextElementSibling.classList.toggle('dropdown-active');
      e.stopImmediatePropagation();
    });
  });

  /**
   * Preloader
   */
  const preloader = document.querySelector('#preloader');
  if (preloader) {
    window.addEventListener('load', () => {
      preloader.remove();
    });
  }

  /**
   * Scroll top button
   */
  let scrollTop = document.querySelector('.scroll-top');

  function toggleScrollTop() {
    if (scrollTop) {
      window.scrollY > 100 ? scrollTop.classList.add('active') : scrollTop.classList.remove('active');
    }
  }
  scrollTop.addEventListener('click', (e) => {
    e.preventDefault();
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });

  window.addEventListener('load', toggleScrollTop);
  document.addEventListener('scroll', toggleScrollTop);

  /**
   * Animation on scroll function and init
   */
  function aosInit() {
    AOS.init({
      duration: 600,
      easing: 'ease-in-out',
      once: true,
      mirror: false
    });
  }
  window.addEventListener('load', aosInit);

  /**
   * Initiate glightbox
   */
  const glightbox = GLightbox({
    selector: '.glightbox'
  });

  /**
   * Initiate Pure Counter
   */
  new PureCounter();

  /**
   * Init swiper sliders
   */
  function initSwiper() {
    document.querySelectorAll(".init-swiper").forEach(function(swiperElement) {
      let config = JSON.parse(
        swiperElement.querySelector(".swiper-config").innerHTML.trim()
      );

      if (swiperElement.classList.contains("swiper-tab")) {
        initSwiperWithCustomPagination(swiperElement, config);
      } else {
        new Swiper(swiperElement, config);
      }
    });
  }

  window.addEventListener("load", initSwiper);

  /**
   * Correct scrolling position upon page load for URLs containing hash links.
   */
  window.addEventListener('load', function(e) {
    if (window.location.hash) {
      if (document.querySelector(window.location.hash)) {
        setTimeout(() => {
          let section = document.querySelector(window.location.hash);
          let scrollMarginTop = getComputedStyle(section).scrollMarginTop;
          window.scrollTo({
            top: section.offsetTop - parseInt(scrollMarginTop),
            behavior: 'smooth'
          });
        }, 100);
      }
    }
  });

  /**
   * Navmenu Scrollspy
   */
  let navmenulinks = document.querySelectorAll('.navmenu a');

  function navmenuScrollspy() {
    navmenulinks.forEach(navmenulink => {
      if (!navmenulink.hash) return;
      let section = document.querySelector(navmenulink.hash);
      if (!section) return;
      let position = window.scrollY + 200;
      if (position >= section.offsetTop && position <= (section.offsetTop + section.offsetHeight)) {
        document.querySelectorAll('.navmenu a.active').forEach(link => link.classList.remove('active'));
        navmenulink.classList.add('active');
      } else {
        navmenulink.classList.remove('active');
      }
    })
  }
  window.addEventListener('load', navmenuScrollspy);
  document.addEventListener('scroll', navmenuScrollspy);

})();

(function () {
  let cartCount = 0; // Initialize cart count
  const cartCountElement = document.querySelector('.cart-count'); // Select cart count display
  const plusIcons = document.querySelectorAll('.plus-icon');
  const formContainer = document.getElementById('form-container');
  const orderForm = document.getElementById('order-form');

  // Attach click event to each plus icon
  plusIcons.forEach((icon) => {
    icon.addEventListener('click', function () {
      const menuItem = this.closest('.menu-item');
      const itemName = menuItem.querySelector('.item-name').textContent;
      const itemPrice = menuItem.querySelector('.price').textContent.trim();
      const itemIngredients = menuItem.querySelector('.ingredients').textContent;
      const itemImage = menuItem.querySelector('img').src; // Get the image URL

      document.getElementById('form-item-name').textContent = itemName;
      document.getElementById('form-item-price').textContent = itemPrice;
      document.getElementById('form-item-ingredients').textContent = itemIngredients;

      formContainer.style.display = 'block'; // Show the form

      orderForm.onsubmit = function (event) {
        event.preventDefault();
        const quantity = parseInt(document.getElementById('quantity').value);
        const note = document.getElementById('note').value;

        // Retrieve the current shopping cart from localStorage
        let cart = JSON.parse(localStorage.getItem('shoppingCart')) || [];

        // Check if the item already exists in the cart by matching name and price
        const existingItem = cart.find(item => item.name === itemName && item.price === itemPrice);

        if (existingItem) {
          // If the item exists, update the quantity and append new note (if provided)
          existingItem.quantity += quantity;
          if (note) {
            existingItem.note += existingItem.note ? `, ${note}` : note;
          }
        } else {
          // If the item doesn't exist, add it as a new item
          cart.push({
            name: itemName,
            price: itemPrice,
            ingredients: itemIngredients,
            image: itemImage, // Save the image URL
            quantity: quantity,
            note: note
          });
        }

        // Save the updated cart back to localStorage
        localStorage.setItem('shoppingCart', JSON.stringify(cart));

        // Update cart count
        cartCount = cart.reduce((total, item) => total + item.quantity, 0);
        cartCountElement.textContent = cartCount;

        alert('Item added to cart!');
        formContainer.style.display = 'none';
        orderForm.reset(); // Reset form fields
      };
    });
  });

  // Close form when clicking outside of it
  document.addEventListener('click', function (event) {
    if (!formContainer.contains(event.target) && !event.target.closest('.plus-icon')) {
      formContainer.style.display = 'none';
    }
  });
})();
