import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managment/app/app.dart';
import 'package:task_managment/app/bootstrap.dart';

void main() async {
  final bootstrapResult = await bootstrapApp();
  runApp(
    ProviderScope(
      child: TaskManagementApp(bootstrapResult: bootstrapResult),
    ),
  );
}
