import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managment/app/bootstrap.dart';
import 'package:task_managment/app/router.dart';
import 'package:task_managment/app_theme.dart';
import 'package:task_managment/providers/theme_provider.dart';

class TaskManagementApp extends ConsumerWidget {
  final BootstrapResult bootstrapResult;

  const TaskManagementApp({
    super.key,
    required this.bootstrapResult,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      initialRoute: bootstrapResult.isFirstTime
          ? AppRoutes.onboarding
          : (bootstrapResult.isLoggedIn
              ? AppRoutes.home
              : AppRoutes.login),
      routes: AppRouter.routes,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

