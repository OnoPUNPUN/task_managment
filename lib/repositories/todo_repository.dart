import '../core/api_client.dart';
import '../core/exceptions.dart';
import '../models/todo.dart';

// This is my Area 🩻🩻
class TodoRepository {
  final ApiClient _client = ApiClient();

  Future<List<Todo>> fetchTodos({int limit = 0, int skip = 0}) async {
    try {
      final res = await _client.get(
        '/todos',
        queryParameters: {
          if (limit > 0) 'limit': limit,
          if (skip > 0) 'skip': skip,
        },
      );
      final data = res.data as Map<String, dynamic>;
      final List items = data['todos'] as List;
      return items
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Todo> addTodo(String text, {int userId = 5}) async {
    try {
      final res = await _client.post(
        '/todos/add',
        data: {'todo': text, 'completed': false, 'userId': userId},
      );
      return Todo.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Todo> updateTodoStatus(int id, bool completed) async {
    try {
      final res = await _client.put(
        '/todos/$id',
        data: {'completed': completed},
      );
      return Todo.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _client.delete('/todos/$id');
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
