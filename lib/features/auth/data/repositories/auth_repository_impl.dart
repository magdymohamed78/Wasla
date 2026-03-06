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

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource secureLocalDataSource,
    required AuthLocalDataSource inMemoryLocalDataSource,
  })  : _remoteDataSource = remoteDataSource,
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
    return await _activeLocalDataSource.getUser();
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
  }

  @override
  Future<void> clearSession() async {
    await _secureLocalDataSource.clearAll();
    await _inMemoryLocalDataSource.clearAll();
  }

  @override
  Future<LoginEntity> refreshToken({required String refreshToken}) async {
    final request = RefreshTokenRequestModel(refreshToken: refreshToken);
    final response = await _remoteDataSource.refreshToken(request);
    return response.toEntity();
  }

  @override
  Future<bool> getRememberMeFlag() async {
    return await _activeLocalDataSource.getRememberMeFlag();
  }

  @override
  Future<String?> getStoredRefreshToken() async {
    return await _activeLocalDataSource.getRefreshToken();
  }

  @override
  Future<String?> getStoredAccessToken() async {
    return await _activeLocalDataSource.getToken();
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _activeLocalDataSource.saveToken(token);
  }

  @override
  Future<void> saveRefreshTokenData(String? refreshToken, String? expiry) async {
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
}
