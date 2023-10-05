import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/domain/extension/todos_extension.dart';
import 'package:todo_app/domain/model/enum/todo_status.dart';
import 'package:todo_app/domain/model/todo/todo.dart';
import 'package:todo_app/domain/repository/todos_repository.dart';

@injectable
class TodosMapCubit extends Cubit<Map<TodoStatus, List<Todo>>> {
  TodosMapCubit(
    this._todosRepository,
  ) : super(_todosRepository.getTodos().getSortedMapByStatus()) {
    _streamSubscription = _todosRepository.watchTodos().listen(
      (List<Todo>? list) {
        emit(list.getSortedMapByStatus());
      },
    );
  }

  late final StreamSubscription<List<Todo>?> _streamSubscription;
  final TodosRepository _todosRepository;

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    return super.close();
  }
}
