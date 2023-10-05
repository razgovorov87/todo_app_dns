import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/domain/model/enum/todo_status.dart';

part 'todo.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required String shortDescription,
    @Default(TodoStatus.created) TodoStatus status,
    String? fullDescription,
    required DateTime createdAt,
  }) = _Todo;
}
