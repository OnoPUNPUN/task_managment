import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TodoCategoryConfig {
  final String name;
  final IconData icon;
  final Color color;
  final Color background;

  const TodoCategoryConfig({
    required this.name,
    required this.icon,
    required this.color,
    required this.background,
  });
}

const todoCategories = [
  TodoCategoryConfig(
    name: 'To-do',
    icon: Iconsax.clipboard_text,
    color: Color(0xFF0085FF),
    background: Color(0xFFE6F2FF),
  ),
  TodoCategoryConfig(
    name: 'In Progress',
    icon: Iconsax.clock,
    color: Color(0xFFFF7D53),
    background: Color(0xFFFFEFEB),
  ),
  TodoCategoryConfig(
    name: 'Completed',
    icon: Iconsax.tick_circle,
    color: Color(0xFF6E3BFF),
    background: Color(0xFFEBE5FF),
  ),
];

TodoCategoryConfig categoryByName(String name) {
  return todoCategories.firstWhere(
    (c) => c.name == name,
    orElse: () => todoCategories.first,
  );
}

