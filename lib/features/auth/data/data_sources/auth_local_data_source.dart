import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/login_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveUser(LoginEntity user);
  Future<LoginEntity?> getUser();
  Future<void> clearAll();
  
  Future<void> saveRefreshToken(String? refreshToken);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();
  
  Future<void> saveRefreshTokenExpiry(String? expiry);
  Future<String?> getRefreshTokenExpiry();
  
  Future<void> saveRememberMeFlag(bool value);
  Future<bool> getRememberMeFlag();
  Future<void> clearRememberMeFlag();
  
  Future<void> saveLeadId(int? leadId);
  Future<int?> getLeadId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _customerIdKey = 'customer_id';
  static const String _leadIdKey = 'lead_id';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _emailKey = 'user_email';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _refreshTokenExpiryKey = 'refresh_token_expiry';
  static const String _rememberMeKey = 'remember_me';

  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
  }

  @override
  Future<void> saveUser(LoginEntity user) async {
    await sharedPreferences.setInt(_userIdKey, user.userId);
    if (user.customerId != null) {
      await sharedPreferences.setInt(_customerIdKey, user.customerId!);
    } else {
      await sharedPreferences.remove(_customerIdKey);
    }
    await saveLeadId(user.leadId);
    await sharedPreferences.setString(_firstNameKey, user.firstName);
    await sharedPreferences.setString(_lastNameKey, user.lastName);
    await sharedPreferences.setString(_emailKey, user.email);
    await saveRefreshToken(user.refreshToken);
    await saveRefreshTokenExpiry(user.refreshTokenExpiry);
  }

  @override
  Future<LoginEntity?> getUser() async {
    final token = sharedPreferences.getString(_tokenKey);
    final userId = sharedPreferences.getInt(_userIdKey);
    final customerId = sharedPreferences.getInt(_customerIdKey);
    final leadId = sharedPreferences.getInt(_leadIdKey);
    final firstName = sharedPreferences.getString(_firstNameKey);
    final lastName = sharedPreferences.getString(_lastNameKey);
    final email = sharedPreferences.getString(_emailKey);
    final refreshToken = sharedPreferences.getString(_refreshTokenKey);
    final refreshTokenExpiry = sharedPreferences.getString(_refreshTokenExpiryKey);

    if (token == null ||
        userId == null ||
        firstName == null ||
        lastName == null ||
        email == null) {
      return null;
    }

    return LoginEntity(
      token: token,
      refreshToken: refreshToken,
      refreshTokenExpiry: refreshTokenExpiry,
      userId: userId,
      customerId: customerId,
      leadId: leadId,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userIdKey);
    await sharedPreferences.remove(_customerIdKey);
    await sharedPreferences.remove(_leadIdKey);
    await sharedPreferences.remove(_firstNameKey);
    await sharedPreferences.remove(_lastNameKey);
    await sharedPreferences.remove(_emailKey);
    await sharedPreferences.remove(_refreshTokenKey);
    await sharedPreferences.remove(_refreshTokenExpiryKey);
    await sharedPreferences.remove(_rememberMeKey);
  }

  @override
  Future<void> saveRefreshToken(String? refreshToken) async {
    if (refreshToken != null) {
      await sharedPreferences.setString(_refreshTokenKey, refreshToken);
    } else {
      await sharedPreferences.remove(_refreshTokenKey);
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(_refreshTokenKey);
  }

  @override
  Future<void> clearRefreshToken() async {
    await sharedPreferences.remove(_refreshTokenKey);
  }

  @override
  Future<void> saveRefreshTokenExpiry(String? expiry) async {
    if (expiry != null) {
      await sharedPreferences.setString(_refreshTokenExpiryKey, expiry);
    } else {
      await sharedPreferences.remove(_refreshTokenExpiryKey);
    }
  }

  @override
  Future<String?> getRefreshTokenExpiry() async {
    return sharedPreferences.getString(_refreshTokenExpiryKey);
  }

  @override
  Future<void> saveRememberMeFlag(bool value) async {
    await sharedPreferences.setBool(_rememberMeKey, value);
  }

  @override
  Future<bool> getRememberMeFlag() async {
    return sharedPreferences.getBool(_rememberMeKey) ?? false;
  }

  @override
  Future<void> clearRememberMeFlag() async {
    await sharedPreferences.remove(_rememberMeKey);
  }

  @override
  Future<void> saveLeadId(int? leadId) async {
    if (leadId != null) {
      await sharedPreferences.setInt(_leadIdKey, leadId);
    } else {
      await sharedPreferences.remove(_leadIdKey);
    }
  }

  @override
  Future<int?> getLeadId() async {
    return sharedPreferences.getInt(_leadIdKey);
  }
}
