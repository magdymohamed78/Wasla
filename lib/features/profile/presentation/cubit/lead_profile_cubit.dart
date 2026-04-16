import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/customer_portal_content.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';

class LeadProfileState {
  final LoadStatus status;
  final LeadPortalProfile? profile;
  final String? errorMessage;

  const LeadProfileState({
    this.status = LoadStatus.initial,
    this.profile,
    this.errorMessage,
  });

  LeadProfileState copyWith({
    LoadStatus? status,
    LeadPortalProfile? profile,
    String? errorMessage,
  }) {
    return LeadProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }
}

class LeadProfileCubit extends Cubit<LeadProfileState> {
  static const String loadFailedError = 'lead_profile_load_failed';

  final GetLeadProfileUseCase _getLeadProfileUseCase;

  LeadProfileCubit({required GetLeadProfileUseCase getLeadProfileUseCase})
    : _getLeadProfileUseCase = getLeadProfileUseCase,
      super(const LeadProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, errorMessage: null));

    try {
      final profile = await _getLeadProfileUseCase();
      emit(
        state.copyWith(
          status: LoadStatus.success,
          profile: profile,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(status: LoadStatus.error, errorMessage: loadFailedError),
      );
    }
  }
}
