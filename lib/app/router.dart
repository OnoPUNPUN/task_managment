import 'package:flutter/material.dart';
import 'package:task_managment/features/todo/domain/entities/todo.dart';
import 'package:task_managment/features/todo/presentation/screens/add_todo_screen.dart';
import 'package:task_managment/features/todo/presentation/screens/todo_list_screen.dart';
import 'package:task_managment/screens/auth/account_created_screen.dart';
import 'package:task_managment/screens/auth/login_screen.dart';
import 'package:task_managment/screens/auth/register_screen.dart';
import 'package:task_managment/screens/onboarding_screen.dart';
import 'package:task_managment/screens/profile_screen.dart';

class AppRoutes {
  static const onboarding = '/';
  static const login = '/login';
  static const register = '/register';
  static const accountCreated = '/account_created';
  static const home = '/home';
  static const profile = '/profile';
  static const addTodo = '/add';
}

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.onboarding: (_) => const OnboardingScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),
    AppRoutes.accountCreated: (_) => const AccountCreatedScreen(),
    AppRoutes.home: (_) => const TodoListScreen(),
    AppRoutes.profile: (_) => const ProfileScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.addTodo:
        final todo = settings.arguments as Todo?;
        return MaterialPageRoute(
          builder: (_) => AddTodoScreen(todo: todo),
          settings: settings,
        );
    }
    return null;
  }
}

