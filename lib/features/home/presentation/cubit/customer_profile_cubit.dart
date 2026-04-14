import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_portal_content.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/customer_portal_use_cases.dart';

class CustomerProfileState {
  final LoadStatus status;
  final CustomerPortalProfile? profile;
  final String? errorMessage;

  const CustomerProfileState({
    this.status = LoadStatus.initial,
    this.profile,
    this.errorMessage,
  });

  CustomerProfileState copyWith({
    LoadStatus? status,
    CustomerPortalProfile? profile,
    String? errorMessage,
  }) {
    return CustomerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }
}

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  static const String loadFailedError = 'customer_profile_load_failed';

  final GetCustomerProfileUseCase _getCustomerProfileUseCase;

  CustomerProfileCubit({
    required GetCustomerProfileUseCase getCustomerProfileUseCase,
  }) : _getCustomerProfileUseCase = getCustomerProfileUseCase,
       super(const CustomerProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, errorMessage: null));

    try {
      final profile = await _getCustomerProfileUseCase();
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
