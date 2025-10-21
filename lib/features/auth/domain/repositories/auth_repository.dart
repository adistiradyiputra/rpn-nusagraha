import '../entities/user.dart';
import '../entities/login_request.dart';

abstract class AuthRepository {
  Future<User> login(LoginRequest request);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> saveUserSession(User user);
  Future<void> clearUserSession();
}

