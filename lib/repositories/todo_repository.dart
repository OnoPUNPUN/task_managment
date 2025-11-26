import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/exceptions.dart';
import '../models/todo.dart';

class TodoRepository {
  final ApiClient _client = ApiClient();

  Future<List<Todo>> fetchTodos({
    int limit = 0,
    int skip = 0,
    int?
    userId, // Kept for signature compatibility but ignored for endpoint selection
    String? token,
  }) async {
    try {
      // ALWAYS use the generic endpoint as requested
      const endpoint = '/todos';
      final res = await _client.get(
        endpoint,
        queryParameters: {
          if (limit > 0) 'limit': limit,
          if (skip > 0) 'skip': skip,
        },
        // Token is optional for generic public API but we keep it if passed
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      final data = res.data as Map<String, dynamic>;
      final List items = data['todos'] as List;
      return items
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return [];
      }
      throw ApiException(e.toString());
    }
  }

  Future<Todo> addTodo(
    String text, {
    required int userId,
    String? token,
  }) async {
    try {
      final res = await _client.post(
        '/todos/add',
        // Use the passed userId, or default to 5 if 0/null (though required int implies value)
        data: {'todo': text, 'completed': false, 'userId': userId},
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return Todo.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Todo> updateTodo(int id, String text, {String? token}) async {
    try {
      final res = await _client.put(
        '/todos/$id',
        data: {'todo': text},
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return Todo.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Todo> updateTodoStatus(int id, bool completed, {String? token}) async {
    try {
      final res = await _client.put(
        '/todos/$id',
        data: {'completed': completed},
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return Todo.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteTodo(int id, {String? token}) async {
    try {
      await _client.delete(
        '/todos/$id',
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
