import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((
  ref,
) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;
  static const _userKey = 'user_data';
  static const _localCredsKey = 'local_user_creds';

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final user = User.fromJson(jsonDecode(userJson));
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authService.loginUser({
        'username': username,
        'password': password,
      });
      final user = User.fromJson(response.data);
      await _saveUser(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      // Try local login if API fails
      final localUser = await _tryLocalLogin(username, password);
      if (localUser != null) {
        await _saveUser(localUser);
        state = AsyncValue.data(localUser);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<User?> _tryLocalLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final credsJson = prefs.getString(_localCredsKey);
    if (credsJson != null) {
      final creds = jsonDecode(credsJson);
      if (creds['username'] == username && creds['password'] == password) {
        // Return the stored user object (simulated login)
        // We might need to store the full user object with credentials or just re-hydrate it.
        // For simplicity, let's store the full user object in 'local_user_data' when registering.
        final userDataJson = prefs.getString('local_user_data');
        if (userDataJson != null) {
          return User.fromJson(jsonDecode(userDataJson));
        }
      }
    }
    return null;
  }

  Future<void> register(
    String firstName,
    String lastName,
    String username,
    String password,
  ) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authService.createUser({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'password': password,
        'age': 25,
      });

      var userData = response.data;
      if (userData['token'] == null) {
        userData['token'] =
            'simulated-token-${DateTime.now().millisecondsSinceEpoch}';
      }
      // Ensure ID is unique-ish if 0 is returned or collision likely
      if (userData['id'] == null || userData['id'] == 0) {
        userData['id'] = DateTime.now().millisecondsSinceEpoch;
      }

      final user = User.fromJson(userData);
      await _saveUser(user);

      // Save local credentials for future login
      await _saveLocalCredentials(username, password, user);

      state = AsyncValue.data(user);
    } catch (e, st) {
      // Fallback to local registration if API fails
      try {
        final localUser = User(
          id: DateTime.now().millisecondsSinceEpoch,
          username: username,
          email: '$username@example.com', // Placeholder
          firstName: firstName,
          lastName: lastName,
          gender: 'unknown',
          image: '', // Default or empty
          token: 'local-token-${DateTime.now().millisecondsSinceEpoch}',
        );

        await _saveUser(localUser);
        await _saveLocalCredentials(username, password, localUser);
        state = AsyncValue.data(localUser);
      } catch (localError) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> _saveLocalCredentials(
    String username,
    String password,
    User user,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _localCredsKey,
      jsonEncode({'username': username, 'password': password}),
    );
    await prefs.setString('local_user_data', jsonEncode(user.toJson()));
  }

  Future<void> updateProfile(
    String firstName,
    String lastName,
    String? imagePath,
  ) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    try {
      final updatedUser = currentUser.copyWith(
        firstName: firstName,
        lastName: lastName,
        image: imagePath ?? currentUser.image,
      );

      await _saveUser(updatedUser);
      // Also update local user data if this is the local user
      final prefs = await SharedPreferences.getInstance();
      final localData = prefs.getString('local_user_data');
      if (localData != null) {
        final localUser = User.fromJson(jsonDecode(localData));
        if (localUser.id == updatedUser.id) {
          await prefs.setString(
            'local_user_data',
            jsonEncode(updatedUser.toJson()),
          );
        }
      }

      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    state = const AsyncValue.data(null);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
