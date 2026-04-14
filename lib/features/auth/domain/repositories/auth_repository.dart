import 'dart:async';

import '../entities/login_entity.dart';

typedef SessionUpdatedHook =
    FutureOr<void> Function(LoginEntity user, bool isRefresh);

typedef SessionClearedHook =
    FutureOr<void> Function(bool preservePendingIntent);

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

  Future<void> updateStoredSession(LoginEntity user, {required bool isRefresh});

  Future<void> clearSession({bool preservePendingIntent = false});

  void registerSessionHooks({
    SessionUpdatedHook? onSessionUpdated,
    SessionClearedHook? onSessionCleared,
  });

  Future<LoginEntity> refreshToken({required String refreshToken});

  Future<bool> getRememberMeFlag();

  Future<String?> getStoredRefreshToken();

  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshTokenData(String? refreshToken, String? expiry);

  Future<void> forgotPassword({required String email});

  Future<void> resendOtp({required String email});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmNewPassword,
  });
}
