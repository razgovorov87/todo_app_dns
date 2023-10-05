import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/domain/model/enum/auth_status.dart';
import 'package:todo_app/domain/repository/authorization_repository.dart';

@injectable
class AuthorizationCubit extends Cubit<AuthStatus> {
  AuthorizationCubit(
    this._authorizationRepository,
  ) : super(AuthStatus.unauthorized) {
    _streamSubscription = _authorizationRepository.authStatusStream.listen(
      (AuthStatus status) {
        emit(status);
      },
    );
  }

  late final StreamSubscription<AuthStatus> _streamSubscription;
  final AuthorizationRepository _authorizationRepository;

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();

    return super.close();
  }
}
