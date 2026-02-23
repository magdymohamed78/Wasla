import '../entities/login_entity.dart';

abstract class AuthRepository {
  Future<LoginEntity> login({
    required String email,
    required String password,
  });

  Future<LoginEntity> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });

  Future<LoginEntity?> getStoredSession();

  Future<void> saveSession(LoginEntity user);

  Future<void> clearSession();
}
