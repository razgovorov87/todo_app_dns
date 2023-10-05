import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:todo_app/data/dto/todo_dto/todo_dto.dart';
import 'package:todo_app/data/dto/user_dto/user_dto.dart';
import 'package:todo_app/data/source/firestore/firebase_references.dart';
import 'package:todo_app/domain/model/enum/todo_status.dart';

@preResolve
@singleton
class FirestoreSource with FirebaseReferences {
  FirestoreSource._(this.instance);

  final FirebaseFirestore instance;

  final _userSubject = BehaviorSubject<UserDto?>.seeded(null);
  final _todoSubject = BehaviorSubject<List<TodoDto>?>.seeded(null);

  @factoryMethod
  static Future<FirestoreSource> create() async {
    final FirebaseFirestore instance = FirebaseFirestore.instance;
    final FirestoreSource source = FirestoreSource._(instance);
    await source._init();
    return source;
  }

  Future<void> _init() async {
    _userSubject.stream.listen((user) {
      if (user != null) {
        watchTodos(user.id);
      } else {
        _todoSubject.add(null);
      }
    });
  }

  Stream<UserDto?> get currentUserStream => _userSubject.stream;

  Stream<List<TodoDto>?> get todosStream => _todoSubject.stream;
  List<TodoDto>? get todos => _todoSubject.stream.value;

  Future<void> createTodo({
    required String title,
    required String shortDesc,
    String? fullDesc,
  }) async {
    final user = _userSubject.value;
    if (user == null) throw 'Пользователь не авторизован';

    final todoRef = FirebaseReferences.todosCollectionRef(user.id).doc();

    final newData = TodoDto(
      id: todoRef.id,
      title: title,
      shortDescription: shortDesc,
      fullDescription: fullDesc,
      status: TodoStatus.created,
      createdAt: DateTime.now(),
    );

    await todoRef.set(newData);
  }

  Future<void> updateTodoStatus({
    required String id,
    required TodoStatus status,
  }) async {
    final user = _userSubject.value;
    if (user == null) throw 'Пользователь не авторизован';

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final ref = FirebaseReferences.todoRef(userId: user.id, todoId: id);
      final todo = (await transaction.get(ref)).data();

      if (todo == null) throw 'Todo не найдена';
      final isCanToUpdate = _isCanToUpdateTodoStatus(currentStatus: todo.status, newStatus: status);

      if (isCanToUpdate) {
        final newData = todo.copyWith(status: status);

        transaction.update(ref, newData.toJson());
      } else {
        throw 'Нельзя перевести в этот статус';
      }
    });
  }

  Future<void> deleteTodo(String id) async {
    final user = _userSubject.value;
    if (user == null) throw 'Пользователь не авторизован';

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final ref = FirebaseReferences.todoRef(userId: user.id, todoId: id);
      final todo = (await transaction.get(ref)).data();

      if (todo == null) throw 'Todo не найдена';
      final isCanToDelete = _isCanToDeleteTodo(todo.status);

      if (isCanToDelete) {
        transaction.delete(ref);
      } else {
        throw 'Нельзя удалить todo с текущим статусом';
      }
    });
  }

  bool _isCanToDeleteTodo(TodoStatus currentStatus) {
    return currentStatus == TodoStatus.created;
  }

  bool _isCanToUpdateTodoStatus({
    required TodoStatus currentStatus,
    required TodoStatus newStatus,
  }) {
    if (currentStatus == TodoStatus.created && newStatus == TodoStatus.completed) {
      return false;
    } else if (currentStatus == TodoStatus.completed) {
      return false;
    } else {
      return true;
    }
  }

  void watchTodos(String userId) {
    FirebaseReferences.todosCollectionRef(userId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList())
        .listen(
      (event) {
        _todoSubject.add(event);
      },
    );
  }

  Future<void> login({
    required String login,
    required String password,
  }) async {
    try {
      final hash = md5.convert(utf8.encode(password)).toString();
      final users = (await FirebaseReferences.userCollectionRef
              .where(
                'login',
                isEqualTo: login,
              )
              .where(
                'password',
                isEqualTo: hash,
              )
              .get())
          .docs
          .map((e) => e.data());

      if (users.isEmpty) throw 'Неверный логин или пароль';
      _userSubject.add(users.first);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _userSubject.add(null);
  }
}
