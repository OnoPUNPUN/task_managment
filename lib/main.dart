import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managment/screens/add_todo_screen.dart';
import 'package:task_managment/screens/todo_list_screen.dart';
import 'package:task_managment/screens/onboarding_screen.dart';
import 'package:task_managment/models/todo.dart';

import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _requestPermissions() async {
  await [Permission.location, Permission.storage].request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
      routes: {
        '/home': (context) => const TodoListScreen(),
        '/add': (context) {
          final todo = ModalRoute.of(context)!.settings.arguments as Todo?;
          return AddTodoScreen(todo: todo);
        },
      },
    );
  }
}
