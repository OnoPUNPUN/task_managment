import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import '../services/todo_service.dart';

final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(),
);

final todoServiceProvider = Provider<TodoService>((ref) => const TodoService());

final todoListProvider =
    StateNotifierProvider<TodoListNotifier, AsyncValue<List<Todo>>>(
      (ref) => TodoListNotifier(
        ref.watch(todoRepositoryProvider),
        ref.watch(todoServiceProvider),
      ),
    );

class TodoListNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoRepository _repo;
  final TodoService _service;
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  TodoListNotifier(this._repo, this._service)
    : super(const AsyncValue.loading()) {
    loadTodos(refresh: true);
  }

  Future<void> loadTodos({bool refresh = false}) async {
    if (refresh) {
      _skip = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    try {
      final todos = await _repo.fetchTodos(limit: _limit, skip: _skip);
      if (todos.length < _limit) {
        _hasMore = false;
      }

      if (refresh) {
        state = AsyncValue.data(todos);
      } else {
        state = state.whenData((current) => [...current, ...todos]);
      }
      _skip += _limit;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || state.isLoading) return;
    _isLoadingMore = true;
    await loadTodos();
    _isLoadingMore = false;
  }

  Future<void> addTodo(String text, {String status = 'To-do'}) async {
    try {
      final newTodo = await _repo.addTodo(text);
      final ids = state.value?.map((e) => e.id).toSet() ?? {};
      final adjusted = _service.prepareNewTodo(
        newTodo,
        status,
        existingIds: ids,
      );
      state = state.whenData((list) => [adjusted, ...list]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTodo(int id, String text, String status) async {
    final current = state.value ?? [];
    final idx = current.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final updatedLocal = _service.applyStatus(
      current[idx],
      text: text,
      status: status,
    );

    final next = [...current]..[idx] = updatedLocal;
    state = AsyncValue.data(next);

    try {
      await Future.wait([
        _repo.updateTodo(id, text),
        if (current[idx].completed != updatedLocal.completed)
          _repo.updateTodoStatus(id, updatedLocal.completed),
      ]);
    } catch (e) {}
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
        [...state.value!]
            .map(
              (t) => t.id == id
                  ? t.copyWith(completed: updatedRemote.completed)
                  : t,
            )
            .toList(),
      );
    } catch (e) {}
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
