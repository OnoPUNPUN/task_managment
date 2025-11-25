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
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  TodoListNotifier(this._repo) : super(const AsyncValue.loading()) {
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
      // 1. Add to API (always returns random/sequential ID we can't control easily)
      // We send completed=true if status is Completed, else false.
      final isCompleted = status == 'Completed';
      var newTodo = await _repo.addTodo(text); // API call

      // 2. Hack ID locally to match our filter logic
      // Filter Logic:
      // To-do: !completed && ID odd
      // In Progress: !completed && ID even

      int newId = newTodo.id;
      if (status == 'In Progress') {
        // Need even ID
        if (newId % 2 != 0) newId++;
      } else if (status == 'To-do') {
        // Need odd ID
        if (newId % 2 == 0) newId++;
      }

      // Ensure uniqueness if possible (simple hack, might collide but ok for demo)
      // A better way is to find a safe ID from the current list
      final currentIds = state.value?.map((e) => e.id).toSet() ?? {};
      while (currentIds.contains(newId)) {
        newId += 2; // Keep parity
      }

      newTodo = newTodo.copyWith(id: newId, completed: isCompleted);

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
      // We keep our local ID hack, just update status
      state = AsyncValue.data(
        [...state.value!]
            .map(
              (t) => t.id == id
                  ? t.copyWith(completed: updatedRemote.completed)
                  : t,
            )
            .toList(),
      );
    } catch (e) {
      // Revert on error or reload
      // await loadTodos(refresh: true);
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
