import 'package:injectable/injectable.dart';
import 'package:todo_app/data/source/firestore/firestore_source.dart';
import 'package:todo_app/domain/model/enum/auth_status.dart';

import '../../domain/repository/authorization_repository.dart';

@Singleton(as: AuthorizationRepository)
class AuthorizationRepositoryImpl implements AuthorizationRepository {
  AuthorizationRepositoryImpl(this._firestoreSource);

  final FirestoreSource _firestoreSource;

  @override
  Stream<AuthStatus> get authStatusStream =>
      _firestoreSource.currentUserStream.map((user) => user != null ? AuthStatus.authorized : AuthStatus.unauthorized);

  @override
  Future<void> login({required String login, required String password}) =>
      _firestoreSource.login(login: login, password: password);

  @override
  Future<void> logout() => _firestoreSource.logout();
}
