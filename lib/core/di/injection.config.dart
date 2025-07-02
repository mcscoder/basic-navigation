// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:basic_navigation/features/auth/data/repository/auth_repository.dart'
    as _i550;
import 'package:basic_navigation/features/auth/presentation/bloc/auth/auth_bloc.dart'
    as _i848;
import 'package:basic_navigation/features/auth/presentation/bloc/login/login_bloc.dart'
    as _i380;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i550.AuthRepository>(() => _i550.AuthRepositoryImpl());
    gh.singleton<_i848.AuthBloc>(
      () => _i848.AuthBloc(gh<_i550.AuthRepository>()),
    );
    gh.factory<_i380.LoginBloc>(
      () => _i380.LoginBloc(gh<_i550.AuthRepository>(), gh<_i848.AuthBloc>()),
    );
    return this;
  }
}
