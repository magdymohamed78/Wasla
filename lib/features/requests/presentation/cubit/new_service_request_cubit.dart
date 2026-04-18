import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../../core/types/load_status.dart';
import '../../../home/domain/entities/company_details.dart';
import '../../../home/domain/entities/service_request.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';
import '../../../home/domain/use_cases/service_request_use_cases.dart';
import 'new_service_request_state.dart';

class NewServiceRequestCubit extends Cubit<NewServiceRequestState> {
  static const String invalidCompanyIdError = 'new_request_invalid_company_id';
  static const String serviceTypeRequiredError =
      'new_request_service_type_required';
  static const String submitFailedError = 'new_request_submit_failed';
  static const String guestNotAllowedError = 'new_request_guest_not_allowed';
  static const String fieldRequired = 'new_request_field_required';

  final SubmitServiceRequestUseCase _submitServiceRequestUseCase;
  final GetCompanyDetailsUseCase _getCompanyDetailsUseCase;
  final SessionCubit _sessionCubit;

  NewServiceRequestCubit({
    required int companyId,
    required SubmitServiceRequestUseCase submitServiceRequestUseCase,
    required GetCompanyDetailsUseCase getCompanyDetailsUseCase,
    required SessionCubit sessionCubit,
  }) : _submitServiceRequestUseCase = submitServiceRequestUseCase,
       _getCompanyDetailsUseCase = getCompanyDetailsUseCase,
       _sessionCubit = sessionCubit,
       super(
         NewServiceRequestState(
           companyId: companyId,
           role: sessionCubit.state.role,
         ),
       ) {
    _loadAvailableServices();
  }

  Future<void> _loadAvailableServices() async {
    emit(state.copyWith(servicesLoadStatus: LoadStatus.loading));

    try {
      final details = await _getCompanyDetailsUseCase(state.companyId);
      emit(state.copyWith(
        servicesLoadStatus: LoadStatus.success,
        availableServices: details.serviceCatalog,
      ));
    } catch (e, st) {
      debugPrint('[NewServiceRequestCubit] load services error: $e');
      debugPrint('[NewServiceRequestCubit] stack: $st');
      emit(state.copyWith(servicesLoadStatus: LoadStatus.error));
    }
  }

  void toggleServiceType(CompanyServiceItem service) {
    final current = List<CompanyServiceItem>.from(state.selectedServices);
    final index = current.indexWhere((s) => s.name == service.name);
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(service);
    }
    emit(state.copyWith(
      selectedServices: current,
      serviceTypeError: null,
    ));
  }

  void removeServiceType(CompanyServiceItem service) {
    final current = List<CompanyServiceItem>.from(state.selectedServices)
      ..removeWhere((s) => s.name == service.name);
    emit(state.copyWith(selectedServices: current));
  }

  void fieldChanged(String key, String value) {
    var newState = state;
    switch (key) {
      case 'fromStreet':
        newState = newState.copyWith(fromStreet: value);
      case 'fromCity':
        newState = newState.copyWith(fromCity: value);
      case 'fromZipCode':
        newState = newState.copyWith(fromZipCode: value);
      case 'fromCountry':
        newState = newState.copyWith(fromCountry: value);
      case 'toStreet':
        newState = newState.copyWith(toStreet: value);
      case 'toCity':
        newState = newState.copyWith(toCity: value);
      case 'toZipCode':
        newState = newState.copyWith(toZipCode: value);
      case 'toCountry':
        newState = newState.copyWith(toCountry: value);
    }

    if (state.touchedFields.contains(key)) {
      final errors = Map<String, String?>.from(state.fieldErrors);
      errors[key] = _validateField(key, value);
      newState = newState.copyWith(fieldErrors: errors);
    }

    emit(newState);
  }

  void fieldBlurred(String key) {
    final touched = Set<String>.from(state.touchedFields)..add(key);
    final errors = Map<String, String?>.from(state.fieldErrors);

    final value = _getFieldValue(key);
    errors[key] = _validateField(key, value);

    emit(state.copyWith(touchedFields: touched, fieldErrors: errors));
  }

  String _getFieldValue(String key) {
    switch (key) {
      case 'fromStreet':
        return state.fromStreet;
      case 'fromCity':
        return state.fromCity;
      case 'fromZipCode':
        return state.fromZipCode;
      case 'fromCountry':
        return state.fromCountry;
      case 'toStreet':
        return state.toStreet;
      case 'toCity':
        return state.toCity;
      case 'toZipCode':
        return state.toZipCode;
      case 'toCountry':
        return state.toCountry;
      default:
        return '';
    }
  }

  String? _validateField(String key, String value) {
    final isOptional = key == 'fromZipCode' || key == 'toZipCode';
    if (isOptional) return null;
    if (value.trim().isEmpty) return fieldRequired;
    return null;
  }

  void preferredDateChanged(DateTime? value) {
    emit(state.copyWith(
      preferredDate: value,
      preferredDateError: null,
    ));
  }

  void preferredTimeSlotChanged(String value) {
    emit(state.copyWith(
      preferredTimeSlot: value,
      preferredTimeSlotError: null,
    ));
  }

  void notesChanged(String value) {
    emit(state.copyWith(notes: value));
  }

  bool validateStep(int step) {
    switch (step) {
      case 0:
        return _validateStep1();
      case 1:
        return _validateStep2();
      case 2:
        return _validateStep3();
      default:
        return false;
    }
  }

  bool _validateStep1() {
    if (state.selectedServices.isEmpty) {
      emit(state.copyWith(serviceTypeError: serviceTypeRequiredError));
      return false;
    }
    emit(state.copyWith(serviceTypeError: null));
    return true;
  }

  bool _validateStep2() {
    final requiredFields = [
      'fromStreet',
      'fromCity',
      'fromCountry',
      'toStreet',
      'toCity',
      'toCountry',
    ];

    final touched = Set<String>.from(state.touchedFields);
    final errors = Map<String, String?>.from(state.fieldErrors);
    bool valid = true;

    for (final key in requiredFields) {
      touched.add(key);
      final value = _getFieldValue(key);
      final error = _validateField(key, value);
      errors[key] = error;
      if (error != null) valid = false;
    }

    emit(state.copyWith(touchedFields: touched, fieldErrors: errors));
    return valid;
  }

  bool _validateStep3() {
    bool valid = true;
    String? dateError;
    String? slotError;

    if (state.preferredDate == null) {
      dateError = fieldRequired;
      valid = false;
    }
    if (state.preferredTimeSlot.trim().isEmpty) {
      slotError = fieldRequired;
      valid = false;
    }

    emit(state.copyWith(
      preferredDateError: dateError,
      preferredTimeSlotError: slotError,
    ));
    return valid;
  }

  void nextStep() {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  Future<void> submit() async {
    final currentRole = _sessionCubit.state.role;

    if (state.companyId <= 0) {
      emit(state.copyWith(
        status: NewServiceRequestStatus.failure,
        errorCode: invalidCompanyIdError,
      ));
      return;
    }

    if (state.selectedServices.isEmpty) {
      emit(state.copyWith(
        status: NewServiceRequestStatus.failure,
        errorCode: serviceTypeRequiredError,
      ));
      return;
    }

    if (currentRole == SessionRole.guest) {
      emit(state.copyWith(
        status: NewServiceRequestStatus.failure,
        errorCode: guestNotAllowedError,
      ));
      return;
    }

    final totalCount = state.selectedServices.length;

    emit(state.copyWith(
      role: currentRole,
      status: NewServiceRequestStatus.submitting,
      errorCode: null,
      isLeadReloginPromptVisible: false,
      navigateToRequests: false,
      totalRequests: totalCount,
      completedRequests: 0,
    ));

    int completed = 0;
    ServiceRequestSubmission? lastSubmission;

    try {
      for (final service in state.selectedServices) {
        final input = SubmitServiceRequestInput(
          companyId: state.companyId,
          serviceType: service.name,
          fromStreet: state.fromStreet.trim(),
          fromCity: state.fromCity.trim(),
          fromZipCode: state.fromZipCode.trim(),
          fromCountry: state.fromCountry.trim(),
          toStreet: state.toStreet.trim(),
          toCity: state.toCity.trim(),
          toZipCode: state.toZipCode.trim(),
          toCountry: state.toCountry.trim(),
          preferredDate: state.preferredDate,
          preferredTimeSlot: state.preferredTimeSlot.trim(),
          notes: state.notes.trim(),
        );

        lastSubmission = await _submitServiceRequestUseCase(input: input);
        completed++;
        emit(state.copyWith(completedRequests: completed));
      }

      final shouldPromptRelogin = currentRole == SessionRole.lead;

      emit(state.copyWith(
        role: currentRole,
        status: NewServiceRequestStatus.success,
        lastSubmission: lastSubmission,
        errorCode: null,
        isLeadReloginPromptVisible: shouldPromptRelogin,
        navigateToRequests: !shouldPromptRelogin,
      ));
    } catch (e, st) {
      debugPrint('[NewServiceRequestCubit] submit error: $e');
      debugPrint('[NewServiceRequestCubit] stack: $st');
      emit(state.copyWith(
        status: NewServiceRequestStatus.failure,
        errorCode: submitFailedError,
      ));
    }
  }

  void dismissLeadReloginPrompt() {
    if (!state.isLeadReloginPromptVisible) return;
    emit(state.copyWith(isLeadReloginPromptVisible: false));
  }

  void consumeNavigateToRequests() {
    if (!state.navigateToRequests) return;
    emit(state.copyWith(navigateToRequests: false));
  }

  void retryLoadServices() {
    _loadAvailableServices();
  }
}
