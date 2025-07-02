import 'package:basic_navigation/features/auth/data/repository/auth_repository.dart';
import 'package:basic_navigation/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable // Register as a factory: a new instance is created each time it is requested
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  LoginBloc(this._authRepository, this._authBloc) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.login(email: event.email, password: event.password);
      emit(state.copyWith(status: LoginStatus.success));
      _authBloc.add(const AuthStatusChanged(AuthStatus.authenticated));
    } catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
