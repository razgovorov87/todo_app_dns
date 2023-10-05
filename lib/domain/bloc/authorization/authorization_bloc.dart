import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/domain/repository/authorization_repository.dart';

part 'authorization_bloc.freezed.dart';

@injectable
class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  AuthorizationBloc(
    this._authorizationRepository,
  ) : super(const AuthorizationState.initial()) {
    on<AuthorizationEvent>(_onEvent);
  }

  final AuthorizationRepository _authorizationRepository;

  FutureOr<void> _onEvent(AuthorizationEvent mainEvent, Emitter<AuthorizationState> emit) => mainEvent.map(
        login: (_Login event) => _mapLoginToState(event, emit),
        logout: (_Logout event) => _mapLogoutToState(event, emit),
      );

  Future<void> _mapLoginToState(_Login event, Emitter<AuthorizationState> emit) async {
    emit(const AuthorizationState.waiting());
    try {
      final String login = event.login;
      final String password = event.password;
      if (login.isEmpty || password.isEmpty) {
        emit(const AuthorizationState.error('Введите логин/пароль'));
        return;
      }

      await _authorizationRepository.login(login: login, password: password);
    } catch (e) {
      emit(AuthorizationState.error(e.toString()));
    }
  }

  Future<void> _mapLogoutToState(_Logout event, Emitter<AuthorizationState> emit) async {
    try {
      await _authorizationRepository.logout();
    } catch (e) {
      emit(AuthorizationState.error(e.toString()));
    }
  }
}

@freezed
class AuthorizationEvent with _$AuthorizationEvent {
  const factory AuthorizationEvent.login({
    required String login,
    required String password,
  }) = _Login;

  const factory AuthorizationEvent.logout() = _Logout;
}

@freezed
class AuthorizationState with _$AuthorizationState {
  const factory AuthorizationState.initial() = _Initial;

  const factory AuthorizationState.waiting() = _Waiting;

  const factory AuthorizationState.error(String message) = _Error;
}
