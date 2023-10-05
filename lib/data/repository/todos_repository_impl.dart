import 'package:injectable/injectable.dart';
import 'package:todo_app/data/source/firestore/firestore_source.dart';
import 'package:todo_app/domain/model/enum/todo_status.dart';
import 'package:todo_app/domain/model/todo/todo.dart';
import 'package:todo_app/domain/repository/todos_repository.dart';

@Singleton(as: TodosRepository)
class TodosRepositoryImpl implements TodosRepository {
  TodosRepositoryImpl(this._firestoreSource);

  final FirestoreSource _firestoreSource;

  @override
  List<Todo>? getTodos() => _firestoreSource.todos?.map((e) => e.toDomain()).toList();

  @override
  Stream<List<Todo>?> watchTodos() => _firestoreSource.todosStream.map(
        (event) => event?.map((e) => e.toDomain()).toList(),
      );

  @override
  Future<void> updateTodoStatus({required String todoId, required TodoStatus todoStatus}) =>
      _firestoreSource.updateTodoStatus(id: todoId, status: todoStatus);

  @override
  Future<void> deleteTodo({required String todoId}) => _firestoreSource.deleteTodo(todoId);

  @override
  Future<void> createTodo({required String title, required String shortDesc, String? fullDesc}) =>
      _firestoreSource.createTodo(title: title, shortDesc: shortDesc, fullDesc: fullDesc);
}
