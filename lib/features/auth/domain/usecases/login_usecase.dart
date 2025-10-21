import '../entities/user.dart';
import '../entities/login_request.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> execute(LoginRequest request) async {
    try {
      final user = await repository.login(request);
      if (request.rememberMe) {
        await repository.saveUserSession(user);
      }
      return user;
    } catch (e) {
      // Re-throw the original exception message without modification
      rethrow;
    }
  }
}

