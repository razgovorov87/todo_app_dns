import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/domain/repository/todos_repository.dart';

part 'create_new_todo_bloc.freezed.dart';

@injectable
class CreateNewTodoBloc extends Bloc<CreateNewTodoEvent, CreateNewTodoState> {
  CreateNewTodoBloc(
    this._todosRepository,
  ) : super(const CreateNewTodoState.initial()) {
    on<CreateNewTodoEvent>(_onEvent);
  }

  final TodosRepository _todosRepository;

  FutureOr<void> _onEvent(CreateNewTodoEvent mainEvent, Emitter<CreateNewTodoState> emit) => mainEvent.map(
        create: (_Create event) => _mapCreateToState(event, emit),
      );

  Future<void> _mapCreateToState(_Create event, Emitter<CreateNewTodoState> emit) async {
    emit(const CreateNewTodoState.waiting());
    try {
      final title = event.title;
      final shortDesc = event.shortDesc;
      final fullDesc = event.fullDesc;

      if (title.isEmpty || shortDesc.isEmpty) {
        emit(const CreateNewTodoState.error('Введите название и короткое описание'));
        return;
      }

      await _todosRepository.createTodo(title: title, shortDesc: shortDesc, fullDesc: fullDesc);
      emit(const CreateNewTodoState.success());
    } catch (e) {
      emit(CreateNewTodoState.error(e.toString()));
    }
  }
}

@freezed
class CreateNewTodoEvent with _$CreateNewTodoEvent {
  const factory CreateNewTodoEvent.create({
    required String title,
    required String shortDesc,
    String? fullDesc,
  }) = _Create;
}

@freezed
class CreateNewTodoState with _$CreateNewTodoState {
  const factory CreateNewTodoState.initial() = _Initial;

  const factory CreateNewTodoState.waiting() = _Waiting;

  const factory CreateNewTodoState.success() = _Success;

  const factory CreateNewTodoState.error(String message) = _Error;
}
