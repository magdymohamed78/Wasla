import '../../domain/entities/login_entity.dart';
import 'auth_local_data_source.dart';

class InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  final Map<String, dynamic> _storage = {};

  @override
  Future<void> saveToken(String token) async {
    _storage['auth_token'] = token;
  }

  @override
  Future<String?> getToken() async {
    return _storage['auth_token'] as String?;
  }

  @override
  Future<void> clearToken() async {
    _storage.remove('auth_token');
  }

  @override
  Future<void> saveUser(LoginEntity user) async {
    _storage['user_id'] = user.userId.toString();
    if (user.customerId != null) {
      _storage['customer_id'] = user.customerId.toString();
    } else {
      _storage.remove('customer_id');
    }
    saveLeadId(user.leadId);
    _storage['first_name'] = user.firstName;
    _storage['last_name'] = user.lastName;
    _storage['user_email'] = user.email;
    await saveRefreshToken(user.refreshToken);
    await saveRefreshTokenExpiry(user.refreshTokenExpiry);
  }

  @override
  Future<LoginEntity?> getUser() async {
    final token = _storage['auth_token'] as String?;
    final userIdStr = _storage['user_id'] as String?;
    final customerIdStr = _storage['customer_id'] as String?;
    final leadIdStr = _storage['lead_id'] as String?;
    final firstName = _storage['first_name'] as String?;
    final lastName = _storage['last_name'] as String?;
    final email = _storage['user_email'] as String?;
    final refreshToken = _storage['refresh_token'] as String?;
    final refreshTokenExpiry = _storage['refresh_token_expiry'] as String?;

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
    _storage.clear();
  }

  @override
  Future<void> saveRefreshToken(String? refreshToken) async {
    if (refreshToken != null) {
      _storage['refresh_token'] = refreshToken;
    } else {
      _storage.remove('refresh_token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage['refresh_token'] as String?;
  }

  @override
  Future<void> clearRefreshToken() async {
    _storage.remove('refresh_token');
  }

  @override
  Future<void> saveRefreshTokenExpiry(String? expiry) async {
    if (expiry != null) {
      _storage['refresh_token_expiry'] = expiry;
    } else {
      _storage.remove('refresh_token_expiry');
    }
  }

  @override
  Future<String?> getRefreshTokenExpiry() async {
    return _storage['refresh_token_expiry'] as String?;
  }

  @override
  Future<void> saveRememberMeFlag(bool value) async {
    _storage['remember_me'] = value.toString();
  }

  @override
  Future<bool> getRememberMeFlag() async {
    final value = _storage['remember_me'] as String?;
    return value == 'true';
  }

  @override
  Future<void> clearRememberMeFlag() async {
    _storage.remove('remember_me');
  }

  @override
  Future<void> saveLeadId(int? leadId) async {
    if (leadId != null) {
      _storage['lead_id'] = leadId.toString();
    } else {
      _storage.remove('lead_id');
    }
  }

  @override
  Future<int?> getLeadId() async {
    final value = _storage['lead_id'] as String?;
    return value != null ? int.parse(value) : null;
  }
}
