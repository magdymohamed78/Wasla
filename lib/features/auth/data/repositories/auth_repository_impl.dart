import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../data_sources/auth_local_data_source.dart';
import '../models/login_request_model.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<LoginEntity> login({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[AuthRepository] LOGIN ATTEMPT');
    debugPrint('[AuthRepository] Email: $trimmedEmail');
    debugPrint('[AuthRepository] Password: ${'*' * trimmedPassword.length}');
    debugPrint('════════════════════════════════════════════════════');

    try {
      final request = LoginRequestModel(
        email: trimmedEmail,
        password: trimmedPassword,
      );
      final response = await _remoteDataSource.login(request);
      debugPrint('[AuthRepository] ✓ Login successful for: $trimmedEmail');
      return response.toEntity();
    } on DioException catch (e) {
      debugPrint('[AuthRepository] ✗ Login FAILED');
      debugPrint('[AuthRepository] DioException type: ${e.type}');
      debugPrint('[AuthRepository] Status code: ${e.response?.statusCode}');
      debugPrint('[AuthRepository] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] ✗ Login FAILED with unknown error: $e');
      rethrow;
    }
  }

  @override
  Future<LoginEntity?> getStoredSession() async {
    return await _localDataSource.getUser();
  }

  @override
  Future<void> saveSession(LoginEntity user) async {
    await _localDataSource.saveToken(user.token);
    await _localDataSource.saveUser(user);
  }

  @override
  Future<void> clearSession() async {
    await _localDataSource.clearAll();
  }
}
