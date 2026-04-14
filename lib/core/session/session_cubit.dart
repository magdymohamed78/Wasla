import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/domain/entities/login_entity.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import 'pending_intent_store.dart';
import 'role_resolver.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository _authRepository;
  final PendingIntentStore _pendingIntentStore;
  final RoleResolver _roleResolver;

  SessionCubit({
    required AuthRepository authRepository,
    required PendingIntentStore pendingIntentStore,
    RoleResolver? roleResolver,
  }) : _authRepository = authRepository,
       _pendingIntentStore = pendingIntentStore,
       _roleResolver = roleResolver ?? const RoleResolver(),
       super(const SessionState()) {
    _authRepository.registerSessionHooks(
      onSessionUpdated: _onRepositorySessionUpdated,
      onSessionCleared: _onRepositorySessionCleared,
    );
  }

  Future<void> initialize() async {
    emit(state.copyWith(status: SessionLifecycleStatus.loading));

    try {
      final storedSession = await _authRepository.getStoredSession();
      final pendingIntent = await _pendingIntentStore.read();
      final user = _toSessionUser(storedSession);

      emit(
        state.copyWith(
          status: SessionLifecycleStatus.ready,
          user: user,
          role: _roleResolver.resolveForUser(user),
          pendingIntent: pendingIntent,
          isRefreshingToken: false,
          refreshAttemptCount: 0,
          lastAuthError: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SessionLifecycleStatus.failure,
          user: null,
          role: SessionRole.guest,
          isRefreshingToken: false,
          refreshAttemptCount: 0,
          lastAuthError: 'session_init_failed',
        ),
      );
    }
  }

  Future<void> persistLoginSession({
    required LoginEntity user,
    required bool rememberMe,
  }) async {
    emit(state.copyWith(status: SessionLifecycleStatus.loading));
    await _authRepository.saveSession(user, rememberMe: rememberMe);
  }

  Future<void> syncRefreshedSession(LoginEntity user) async {
    await _authRepository.updateStoredSession(user, isRefresh: true);
  }

  Future<void> logout({bool preservePendingIntent = false}) async {
    await _authRepository.clearSession(
      preservePendingIntent: preservePendingIntent,
    );
  }

  Future<void> markGuestFallback({
    String? authError,
    bool preservePendingIntent = true,
  }) async {
    await _authRepository.clearSession(
      preservePendingIntent: preservePendingIntent,
    );
    emit(
      state.copyWith(
        status: SessionLifecycleStatus.ready,
        user: null,
        role: SessionRole.guest,
        isRefreshingToken: false,
        lastAuthError: authError,
      ),
    );
  }

  void beginRefreshSync() {
    emit(
      state.copyWith(
        isRefreshingToken: true,
        refreshAttemptCount: state.refreshAttemptCount + 1,
      ),
    );
  }

  void completeRefreshSync({String? authError}) {
    emit(state.copyWith(isRefreshingToken: false, lastAuthError: authError));
  }

  Future<void> restorePendingIntent() async {
    final pendingIntent = await _pendingIntentStore.read();
    emit(state.copyWith(pendingIntent: pendingIntent));
  }

  Future<void> savePendingIntent(PendingIntent intent) async {
    await _pendingIntentStore.save(intent);
    emit(state.copyWith(pendingIntent: intent));
  }

  Future<void> saveRequestServicePendingIntent({
    required int companyId,
    String? sourceRoute,
  }) async {
    final intent = PendingIntent(
      action: PendingActionType.requestService,
      companyId: companyId,
      createdAt: DateTime.now(),
      sourceRoute: sourceRoute,
    );

    await savePendingIntent(intent);
  }

  Future<PendingIntent?> consumePendingIntent() async {
    final intent = state.pendingIntent ?? await _pendingIntentStore.read();
    if (intent == null) {
      return null;
    }

    await clearPendingIntent();
    return intent;
  }

  Future<int?> consumePendingRequestCompanyId() async {
    final intent = await consumePendingIntent();
    if (intent == null) {
      return null;
    }

    if (intent.action != PendingActionType.requestService) {
      return null;
    }

    if (!intent.isValidForContinuation) {
      return null;
    }

    return intent.companyId;
  }

  Future<void> clearPendingIntent() async {
    await _pendingIntentStore.clear();
    emit(state.copyWith(pendingIntent: null));
  }

  Future<void> _onRepositorySessionUpdated(
    LoginEntity user,
    bool isRefresh,
  ) async {
    final sessionUser = _toSessionUser(user);
    emit(
      state.copyWith(
        status: SessionLifecycleStatus.ready,
        user: sessionUser,
        role: _roleResolver.resolveForUser(sessionUser),
        isRefreshingToken: false,
        refreshAttemptCount: isRefresh ? 1 : 0,
        lastAuthError: null,
      ),
    );
  }

  Future<void> _onRepositorySessionCleared(bool preservePendingIntent) async {
    if (!preservePendingIntent) {
      await _pendingIntentStore.clear();
    }

    emit(
      state.copyWith(
        status: SessionLifecycleStatus.ready,
        user: null,
        role: SessionRole.guest,
        isRefreshingToken: false,
        refreshAttemptCount: 0,
        pendingIntent: preservePendingIntent ? state.pendingIntent : null,
      ),
    );
  }

  SessionUser? _toSessionUser(LoginEntity? user) {
    if (user == null || user.token.isEmpty) {
      return null;
    }

    return SessionUser(
      token: user.token,
      refreshToken: user.refreshToken,
      refreshTokenExpiry: user.refreshTokenExpiry,
      userId: user.userId,
      leadId: user.leadId,
      customerId: user.customerId,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      digitalSignature: user.digitalSignature,
    );
  }
}
