import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import 'lead_access_state.dart';

class LeadAccessCubit extends Cubit<LeadAccessState> {
  final AuthRepository _authRepository;

  LeadAccessCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LeadAccessState());

  Future<void> resolveAccessContext() async {
    emit(state.copyWith(isLoading: true));

    try {
      final session = await _authRepository.getStoredSession();

      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: session != null,
          leadId: session?.leadId,
          customerId: session?.customerId,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          leadId: null,
          customerId: null,
        ),
      );
    }
  }

  bool shouldRestrictTab(DiscoveryTab tab) {
    return state.isTabRestricted(tab);
  }
}
