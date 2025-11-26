import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managment/features/todo/data/repositories/todo_repository.dart';
import 'package:task_managment/features/todo/domain/entities/todo.dart';
import 'package:task_managment/features/todo/domain/services/todo_service.dart';
import 'package:task_managment/providers/auth_provider.dart';

final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(),
);

final todoServiceProvider = Provider<TodoService>((ref) => const TodoService());

final todoListProvider =
    StateNotifierProvider<TodoListNotifier, AsyncValue<List<Todo>>>((ref) {
      final authState = ref.watch(authProvider);
      final user = authState.value;
      return TodoListNotifier(
        ref.watch(todoRepositoryProvider),
        ref.watch(todoServiceProvider),
        userId: user?.id,
        token: user?.token,
        onLogout: () => ref.read(authProvider.notifier).logout(),
      );
    });

class TodoListNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoRepository _repo;
  final TodoService _service;
  final int? userId;
  final String? token;
  final VoidCallback? onLogout;
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  TodoListNotifier(
    this._repo,
    this._service, {
    this.userId,
    this.token,
    this.onLogout,
  }) : super(const AsyncValue.loading()) {
    loadTodos(refresh: true);
  }

  Future<void> loadTodos({bool refresh = false}) async {
    if (refresh) {
      _skip = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    try {
      final todos = await _repo.fetchTodos(
        limit: _limit,
        skip: _skip,
        userId: userId,
        token: token,
      );
      if (todos.length < _limit) {
        _hasMore = false;
      }

      if (refresh) {
        if (!mounted) return;
        state = AsyncValue.data(todos);
      } else {
        if (!mounted) return;
        state = state.whenData((current) => [...current, ...todos]);
      }
      _skip += _limit;
    } catch (e, st) {
      if (!mounted) return;
      _checkAuthError(e);
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
    final effectiveUserId = userId ?? 5;

    try {
      final newTodo = await _repo.addTodo(
        text,
        userId: effectiveUserId,
        token: token,
      );
      final ids = state.value?.map((e) => e.id).toSet() ?? {};
      final adjusted = _service.prepareNewTodo(
        newTodo,
        status,
        existingIds: ids,
      );
      if (!mounted) return;
      state = state.whenData((list) => [adjusted, ...list]);
    } catch (e, st) {
      if (!mounted) return;
      _checkAuthError(e);
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
        _repo.updateTodo(id, text, token: token),
        if (current[idx].completed != updatedLocal.completed)
          _repo.updateTodoStatus(id, updatedLocal.completed, token: token),
      ]);
    } catch (e) {
      _checkAuthError(e);
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
        token: token,
      );
      if (!mounted) return;
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
      if (!mounted) return;
      _checkAuthError(e);
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _repo.deleteTodo(id, token: token);
      if (!mounted) return;
      state = state.whenData((list) => list.where((t) => t.id != id).toList());
    } catch (e, st) {
      if (!mounted) return;
      _checkAuthError(e);
      state = AsyncValue.error(e, st);
    }
  }

  void _checkAuthError(Object error) {
    if (error.toString().contains('401')) {
      onLogout?.call();
    }
  }
}
