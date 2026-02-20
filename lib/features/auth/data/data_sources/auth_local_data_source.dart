import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/login_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveUser(LoginEntity user);
  Future<LoginEntity?> getUser();
  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _customerIdKey = 'customer_id';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _emailKey = 'user_email';

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
    await sharedPreferences.setString(_firstNameKey, user.firstName);
    await sharedPreferences.setString(_lastNameKey, user.lastName);
    await sharedPreferences.setString(_emailKey, user.email);
  }

  @override
  Future<LoginEntity?> getUser() async {
    final token = sharedPreferences.getString(_tokenKey);
    final userId = sharedPreferences.getInt(_userIdKey);
    final customerId = sharedPreferences.getInt(_customerIdKey);
    final firstName = sharedPreferences.getString(_firstNameKey);
    final lastName = sharedPreferences.getString(_lastNameKey);
    final email = sharedPreferences.getString(_emailKey);

    if (token == null ||
        userId == null ||
        customerId == null ||
        firstName == null ||
        lastName == null ||
        email == null) {
      return null;
    }

    return LoginEntity(
      token: token,
      userId: userId,
      customerId: customerId,
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
    await sharedPreferences.remove(_firstNameKey);
    await sharedPreferences.remove(_lastNameKey);
    await sharedPreferences.remove(_emailKey);
  }
}
