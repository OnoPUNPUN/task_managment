import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF6E3BFF),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    bodyMedium: TextStyle(fontSize: 14),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF6E3BFF),
  useMaterial3: true,
);
