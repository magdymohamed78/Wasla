import '../entities/login_entity.dart';

abstract class AuthRepository {
  Future<LoginEntity> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<LoginEntity> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });

  Future<LoginEntity?> getStoredSession();

  Future<String?> getStoredAccessToken();

  Future<void> saveSession(LoginEntity user, {required bool rememberMe});

  Future<void> clearSession();

  Future<LoginEntity> refreshToken({required String refreshToken});

  Future<bool> getRememberMeFlag();

  Future<String?> getStoredRefreshToken();

  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshTokenData(String? refreshToken, String? expiry);
}
