import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/domain/model/enum/todo_status.dart';
import 'package:todo_app/domain/repository/todos_repository.dart';

part 'update_todo_bloc.freezed.dart';

@injectable
class UpdateTodoBloc extends Bloc<UpdateTodoEvent, UpdateTodoState> {
  UpdateTodoBloc(
    this._todosRepository,
    @factoryParam this.todoId,
  ) : super(const UpdateTodoState.initial()) {
    on<UpdateTodoEvent>(_onEvent);
  }

  final String? todoId;
  final TodosRepository _todosRepository;

  FutureOr<void> _onEvent(UpdateTodoEvent mainEvent, Emitter<UpdateTodoState> emit) => mainEvent.map(
        updateStatus: (_Update event) => _mapUpdateToState(event, emit),
        delete: (_Delete event) => _mapDeleteToState(event, emit),
      );

  Future<void> _mapUpdateToState(_Update event, Emitter<UpdateTodoState> emit) async {
    if (todoId == null) {
      emit(const UpdateTodoState.error('Идентификатор задачи не найден'));
      return;
    }

    emit(const UpdateTodoState.waiting());
    try {
      final newStatus = event.status;

      await _todosRepository.updateTodoStatus(todoId: todoId!, todoStatus: newStatus);

      emit(const UpdateTodoState.success());
    } catch (e) {
      emit(UpdateTodoState.error(e.toString()));
    }
  }

  Future<void> _mapDeleteToState(_Delete event, Emitter<UpdateTodoState> emit) async {
    if (todoId == null) {
      emit(const UpdateTodoState.error('Идентификатор задачи не найден'));
      return;
    }

    emit(const UpdateTodoState.waiting());
    try {
      await _todosRepository.deleteTodo(todoId: todoId!);

      emit(const UpdateTodoState.success());
    } catch (e) {
      emit(UpdateTodoState.error(e.toString()));
    }
  }
}

@freezed
class UpdateTodoEvent with _$UpdateTodoEvent {
  const factory UpdateTodoEvent.updateStatus({required TodoStatus status}) = _Update;

  const factory UpdateTodoEvent.delete() = _Delete;
}

@freezed
class UpdateTodoState with _$UpdateTodoState {
  const factory UpdateTodoState.initial() = _Initial;

  const factory UpdateTodoState.waiting() = _Waiting;

  const factory UpdateTodoState.success() = _Success;

  const factory UpdateTodoState.error(String message) = _Error;
}
