import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BootstrapResult {
  final bool isLoggedIn;
  final bool isFirstTime;

  const BootstrapResult({
    required this.isLoggedIn,
    required this.isFirstTime,
  });
}

Future<BootstrapResult> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('user_data');
  final isFirstTime = prefs.getBool('first_time') ?? true;
  return BootstrapResult(
    isLoggedIn: isLoggedIn,
    isFirstTime: isFirstTime,
  );
}

Future<void> _requestPermissions() async {
  await [Permission.location, Permission.storage].request();
}

