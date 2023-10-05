import 'package:todo_app/domain/model/enum/auth_status.dart';

abstract class AuthorizationRepository {
  Stream<AuthStatus> get authStatusStream;

  Future<void> login({
    required String login,
    required String password,
  });

  Future<void> logout();
}
