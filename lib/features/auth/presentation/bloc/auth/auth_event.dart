part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class AuthStatusChanged extends AuthEvent {
  final AuthStatus status;

  const AuthStatusChanged(this.status);
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
