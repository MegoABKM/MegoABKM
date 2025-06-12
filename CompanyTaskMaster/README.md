# CompanyTaskMaster 🏢

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Language: Dart](https://img.shields.io/badge/Language-Dart-blue.svg?logo=dart)
![Framework: Flutter](https://img.shields.io/badge/Framework-Flutter-02569B.svg?logo=flutter)
![Backend: PHP](https://img.shields.io/badge/Backend-PHP-777BB4.svg?logo=php)
![Database: MySQL](https://img.shields.io/badge/Database-MySQL-blue.svg?logo=mysql)

A comprehensive and feature-rich task management application designed for companies and teams. Built with a powerful PHP/MySQL backend and a beautiful, responsive Flutter frontend, CompanyTaskMaster helps streamline workflow, enhance collaboration, and boost productivity.

## ✨ Key Features & Screenshots

*(**Action Required:** Replace the placeholder links below with actual screenshots of your app! Upload your screenshots to the GitHub repository and get their links.)*

<table>
  <tr>
    <td align="center"><strong>Login & Sign Up</strong></td>
    <td align="center"><strong>Manager Dashboard</strong></td>
    <td align="center"><strong>Task Details View</strong></td>
    <td align="center"><strong>Employee & Team View</strong></td>
  </tr>
  <tr>
    <td><img src="https://via.placeholder.com/200x400.png?text=Login+Screen" alt="Login Screen" width="200"/></td>
    <td><img src="https://via.placeholder.com/200x400.png?text=Dashboard" alt="Manager Dashboard" width="200"/></td>
    <td><img src="https://via.placeholder.com/200x400.png?text=Task+Details" alt="Task Details" width="200"/></td>
    <td><img src="https://via.placeholder.com/200x400.png?text=Team+View" alt="Employee List" width="200"/></td>
  </tr>
</table>

### 👑 For Managers
*   🏢 **Company Management:** Easily create and configure your company profile.
*   👥 **Employee Management:** Add new employees to the company and modify their details and roles.
*   ✅ **Task Assignment:** Assign tasks to specific employees or broadcast them to the entire team.
*   📊 **Project Oversight:** Monitor task progress, deadlines, and team workload from a central dashboard.

### 👨‍💻 For Employees
*   🔐 **Secure Authentication:** Simple and secure login and sign-in process.
*   📝 **Task Handling:** View assigned tasks, update their status, and mark them as complete.
*   🔗 **Attachments & Subtasks:** Attach relevant files and break down complex tasks into smaller, manageable subtasks.
*   🖼️ **Profile Management:** View profiles of your workmates and update your own profile picture and information.

### 🚀 General & Core Features
*   📅 **Detailed Task Information:** Each task includes a start date, end date, priority level, and detailed description.
*   ✍️ **Offline Personal Notes & Tasks:** A dedicated section for users to jot down personal notes or create private to-do lists that work completely offline.
*   🌐 **Multi-Language Support:** Fully functional in both **English** and **Arabic**, with a seamless language-switching experience.
*   🎨 **Attractive & Intuitive UI:** A clean, modern, and user-friendly interface designed with Flutter to provide a smooth experience on both iOS and Android.

## 🛠️ Tech Stack

| Frontend (Mobile App) | Backend (API) | Database |
| :--- |:--- |:--- |
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) | ![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white) | ![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white) |
| ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white) | | |

## ⚙️ Getting Started

### Prerequisites
*   Flutter SDK
*   A local web server (like XAMPP, WAMP, or MAMP) with PHP
*   MySQL Database

### Backend Setup
1.  Clone the repository: `git clone https://github.com/MegoABKM/MyProjects.git`
2.  Navigate to the `CompanyTaskMaster/Backend` folder.
3.  Import the `database.sql` file into your MySQL database (e.g., via phpMyAdmin).
4.  Configure your database connection details in the `config.php` (or equivalent) file.
5.  Place the `Backend` folder in your web server's root directory (e.g., `htdocs` for XAMPP).

### Frontend (Flutter App) Setup
1.  Navigate to the `CompanyTaskMaster/` folder (the root of the Flutter project).
2.  Update the API base URL in the configuration file (e.g., `lib/core/constants.dart`) to point to your local server's address.
3.  Run `flutter pub get` to install dependencies.
4.  Connect a device or emulator and run `flutter run`.

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the `LICENSE` file for details.
