import 'package:injectable/injectable.dart';

abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<void> logout();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login({required String email, required String password}) async {
    // Fake API requesting
    await Future.delayed(const Duration(seconds: 1));

    if (email == "test@test.com" && password == "password") {
      // TODO: save token here
      return;
    } else {
      throw Exception("Incorrect email or password");
    }
  }

  @override
  Future<void> logout() async {
    // Fake token deleting
    await Future.delayed(const Duration(seconds: 1));
    // TODO: delete token here
  }
}
