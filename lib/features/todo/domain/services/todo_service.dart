import 'package:task_managment/features/todo/domain/entities/todo.dart';

class TodoService {
  const TodoService();

  Todo prepareNewTodo(
    Todo todo,
    String status, {
    required Set<int> existingIds,
  }) {
    final completed = _isCompletedStatus(status);
    var nextId = todo.id;

    if (status == 'In Progress' && nextId.isOdd) {
      nextId++;
    } else if (status == 'To-do' && nextId.isEven) {
      nextId++;
    }

    while (existingIds.contains(nextId)) {
      nextId += 2;
    }

    return todo.copyWith(id: nextId, completed: completed);
  }

  Todo applyStatus(Todo todo, {String? text, required String status}) {
    return todo.copyWith(
      todo: text ?? todo.todo,
      completed: _isCompletedStatus(status),
    );
  }

  String deriveCategoryFromTodo(Todo todo) {
    if (todo.completed) return 'Completed';
    return todo.id.isEven ? 'In Progress' : 'To-do';
  }

  List<Todo> filterTodos(List<Todo> list, String filterLabel) {
    if (filterLabel == 'All') return list;
    if (filterLabel == 'Completed') {
      return list.where((t) => t.completed).toList();
    }
    if (filterLabel == 'To do') {
      return list.where((t) => !t.completed && t.id.isOdd).toList();
    }
    if (filterLabel == 'In Progress') {
      return list.where((t) => !t.completed && t.id.isEven).toList();
    }
    return list;
  }

  bool _isCompletedStatus(String status) => status == 'Completed';
}
