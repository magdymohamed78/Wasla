import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/role_guard_use_cases.dart';
import 'lead_access_state.dart';

class LeadAccessCubit extends Cubit<LeadAccessState> {
  final SessionCubit _sessionCubit;
  final RoleGuardUseCases _roleGuardUseCases;
  StreamSubscription<SessionState>? _sessionSubscription;

  LeadAccessCubit({
    required SessionCubit sessionCubit,
    required RoleGuardUseCases roleGuardUseCases,
  }) : _sessionCubit = sessionCubit,
       _roleGuardUseCases = roleGuardUseCases,
       super(const LeadAccessState()) {
    _sessionSubscription = _sessionCubit.stream.listen(_syncFromSession);
  }

  Future<void> resolveAccessContext() async {
    _syncFromSession(_sessionCubit.state);
  }

  bool shouldRestrictTab(DiscoveryTab tab) {
    return state.isTabRestricted(tab);
  }

  GuardDecision guardRequestServiceAction({required int? companyId}) {
    return _roleGuardUseCases.guardRequestServiceAction(
      role: state.role,
      companyId: companyId,
    );
  }

  void _syncFromSession(SessionState sessionState) {
    final role = sessionState.role;
    emit(
      state.copyWith(
        isLoading:
            sessionState.status == SessionLifecycleStatus.initial ||
            sessionState.status == SessionLifecycleStatus.loading,
        role: role,
        chatbotTabDecision: _roleGuardUseCases.guardTabAccess(
          role: role,
          scope: RestrictionScope.chatbotTab,
        ),
        requestsTabDecision: _roleGuardUseCases.guardTabAccess(
          role: role,
          scope: RestrictionScope.requestsTab,
        ),
        offersTabDecision: _roleGuardUseCases.guardTabAccess(
          role: role,
          scope: RestrictionScope.offersTab,
        ),
        profileTabDecision: _roleGuardUseCases.guardTabAccess(
          role: role,
          scope: RestrictionScope.profileTab,
        ),
        requestActionDecision: _roleGuardUseCases.guardGuestSignInEntry(
          role: role,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _sessionSubscription?.cancel();
    return super.close();
  }
}
