import 'package:dio/dio.dart';

import '../../../../core/session/role_resolver.dart';
import '../../../auth/domain/entities/login_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/customer_portal_profile.dart';
import '../entities/update_portal_profile_input.dart';
import '../repositories/customer_portal_repository.dart';

enum RefreshCustomerSessionResult {
  upgraded,
  alreadyCustomer,
  noSession,
  reauthRequired,
  failed,
}

class GetCustomerProfileUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerProfileUseCase(this._repository);

  Future<CustomerPortalProfile> call() {
    return _repository.getCustomerProfile();
  }
}

class UpdateCustomerProfileUseCase {
  final CustomerPortalRepository _repository;

  const UpdateCustomerProfileUseCase(this._repository);

  Future<CustomerPortalProfile> call(UpdatePortalProfileInput input) {
    return _repository.updateCustomerProfile(input: input);
  }
}

class RefreshCustomerSessionUseCase {
  static const List<int> _retryDelaysMs = <int>[350, 700, 1200];

  final CustomerPortalRepository _repository;
  final AuthRepository _authRepository;
  final RoleResolver _roleResolver;

  const RefreshCustomerSessionUseCase({
    required CustomerPortalRepository repository,
    required AuthRepository authRepository,
    RoleResolver? roleResolver,
  }) : _repository = repository,
       _authRepository = authRepository,
       _roleResolver = roleResolver ?? const RoleResolver();

  Future<RefreshCustomerSessionResult> call() async {
    final currentSession = await _authRepository.getStoredSession();
    if (currentSession == null) {
      return RefreshCustomerSessionResult.noSession;
    }

    final wasCustomerToken = _roleResolver.hasCustomerAccess(
      currentSession.token,
    );

    for (final delayMs in _retryDelaysMs) {
      final attempt = await _tryRefreshFromCustomerProfile(
        wasCustomerToken: wasCustomerToken,
      );
      if (attempt != null) {
        return attempt;
      }

      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }

    final finalAttempt = await _tryRefreshFromCustomerProfile(
      wasCustomerToken: wasCustomerToken,
    );
    if (finalAttempt != null) {
      return finalAttempt;
    }

    final latestSession = await _authRepository.getStoredSession();
    if (latestSession == null) {
      return RefreshCustomerSessionResult.reauthRequired;
    }

    if (_roleResolver.hasCustomerAccess(latestSession.token)) {
      return wasCustomerToken
          ? RefreshCustomerSessionResult.alreadyCustomer
          : RefreshCustomerSessionResult.upgraded;
    }

    return RefreshCustomerSessionResult.failed;
  }

  Future<RefreshCustomerSessionResult?> _tryRefreshFromCustomerProfile({
    required bool wasCustomerToken,
  }) async {
    try {
      final profile = await _repository.getCustomerProfile();

      final latestSession = await _authRepository.getStoredSession();
      if (latestSession == null) {
        return RefreshCustomerSessionResult.reauthRequired;
      }

      if (!_roleResolver.hasCustomerAccess(latestSession.token)) {
        // Token must prove customer access before showing customer features.
        return RefreshCustomerSessionResult.failed;
      }

      final refreshedSession = _toRefreshedSession(
        currentSession: latestSession,
        profile: profile,
      );

      await _authRepository.updateStoredSession(
        refreshedSession,
        isRefresh: false,
      );

      return wasCustomerToken
          ? RefreshCustomerSessionResult.alreadyCustomer
          : RefreshCustomerSessionResult.upgraded;
    } on DioException catch (error) {
      if (_isAuthFailure(error)) {
        final latestSession = await _authRepository.getStoredSession();
        if (latestSession == null) {
          return RefreshCustomerSessionResult.reauthRequired;
        }

        if (!_roleResolver.hasCustomerAccess(latestSession.token)) {
          return RefreshCustomerSessionResult.reauthRequired;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  bool _isAuthFailure(DioException error) {
    final statusCode = error.response?.statusCode;
    return statusCode == 401 || statusCode == 403;
  }

  LoginEntity _toRefreshedSession({
    required LoginEntity currentSession,
    required CustomerPortalProfile profile,
  }) {
    return LoginEntity(
      token: currentSession.token,
      refreshToken: currentSession.refreshToken,
      refreshTokenExpiry: currentSession.refreshTokenExpiry,
      userId: profile.userId,
      customerId: profile.customerId,
      leadId: currentSession.leadId,
      firstName: profile.firstName ?? currentSession.firstName,
      lastName: profile.lastName ?? currentSession.lastName,
      email: profile.email ?? currentSession.email,
      digitalSignature:
          profile.digitalSignature ?? currentSession.digitalSignature,
    );
  }
}
