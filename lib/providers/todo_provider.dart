import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';

final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(),
);

final todoListProvider =
    StateNotifierProvider<TodoListNotifier, AsyncValue<List<Todo>>>(
      (ref) => TodoListNotifier(ref.watch(todoRepositoryProvider)),
    );

class TodoListNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoRepository _repo;
  TodoListNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadTodos();
  }

  Future<void> loadTodos({int limit = 0}) async {
    try {
      state = const AsyncValue.loading();
      final todos = await _repo.fetchTodos(limit: limit);
      state = AsyncValue.data(todos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTodo(String text) async {
    try {
      final newTodo = await _repo.addTodo(text);
      state = state.whenData((list) => [newTodo, ...list]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleCompleted(int id) async {
    final current = state.value ?? [];
    final idx = current.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final updatedLocal = current[idx].copyWith(
      completed: !current[idx].completed,
    );

    final next = [...current]..[idx] = updatedLocal;
    state = AsyncValue.data(next);
    try {
      final updatedRemote = await _repo.updateTodoStatus(
        id,
        updatedLocal.completed,
      );
      state = AsyncValue.data(
        [...state.value!].map((t) => t.id == id ? updatedRemote : t).toList(),
      );
    } catch (e) {
      await loadTodos();
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _repo.deleteTodo(id);
      state = state.whenData((list) => list.where((t) => t.id != id).toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
