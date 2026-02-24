import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/login_entity.dart';
import 'auth_local_data_source.dart';

class SecureAuthLocalDataSource implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _refreshTokenExpiryKey = 'refresh_token_expiry';
  static const String _rememberMeKey = 'remember_me';
  static const String _userIdKey = 'user_id';
  static const String _customerIdKey = 'customer_id';
  static const String _leadIdKey = 'lead_id';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _emailKey = 'user_email';

  final FlutterSecureStorage _storage;

  SecureAuthLocalDataSource({required FlutterSecureStorage storage}) : _storage = storage;

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<void> saveUser(LoginEntity user) async {
    await _storage.write(key: _userIdKey, value: user.userId.toString());
    if (user.customerId != null) {
      await _storage.write(key: _customerIdKey, value: user.customerId.toString());
    } else {
      await _storage.delete(key: _customerIdKey);
    }
    await saveLeadId(user.leadId);
    await _storage.write(key: _firstNameKey, value: user.firstName);
    await _storage.write(key: _lastNameKey, value: user.lastName);
    await _storage.write(key: _emailKey, value: user.email);
    await saveRefreshToken(user.refreshToken);
    await saveRefreshTokenExpiry(user.refreshTokenExpiry);
  }

  @override
  Future<LoginEntity?> getUser() async {
    final token = await getToken();
    final userIdStr = await _storage.read(key: _userIdKey);
    final customerIdStr = await _storage.read(key: _customerIdKey);
    final leadIdStr = await _storage.read(key: _leadIdKey);
    final firstName = await _storage.read(key: _firstNameKey);
    final lastName = await _storage.read(key: _lastNameKey);
    final email = await _storage.read(key: _emailKey);
    final refreshToken = await getRefreshToken();
    final refreshTokenExpiry = await getRefreshTokenExpiry();

    if (token == null ||
        userIdStr == null ||
        firstName == null ||
        lastName == null ||
        email == null) {
      return null;
    }

    return LoginEntity(
      token: token,
      refreshToken: refreshToken,
      refreshTokenExpiry: refreshTokenExpiry,
      userId: int.parse(userIdStr),
      customerId: customerIdStr != null ? int.parse(customerIdStr) : null,
      leadId: leadIdStr != null ? int.parse(leadIdStr) : null,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  @override
  Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _refreshTokenExpiryKey);
    await _storage.delete(key: _rememberMeKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _customerIdKey);
    await _storage.delete(key: _leadIdKey);
    await _storage.delete(key: _firstNameKey);
    await _storage.delete(key: _lastNameKey);
    await _storage.delete(key: _emailKey);
  }

  @override
  Future<void> saveRefreshToken(String? refreshToken) async {
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    } else {
      await _storage.delete(key: _refreshTokenKey);
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> clearRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> saveRefreshTokenExpiry(String? expiry) async {
    if (expiry != null) {
      await _storage.write(key: _refreshTokenExpiryKey, value: expiry);
    } else {
      await _storage.delete(key: _refreshTokenExpiryKey);
    }
  }

  @override
  Future<String?> getRefreshTokenExpiry() async {
    return await _storage.read(key: _refreshTokenExpiryKey);
  }

  @override
  Future<void> saveRememberMeFlag(bool value) async {
    await _storage.write(key: _rememberMeKey, value: value.toString());
  }

  @override
  Future<bool> getRememberMeFlag() async {
    final value = await _storage.read(key: _rememberMeKey);
    return value == 'true';
  }

  @override
  Future<void> clearRememberMeFlag() async {
    await _storage.delete(key: _rememberMeKey);
  }

  @override
  Future<void> saveLeadId(int? leadId) async {
    if (leadId != null) {
      await _storage.write(key: _leadIdKey, value: leadId.toString());
    } else {
      await _storage.delete(key: _leadIdKey);
    }
  }

  @override
  Future<int?> getLeadId() async {
    final value = await _storage.read(key: _leadIdKey);
    return value != null ? int.parse(value) : null;
  }
}
