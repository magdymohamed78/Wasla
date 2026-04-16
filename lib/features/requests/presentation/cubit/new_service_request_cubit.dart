import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../home/domain/entities/service_request.dart';
import '../../../home/domain/use_cases/service_request_use_cases.dart';
import 'new_service_request_state.dart';

class NewServiceRequestCubit extends Cubit<NewServiceRequestState> {
  static const String invalidCompanyIdError = 'new_request_invalid_company_id';
  static const String serviceTypeRequiredError =
      'new_request_service_type_required';
  static const String submitFailedError = 'new_request_submit_failed';
  static const String guestNotAllowedError = 'new_request_guest_not_allowed';

  final SubmitServiceRequestUseCase _submitServiceRequestUseCase;
  final SessionCubit _sessionCubit;

  NewServiceRequestCubit({
    required int companyId,
    required SubmitServiceRequestUseCase submitServiceRequestUseCase,
    required SessionCubit sessionCubit,
  }) : _submitServiceRequestUseCase = submitServiceRequestUseCase,
       _sessionCubit = sessionCubit,
       super(
         NewServiceRequestState(
           companyId: companyId,
           role: sessionCubit.state.role,
         ),
       );

  void serviceTypeChanged(String value) {
    emit(state.copyWith(serviceType: value, errorCode: null));
  }

  void fromStreetChanged(String value) {
    emit(state.copyWith(fromStreet: value, errorCode: null));
  }

  void fromCityChanged(String value) {
    emit(state.copyWith(fromCity: value, errorCode: null));
  }

  void fromZipCodeChanged(String value) {
    emit(state.copyWith(fromZipCode: value, errorCode: null));
  }

  void fromCountryChanged(String value) {
    emit(state.copyWith(fromCountry: value, errorCode: null));
  }

  void toStreetChanged(String value) {
    emit(state.copyWith(toStreet: value, errorCode: null));
  }

  void toCityChanged(String value) {
    emit(state.copyWith(toCity: value, errorCode: null));
  }

  void toZipCodeChanged(String value) {
    emit(state.copyWith(toZipCode: value, errorCode: null));
  }

  void toCountryChanged(String value) {
    emit(state.copyWith(toCountry: value, errorCode: null));
  }

  void preferredDateChanged(DateTime? value) {
    emit(state.copyWith(preferredDate: value, errorCode: null));
  }

  void preferredTimeSlotChanged(String value) {
    emit(state.copyWith(preferredTimeSlot: value, errorCode: null));
  }

  void notesChanged(String value) {
    emit(state.copyWith(notes: value, errorCode: null));
  }

  Future<void> submit() async {
    final currentRole = _sessionCubit.state.role;

    if (state.companyId <= 0) {
      emit(
        state.copyWith(
          status: NewServiceRequestStatus.failure,
          errorCode: invalidCompanyIdError,
        ),
      );
      return;
    }

    if (state.serviceType.trim().isEmpty) {
      emit(
        state.copyWith(
          status: NewServiceRequestStatus.failure,
          errorCode: serviceTypeRequiredError,
        ),
      );
      return;
    }

    if (currentRole == SessionRole.guest) {
      emit(
        state.copyWith(
          status: NewServiceRequestStatus.failure,
          errorCode: guestNotAllowedError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        role: currentRole,
        status: NewServiceRequestStatus.submitting,
        errorCode: null,
        isLeadReloginPromptVisible: false,
        navigateToRequests: false,
      ),
    );

    try {
      final submission = await _submitServiceRequestUseCase(
        input: SubmitServiceRequestInput(
          companyId: state.companyId,
          serviceType: state.serviceType,
          fromStreet: state.fromStreet,
          fromCity: state.fromCity,
          fromZipCode: state.fromZipCode,
          fromCountry: state.fromCountry,
          toStreet: state.toStreet,
          toCity: state.toCity,
          toZipCode: state.toZipCode,
          toCountry: state.toCountry,
          preferredDate: state.preferredDate,
          preferredTimeSlot: state.preferredTimeSlot,
          notes: state.notes,
        ),
      );

      final shouldPromptRelogin = currentRole == SessionRole.lead;

      emit(
        state.copyWith(
          role: currentRole,
          status: NewServiceRequestStatus.success,
          submission: submission,
          errorCode: null,
          isLeadReloginPromptVisible: shouldPromptRelogin,
          navigateToRequests: !shouldPromptRelogin,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NewServiceRequestStatus.failure,
          errorCode: submitFailedError,
        ),
      );
    }
  }

  void dismissLeadReloginPrompt() {
    if (!state.isLeadReloginPromptVisible) {
      return;
    }

    emit(state.copyWith(isLeadReloginPromptVisible: false));
  }

  void consumeNavigateToRequests() {
    if (!state.navigateToRequests) {
      return;
    }

    emit(state.copyWith(navigateToRequests: false));
  }
}
