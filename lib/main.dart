import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managment/screens/add_todo_screen.dart';
import 'package:task_managment/screens/todo_list_screen.dart';
import 'package:task_managment/screens/onboarding_screen.dart';
import 'package:task_managment/screens/auth/login_screen.dart';
import 'package:task_managment/screens/auth/register_screen.dart';
import 'package:task_managment/screens/auth/account_created_screen.dart';
import 'package:task_managment/screens/profile_screen.dart';
import 'package:task_managment/models/todo.dart';

import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('user_data');
  final isFirstTime = prefs.getBool('first_time') ?? true;
  runApp(
    ProviderScope(
      child: MyApp(isLoggedIn: isLoggedIn, isFirstTime: isFirstTime),
    ),
  );
}

Future<void> _requestPermissions() async {
  await [Permission.location, Permission.storage].request();
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isFirstTime;
  const MyApp({super.key, required this.isLoggedIn, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: isFirstTime ? '/' : (isLoggedIn ? '/home' : '/login'),
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/account_created': (context) => const AccountCreatedScreen(),
        '/home': (context) => const TodoListScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/add': (context) {
          final todo = ModalRoute.of(context)!.settings.arguments as Todo?;
          return AddTodoScreen(todo: todo);
        },
      },
    );
  }
}
