import 'dart:async';

import '../data_sources/auth_remote_data_source.dart';
import '../data_sources/auth_local_data_source.dart';
import '../models/forgot_password_request_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/resend_otp_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/refresh_token_request_model.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _secureLocalDataSource;
  final AuthLocalDataSource _inMemoryLocalDataSource;
  AuthLocalDataSource _activeLocalDataSource;
  SessionUpdatedHook? _onSessionUpdated;
  SessionClearedHook? _onSessionCleared;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource secureLocalDataSource,
    required AuthLocalDataSource inMemoryLocalDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _secureLocalDataSource = secureLocalDataSource,
       _inMemoryLocalDataSource = inMemoryLocalDataSource,
       _activeLocalDataSource = secureLocalDataSource;

  @override
  Future<LoginEntity> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    final request = LoginRequestModel(
      email: trimmedEmail,
      password: trimmedPassword,
      rememberMe: rememberMe,
    );
    final response = await _remoteDataSource.login(request);
    return response.toEntity();
  }

  @override
  Future<LoginEntity> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedFirstName = firstName.trim();
    final trimmedLastName = lastName.trim();
    final trimmedPhoneNumber = phoneNumber?.trim();

    final request = RegisterRequestModel(
      email: trimmedEmail,
      password: trimmedPassword,
      firstName: trimmedFirstName,
      lastName: trimmedLastName,
      phoneNumber: trimmedPhoneNumber,
    );
    final response = await _remoteDataSource.register(request);
    return response.toEntity();
  }

  @override
  Future<LoginEntity?> getStoredSession() async {
    final dataSource = await _resolveReadableDataSource();
    final session = await dataSource.getUser();
    if (session != null) {
      _activeLocalDataSource = dataSource;
    }
    return session;
  }

  @override
  Future<void> saveSession(LoginEntity user, {required bool rememberMe}) async {
    if (rememberMe) {
      await _inMemoryLocalDataSource.clearAll();
      _activeLocalDataSource = _secureLocalDataSource;
    } else {
      await _secureLocalDataSource.clearAll();
      _activeLocalDataSource = _inMemoryLocalDataSource;
    }

    await _activeLocalDataSource.saveToken(user.token);
    await _activeLocalDataSource.saveUser(user);
    await _activeLocalDataSource.saveRememberMeFlag(rememberMe);
    await _onSessionUpdated?.call(user, false);
  }

  @override
  Future<void> updateStoredSession(
    LoginEntity user, {
    required bool isRefresh,
  }) async {
    final dataSource = await _resolveWritableDataSource();
    _activeLocalDataSource = dataSource;
    await _activeLocalDataSource.saveToken(user.token);
    await _activeLocalDataSource.saveUser(user);
    await _onSessionUpdated?.call(user, isRefresh);
  }

  @override
  Future<void> clearSession({bool preservePendingIntent = false}) async {
    await _secureLocalDataSource.clearAll();
    await _inMemoryLocalDataSource.clearAll();
    _activeLocalDataSource = _secureLocalDataSource;
    await _onSessionCleared?.call(preservePendingIntent);
  }

  @override
  void registerSessionHooks({
    SessionUpdatedHook? onSessionUpdated,
    SessionClearedHook? onSessionCleared,
  }) {
    _onSessionUpdated = onSessionUpdated;
    _onSessionCleared = onSessionCleared;
  }

  @override
  Future<LoginEntity> refreshToken({required String refreshToken}) async {
    final request = RefreshTokenRequestModel(refreshToken: refreshToken);
    final response = await _remoteDataSource.refreshToken(request);
    return response.toEntity();
  }

  @override
  Future<bool> getRememberMeFlag() async {
    final secureRememberMe = await _secureLocalDataSource.getRememberMeFlag();
    if (secureRememberMe) {
      _activeLocalDataSource = _secureLocalDataSource;
      return true;
    }

    final inMemoryRememberMe = await _inMemoryLocalDataSource
        .getRememberMeFlag();
    if (inMemoryRememberMe) {
      _activeLocalDataSource = _inMemoryLocalDataSource;
      return true;
    }

    return false;
  }

  @override
  Future<String?> getStoredRefreshToken() async {
    final dataSource = await _resolveReadableDataSource();
    _activeLocalDataSource = dataSource;
    return await _activeLocalDataSource.getRefreshToken();
  }

  @override
  Future<String?> getStoredAccessToken() async {
    final dataSource = await _resolveReadableDataSource();
    _activeLocalDataSource = dataSource;
    return await _activeLocalDataSource.getToken();
  }

  @override
  Future<void> saveAccessToken(String token) async {
    final dataSource = await _resolveWritableDataSource();
    _activeLocalDataSource = dataSource;
    await _activeLocalDataSource.saveToken(token);
  }

  @override
  Future<void> saveRefreshTokenData(
    String? refreshToken,
    String? expiry,
  ) async {
    final dataSource = await _resolveWritableDataSource();
    _activeLocalDataSource = dataSource;
    await _activeLocalDataSource.saveRefreshToken(refreshToken);
    await _activeLocalDataSource.saveRefreshTokenExpiry(expiry);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final request = ForgotPasswordRequestModel(email: email.trim());
    await _remoteDataSource.forgotPassword(request);
  }

  @override
  Future<void> resendOtp({required String email}) async {
    final request = ResendOtpRequestModel(email: email.trim());
    await _remoteDataSource.resendOtp(request);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final request = ResetPasswordRequestModel(
      email: email.trim(),
      otp: otp.trim(),
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
    await _remoteDataSource.resetPassword(request);
  }

  Future<AuthLocalDataSource> _resolveReadableDataSource() async {
    final activeToken = await _activeLocalDataSource.getToken();
    if (activeToken != null && activeToken.isNotEmpty) {
      return _activeLocalDataSource;
    }

    final secureToken = await _secureLocalDataSource.getToken();
    if (secureToken != null && secureToken.isNotEmpty) {
      return _secureLocalDataSource;
    }

    final inMemoryToken = await _inMemoryLocalDataSource.getToken();
    if (inMemoryToken != null && inMemoryToken.isNotEmpty) {
      return _inMemoryLocalDataSource;
    }

    return _activeLocalDataSource;
  }

  Future<AuthLocalDataSource> _resolveWritableDataSource() async {
    final readable = await _resolveReadableDataSource();
    if (readable != _activeLocalDataSource) {
      return readable;
    }

    return _activeLocalDataSource;
  }
}
