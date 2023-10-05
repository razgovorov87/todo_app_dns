import 'package:todo_app/domain/model/enum/todo_status.dart';
import 'package:todo_app/domain/model/todo/todo.dart';

extension TodosExtenstion on List<Todo>? {
  Map<TodoStatus, List<Todo>> getSortedMapByStatus() {
    final map = <TodoStatus, List<Todo>>{};
    if (this == null) return map;

    for (final status in TodoStatus.values) {
      final todos = this!.where((element) => element.status == status).toList();
      todos.sort((a, b) => b.createdAt.compareTo(b.createdAt));
      map[status] = todos;
    }

    return map;
  }
}
