import 'package:flutter/material.dart';

final _lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6E3BFF),
  brightness: Brightness.light,
  background: const Color(0xFFF3F8FF),
  surface: Colors.white,
);

final _darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6E3BFF),
  brightness: Brightness.dark,
  background: const Color(0xFF0F1115),
  surface: const Color(0xFF1C1F26),
);

final lightTheme = ThemeData(
  colorScheme: _lightColorScheme,
  scaffoldBackgroundColor: _lightColorScheme.background,
  cardColor: Colors.white,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    bodyMedium: TextStyle(fontSize: 14),
  ),
  useMaterial3: true,
);

final darkTheme = ThemeData(
  colorScheme: _darkColorScheme,
  scaffoldBackgroundColor: _darkColorScheme.background,
  cardColor: _darkColorScheme.surface,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    bodyMedium: TextStyle(fontSize: 14),
  ),
  useMaterial3: true,
);
