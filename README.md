# 📝 Task Management & To-Do List

A modern, intuitive task management application built with Flutter that helps you organize your daily tasks and boost productivity.

## 🎯 About The Project

This productive tool is designed to help you better manage your tasks project-wise conveniently! The app features a clean, user-friendly interface with smooth animations and an organized workflow that makes task management effortless.

### ✨ Key Features

- **Authentication System** - Secure login and registration with local storage
- **User Profile Management** - Edit profile with avatar upload, name, and password changes
- **Dark Mode Support** - Switch between light and dark themes
- **Task Organization** - Categorize tasks with different status labels (To-do, In Progress, Completed)
- **Calendar Integration** - View and manage tasks by date
- **Task Categories** - Organize tasks with icons and visual indicators
- **Real-time Updates** - See task creation time and status updates
- **Easy Task Management** - Add, edit, and delete tasks with simple gestures

## 📸 Screenshots

### Authentication & Onboarding
<div align="center">
  <img src="screenshots/s1.png" width="250" alt="Onboarding Screen"/>
  <img src="screenshots/s6.png" width="250" alt="Login Screen"/>
  <img src="screenshots/s7.png" width="250" alt="Register Screen"/>
</div>

### Task Management
<div align="center">
  <img src="screenshots/s2.png" width="250" alt="Dashboard"/>
  <img src="screenshots/s3.png" width="250" alt="Add Task"/>
  <img src="screenshots/s4.png" width="250" alt="Task Options"/>
</div>

### Profile & Settings
<div align="center">
  <img src="screenshots/s8.png" width="250" alt="Account Created"/>
  <img src="screenshots/s9.png" width="250" alt="Edit Profile"/>
  <img src="screenshots/s5.png" width="250" alt="Edit Task"/>
</div>

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **Architecture:** Clean Architecture with Provider/Riverpod pattern
- **State Management:** Provider
- **Local Storage:** Shared Preferences (for authentication and user data)
- **Authentication:** Local authentication system

## 📁 Project Structure

```
lib/
├── app/
│   ├── app.dart
│   ├── bootstrap.dart
│   └── router.dart
├── constants/
│   └── todo_categories.dart
├── core/
│   ├── api_client.dart
│   └── exceptions.dart
├── features/
│   └── todo/
│       ├── data/
│       │   └── repositories/
│       │       └── todo_repository.dart
│       ├── domain/
│       │   ├── constants/
│       │   │   └── todo_categories.dart
│       │   ├── entities/
│       │   │   └── todo.dart
│       │   ├── services/
│       │   │   └── todo_service.dart
│       │   └── utils/
│       │       └── app_date_utils.dart
│       └── presentation/
│           ├── providers/
│           │   └── todo_provider.dart
│           ├── screens/
│           │   ├── add_todo_screen.dart
│           │   └── todo_list_screen.dart
│           └── widgets/
│               └── todo_card.dart
├── models/
│   └── user.dart
├── providers/
│   ├── auth_provider.dart
│   └── theme_provider.dart
├── repositories/
│   └── screens/
│       └── auth/
│           ├── account_created_screen.dart
│           ├── login_screen.dart
│           ├── register_screen.dart
│           ├── onboarding_screen.dart
│           └── profile_screen.dart
├── services/
│   └── auth_service.dart
├── utils/
│   └── widgets/
│       ├── app_bottom_button.dart
│       ├── avatar_header.dart
│       ├── custom_snackbar.dart
│       ├── date_chip.dart
│       ├── filter_chip.dart
│       ├── loading.dart
│       ├── app_theme.dart
│       └── main.dart
```

## 🌿 Branches

- `main` - Production-ready code
- `onboarding_screen` - Onboarding screen implementation
- `dashboard` - Main dashboard and task list features
- `add_Todo` - Task creation and editing functionality
- `auth` - Authentication system with login/register

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. Clone the repository
```bash
git clone https://github.com/OnoPUNPUN/task_managment.git
```

2. Navigate to project directory
```bash
cd task_managment
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## 📱 Features in Detail

### Authentication System
- Secure login with username and password
- User registration with form validation
- Account creation confirmation screen
- Local authentication storage
- Session management

### User Profile Management
- Edit personal information (First Name, Last Name)
- Change username
- Update password with confirmation
- Avatar/profile picture upload
- Dark mode toggle in profile settings

### Onboarding Experience
- Welcoming screen with engaging 3D illustration
- Clear value proposition
- Smooth transition to login/register

### Dashboard
- Calendar view for date-based task filtering
- Status filter tabs (All, To-do, In Progress, Completed)
- Task cards with icons and timestamps
- User profile section

### Task Management
- Quick task creation with categorization
- Edit existing tasks
- Delete tasks with confirmation
- Status updates with visual feedback

## 🎨 Design Highlights

- **Modern UI** - Clean, minimalist design with rounded corners
- **Vibrant Colors** - Purple accent color (#6C5CE7) for primary actions
- **Intuitive Icons** - Category-specific icons for visual organization
- **Smooth Animations** - Subtle transitions and interactions
- **Responsive Layout** - Adapts to different screen sizes

## 👤 Author

**PUNPUN**

GitHub: [@OnoPUNPUN](https://github.com/OnoPUNPUN)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/OnoPUNPUN/task_managment/issues).

---

<div align="center">
  Made with ❤️ using Flutter
</div>