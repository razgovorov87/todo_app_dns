import 'package:todo_app/domain/model/enum/todo_status.dart';
import 'package:todo_app/domain/model/todo/todo.dart';

abstract class TodosRepository {
  Stream<List<Todo>?> watchTodos();

  List<Todo>? getTodos();

  Future<void> createTodo({
    required String title,
    required String shortDesc,
    String? fullDesc,
  });

  Future<void> updateTodoStatus({
    required String todoId,
    required TodoStatus todoStatus,
  });

  Future<void> deleteTodo({required String todoId});
}
