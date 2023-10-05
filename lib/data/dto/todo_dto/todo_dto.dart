import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/data/dto/converters/date_time_converter.dart';
import 'package:todo_app/domain/model/todo/todo.dart';

import '../../../domain/model/enum/todo_status.dart';

part 'todo_dto.freezed.dart';
part 'todo_dto.g.dart';

@freezed
class TodoDto with _$TodoDto {
  const factory TodoDto({
    required String id,
    required String title,
    required String shortDescription,
    String? fullDescription,
    required TodoStatus status,
    @DateTimeConverter() required DateTime createdAt,
  }) = _TodoDto;

  const TodoDto._();

  Todo toDomain() => Todo(
        id: id,
        title: title,
        shortDescription: shortDescription,
        fullDescription: fullDescription,
        status: status,
        createdAt: createdAt,
      );

  factory TodoDto.fromDomain(Todo object) => TodoDto(
        id: object.id,
        title: object.title,
        shortDescription: object.shortDescription,
        fullDescription: object.fullDescription,
        status: object.status,
        createdAt: object.createdAt,
      );

  factory TodoDto.fromJson(Map<String, Object?> json) => _$TodoDtoFromJson(json);
}
