import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/data/dto/todo_dto/todo_dto.dart';
import 'package:todo_app/data/dto/user_dto/user_dto.dart';

mixin FirebaseReferences {
  //Users
  static final userCollectionRef = FirebaseFirestore.instance.collection('users').withConverter<UserDto>(
        fromFirestore: (snapshot, options) => UserDto.fromJson(snapshot.data() as Map<String, dynamic>),
        toFirestore: (value, options) => value.toJson(),
      );

  //Todos
  static CollectionReference<TodoDto> todosCollectionRef(String userId) =>
      FirebaseFirestore.instance.collection('todos').doc(userId).collection('todos').withConverter<TodoDto>(
            fromFirestore: (snapshot, options) => TodoDto.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (value, options) => value.toJson(),
          );

  static DocumentReference<TodoDto> todoRef({
    required String userId,
    required String todoId,
  }) =>
      FirebaseFirestore.instance.collection('todos').doc(userId).collection('todos').doc(todoId).withConverter<TodoDto>(
            fromFirestore: (snapshot, options) => TodoDto.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (value, options) => value.toJson(),
          );
}
