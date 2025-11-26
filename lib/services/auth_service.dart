import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://dummyjson.com';

  AuthService() {
    // Ignore SSL certificate errors
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Response> createUser(Map<String, dynamic> userData) async {
    try {
      return await _dio.post(
        '$_baseUrl/users/add',
        data: userData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> loginUser(Map<String, dynamic> credentials) async {
    try {
      return await _dio.post(
        '$_baseUrl/user/login',
        data: credentials,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCurrentUser(String token) async {
    try {
      return await _dio.get(
        '$_baseUrl/user/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateUser(String id, Map<String, dynamic> userData) async {
    try {
      return await _dio.put(
        '$_baseUrl/users/$id',
        data: userData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteUser(String id) async {
    try {
      return await _dio.delete('$_baseUrl/users/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getUserTodos(String id) async {
    try {
      return await _dio.get('$_baseUrl/users/$id/todos');
    } catch (e) {
      rethrow;
    }
  }
}
