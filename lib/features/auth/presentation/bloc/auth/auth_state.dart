part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;

  const AuthState._(this.status);

  const AuthState.authenticated() : this._(AuthStatus.authenticated);

  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated);
}
