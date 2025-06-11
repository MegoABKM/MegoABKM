# 🛍️ E-commerce Platform - Flutter & PHP

Welcome to the official repository for a feature-rich, multi-store e-commerce application built with Flutter for the frontend and a powerful PHP/MySQL backend. This platform provides a seamless and modern shopping experience for users and a robust management system for vendors.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![PHP](https://img.shields.io/badge/PHP-8.x-777BB4?style=for-the-badge&logo=php)](https://www.php.net)
[![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?style=for-the-badge&logo=mysql)](https://www.mysql.com)

## ✨ Core Features

This is more than just a simple shop. It's a comprehensive platform designed to scale, with a focus on user experience and powerful backend capabilities.

---

### 👤 User-Facing Features

*   **Multi-Store Support**: Browse and shop from a wide variety of stores, each with its own unique set of products.
*   **Intuitive Product Discovery**:
    *   Dynamic home screen with featured products and categories.
    *   Powerful real-time search functionality to find products instantly.
    *   Filter and browse products by category.
*   **Favorites System**: Users can save their favorite items for later, creating a personalized wishlist accessible at any time.
*   **Advanced Location Management**:
    *   **Interactive Map Integration**: Users can precisely select their delivery address by tapping on an interactive map.
    *   **Geolocation & Address Saving**: Automatically fetches street and city data from map coordinates and allows users to save multiple addresses for quick checkout.
    *   **Edit & Delete Addresses**: Full CRUD (Create, Read, Update, Delete) functionality for saved shipping locations.
*   **Seamless Cart & Checkout**:
    *   A persistent and easy-to-manage shopping cart.
    *   Coupon code support for applying discounts.
    *   Multiple payment method options (Cash on Delivery, Card Payments).
    *   Choice of delivery type (Home Delivery or In-Store Pickup).
*   **Order Tracking**: Users can view their pending and archived orders, check their status, and see full order details, including a map view of the delivery address.
*   **Notifications**: Receive real-time updates on order status and other important events.
*   **Multi-Language Support**: Fully localized interface supporting both English and Arabic.

<p align="center">
  <img src="https://via.placeholder.com/250x500.png?text=Login+Screen" alt="Login Screen" hspace="10">
  <img src="https://via.placeholder.com/250x500.png?text=Home+Screen" alt="Home Screen" hspace="10">
  <img src="https://via.placeholder.com/250x500.png?text=Product+Details" alt="Product Details Screen" hspace="10">
</p>
<p align="center">
  <img src="https://via.placeholder.com/250x500.png?text=Add+Address+Map" alt="Address Map Screen" hspace="10">
  <img src="https://via.placeholder.com/250x500.png?text=Checkout+Screen" alt="Checkout Screen" hspace="10">
  <img src="https://via.placeholder.com/250x500.png?text=Orders+Screen" alt="Orders Screen" hspace="10">
</p>

> **Note:** Replace the placeholder image URLs above with direct links to your actual app screenshots once you have them uploaded.

---

### 🛠️ Technology Stack

This project leverages a modern and reliable technology stack to ensure performance and scalability.

*   **Frontend (Mobile App)**:
    *   **[Flutter](https://flutter.dev/)**: For building a beautiful, natively compiled, and cross-platform mobile application from a single codebase.
    *   **[GetX](https://pub.dev/packages/get)**: For powerful state management, dependency injection, and route management.
*   **Backend (Server-Side)**:
    *   **[PHP](https://www.php.net/)**: As the server-side language for handling business logic, API requests, and database interactions.
    *   **[MySQL](https://www.mysql.com/)**: A robust relational database for storing user data, products, orders, and more.
*   **APIs & Services**:
    *   **REST API**: Custom-built RESTful API to facilitate communication between the Flutter app and the PHP backend.
    *   **OpenStreetMap**: For providing the interactive map tiles.
    *   **Geocoding Services**: To reverse-engineer coordinates into street and city names.

---

## 🚀 Future Roadmap & Vision

The journey doesn't end here! The platform is designed to evolve. Here are some of the exciting features planned for the future:

*   **🛵 Delivery Driver App**:
    *   A dedicated Flutter application for delivery personnel.
    *   Features will include order acceptance, route optimization on a map, and status updates upon delivery.
*   **🏪 Vendor/Store Dashboard**:
    *   A web-based or mobile application for store owners to manage their products, view orders, and track sales analytics.
*   **Advanced Analytics**:
    *   Deeper insights into sales trends, popular products, and customer behavior.
*   **In-App Chat**:
    *   Direct communication channel between customers and store owners or customer support.
*   **Enhanced Notifications**:
    *   Push notifications for promotions, back-in-stock items, and abandoned carts.

---

## 🔧 Setup & Installation

Instructions for setting up the backend and running the Flutter application will be added here soon.

1.  **Backend Setup**:
    *   Clone the repository.
    *   Set up a local server environment (e.g., XAMPP, WAMP).
    *   Import the `database.sql` file into your MySQL database.
    *   Configure the database connection details in `connect.php`.
2.  **Flutter App Setup**:
    *   Navigate to the `Ecommrence` directory.
    *   Run `flutter pub get` to install dependencies.
    *   Update the API endpoint URL in the app's configuration file.
    *   Run `flutter run` to launch the app on your emulator or physical device.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/MegoABKM/MyProjects/issues) if you want to contribute.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
