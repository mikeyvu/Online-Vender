# 🍽️ Online Vender

**Online Vender** is a web-based restaurant ordering system developed for a family business.  
It allows customers to conveniently browse and place food orders by scanning a QR code, while restaurants can manage menus, confirm payments, update order statuses, and track revenue — all from one unified platform.
Reduced the manual workload, helped restaurant to increase revenue by 40% and improved overall customer satisfaction through faster service. The system’s intuitive interface and automated workflow minimized human errors, optimized kitchen operations, and created a seamless dining experience for both customers and staff.

> **Note:** This is a private project developed for a family business. The repository is for **portfolio showcase purposes only** and is not available for public use or installation.

---

## 📖 Table of Contents
- [Background](#-background)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [System Flow](#-system-flow)
- [Key Technical Highlights](#-key-technical-highlights)
- [Screenshots](#️-screenshots)
- [Challenges & Solutions](#-challenges--solutions)
- [Future Improvements](#-future-improvements)
- [Installation](#️-installation)
- [Contact](#-contact)
- [Acknowledgments](#-acknowledgments)

---

## 🌟 Background
This system was created to modernize a family restaurant's order management process.  
Customers can now scan a QR code to access the digital menu, place their order directly online, and pay by cash or bank transfer — simplifying operations and improving the dining experience.

---

## 🚀 Features

### 🧑‍🍳 Customer Side
- Scan the **QR code** on the restaurant table to access the menu.  
- Browse the restaurant menu and add dishes into the **shopping cart**.  
- Edit or remove items directly in the cart before checkout.  
- Finalize the order, select a **payment method (cash/transfer)**, and **place the order**.  

> **Note:** Customers cannot update or confirm order statuses. Once the order is placed, it is sent to the restaurant in real time. After the order is prepared, waiters will serve it directly to the table.

### 🏠 Restaurant Side (Admin Panel)
- Manage **admins, food categories, and menu items**.  
- View and **confirm incoming orders** once payment (cash or bank transfer) is verified.  
- Update **order status** (e.g., Pending → Confirmed → Completed or Pending → Cancelled) for better kitchen coordination.  
- Track **revenue reports** by day and month.  
- Review **order history** and manage all orders efficiently.

---

## 🧰 Tech Stack

| Category | Technology |
|:---------|:-----------|
| **Backend** | Java Servlet, JDBC |
| **Frontend** | HTML5, CSS3, JavaScript (ES6) |
| **Database** | MySQL 8.0 |
| **Server** | Apache Tomcat 9 |
| **Real-Time** | Server-Sent Events (SSE) |
| **Template** | JSP (JavaServer Pages), JSTL |

---

## 🔁 System Flow
1. **Customer scans QR code** on the restaurant table and is redirected to the digital menu.  
2. Customer **browses menu**, adds items to the cart, and finalizes the order.  
3. Customer selects a **payment method** (cash or bank transfer) and **places the order**.  
4. The **order is sent to the restaurant** in real time via Server-Sent Events (SSE).  
5. Restaurant **verifies payment**, **confirms the order**, and updates the order status as it's being prepared.  
6. Once ready, **waiters bring the meal** directly to the customer's table.  
7. Restaurant marks the order as **Completed** in the system.  

---

## 🎯 Key Technical Highlights

### Real-Time Order Management
- Implemented **Server-Sent Events (SSE)** for live order notifications to the restaurant dashboard
- Orders appear instantly without page refresh, improving operational efficiency
- Auto-reconnection handling for stable real-time communication

### Persistent Image Storage
- Configured external image storage outside Tomcat deployment directory
- Prevents data loss on server restart/redeployment
- Used Tomcat `PreResources` for seamless asset serving

### Database Design
- Normalized schema with proper foreign key relationships
- Transaction management for order creation (order → order_items → total calculation)
- Revenue tracking with date-based aggregation queries

### Session & Security
- Secure admin authentication with session management
- Role-based access control (customer vs restaurant admin)
- Protected routes and servlet-level authorization

---

## 🖼️ Screenshots

### Customer Interface
- Menu browsing interface: ![alt text](screenshots/menu.png)
- Adding items form: ![alt text](screenshots/adding_item.png)
- Shopping cart with items: ![alt text](screenshots/shopping_cart.png)
- Order Summary: ![alt text](screenshots/order_summary.png)
- Payment Methods Options: ![alt text](screenshots/payment_methods.png)
- Demo Bank Transfer Payment: ![alt text](screenshots/transfer_payment.png)
- Cash Payment: ![alt text](screenshots/cash_payment.png)

### Restaurant Admin Dashboard
- Order management with status updates: ![alt text](screenshots/manage_order.png)
- Order status confirmed/cancelled:![alt text](screenshots/confirmed_cancelled.png)
- Order status completed: ![alt text](screenshots/completed_order.png) 
- Revenue reports (daily/monthly): ![alt text](screenshots/revenue.png)
- Dashboard: ![alt text](screenshots/dashboard.png)
- Authentication: ![alt text](screenshots/authentication.png)
- Admin Management: ![alt text](screenshots/admin.png)
- Category Management: ![alt text](screenshots/category.png)
- Food Management: ![alt text](screenshots/food.png)

---

## 💡 Challenges & Solutions

### Challenge 1: Order Dates Not Displaying
**Problem:** Order timestamps showed as `-- :` on the management dashboard despite dates being stored correctly in the database.

**Root Cause:** JSP was interpreting JavaScript template literals `${variable}` as JSP Expression Language (EL), causing the values to be stripped out before JavaScript execution.

**Solution:** Replaced ES6 template literals with traditional string concatenation in JSP-embedded JavaScript

**Lesson Learned:** Be careful when mixing modern JavaScript features with JSP templates that use similar syntax.

---

### Challenge 2: Category Dropdown Wrong Selection
**Problem:** When updating food items, the category dropdown always showed the first option instead of the food's actual category.

**Root Cause:** `FoodDAO` was incorrectly mapping the food's `id` to the `categoryID` field instead of reading `category_id` from the database.

**Solution:** 
1. Fixed DAO mapping in three methods (`getAll`, `getFoodByID`, `getFoodByCateID`):

2. Added JSTL comparison in `update-food.jsp`:
```jsp
<c:if test="${c.id eq foodUpdate.categoryID}">selected</c:if>
```

3. Changed servlet to load all categories (not just active ones) to ensure the current category appears in the dropdown.

**Lesson Learned:** Always verify DTO field mappings match database column names exactly.

---

### Challenge 3: Image Upload Data Loss
**Problem:** Uploaded food and category images disappeared after Tomcat server restart or redeployment.

**Root Cause:** Images were stored in Tomcat's deployment directory (`webapps/online-vender/assets/img/`), which gets cleared on each redeployment.

**Solution:**
1. Created external storage directory outside Tomcat

2. Updated upload servlets (`AddFoodServlet`, `UpdateFoodServlet`, etc.)

3. Configured `META-INF/context.xml` to map external directory:
```xml
<Resources>
    <PreResources 
        className="org.apache.catalina.webresources.DirResourceSet"
        base="(external_storage_directory)"
        webAppMount="/assets"
        internalPath="/" />
</Resources>
```

**Lesson Learned:** User-generated content should always be stored outside the application deployment directory for persistence.

---

### Challenge 4: Database Atomic Data Violation
**Problem:** Attempted to store multiple order items in a single row in the `order` table, violating atomic data rules.

**Root Cause:** Each database row must contain only one atomic value, not multiple items.

**Solution:** Created separate `order_item` table with `order_id` as foreign key, allowing multiple items per order while maintaining data normalization.

**Lesson Learned:** Follow database normalization rules—use separate tables with foreign keys for one-to-many relationships.

---

### Challenge 5: Circular Dependency (Chicken & Egg)
**Problem:** Order items needed `order_id`, but order total needed to be calculated from order items first.

**Root Cause:** Circular relationship—`order_items.order_id` requires `order.id`, but `order.total` requires sum of `order_items.total`.

**Solution:** Implemented **three-phase transaction**:
```java
// Phase 1: Create order with total = 0

// Phase 2: Insert order items with generated order_id

// Phase 3: Update order with calculated total
```

**Lesson Learned:** Use multi-phase transactions to resolve circular dependencies in database operations.

---

### Challenge 6: Tomcat Module Conflict
**Problem:** Error: `javax.servlet is accessible from more than one module: <unnamed>, java.servlet, tomcat.i18n`

**Root Cause:** Duplicate servlet libraries in both module path and classpath causing conflicts.

**Solution:**
1. Removed all Tomcat libraries from module path in build configuration
2. Kept Tomcat libraries only in classpath
3. Set **Targeted Runtime** to Tomcat installation directory in project properties
4. Reconfigured server to "Use Tomcat installation" (takes control) instead of workspace metadata

**Lesson Learned:** Avoid duplicate library declarations across different build paths in Java projects.

---

### Challenge 7: Absolute vs Relative URL Paths
**Problem:** Inconsistent URL routing causing broken links and resource loading failures.

**Root Cause:** Confusion between absolute paths (starting with `/`) and relative paths (no leading `/`).

**Solution:**
- **Absolute paths** (`/restaurant/menu`): Match similar path segments, append differences
- **Relative paths** (`restaurant/menu`): Don't match, append to current path completely
- Standardized all servlet mappings and JSP includes to use absolute paths with `request.getContextPath()`

**Lesson Learned:** Use absolute paths with context path for consistent routing: `<%=request.getContextPath()%>/path`

---

### Challenge 8: Multipart Form Data vs Parameters
**Problem:** Backend couldn't read request parameters, causing servlet to dispatch JSP file instead of JSON response.

**Root Cause:** Frontend sent **multipart form data** (for file uploads), but backend tried to read via `request.getParameter()` which doesn't work with multipart.

**Solution:** Used `request.getPart()` and multipart parsing for form data containing file uploads

**Lesson Learned:** Handle multipart/form-data differently from application/x-www-form-urlencoded—use `@MultipartConfig` and `getPart()` for file uploads.

---

## 🔮 Future Improvements

- [ ] **Online Payment Integration** - Support for PayPal, Stripe, or Vietnamese payment gateways (MoMo, VNPay)
- [ ] **Multi-Language Support** - Vietnamese and English translations with i18n
- [ ] **Table Reservation System** - Online booking integrated with QR ordering

---

## ⚙️ Installation

**This project is not available for public installation.**  

The repository is for **portfolio showcase purposes only** and is proprietary software developed for a private family business.

If you're interested in the technical implementation details or would like to discuss similar projects, please feel free to [contact me](#-contact).

---

## 📞 Contact

**Minh Vu**  
- GitHub: [@mikeyvu](https://github.com/mikeyvu)
- LinkedIn: (https://www.linkedin.com/in/hong-minh-vu-472834251/)
- Email: minhvu2614.work@gmail.com

💼 **Open to opportunities in:**
- Full-Stack Web Development
- Java/Spring Boot Development
- Database Design & Optimization
- Real-Time Application Development

---

## 🙏 Acknowledgments

Built with dedication to modernize family business operations and enhance customer dining experience.

Special thanks to:
- Family for trusting me with this project
- [BootstrapMade](https://bootstrapmade.com/) for the "Yummy" restaurant template used as frontend foundation
- Bootstrap team for the excellent framework and Bootstrap Icons
- The open-source community for invaluable resources and libraries

---

**Looking for a developer with similar skills? [Let's connect!](#-contact)**
