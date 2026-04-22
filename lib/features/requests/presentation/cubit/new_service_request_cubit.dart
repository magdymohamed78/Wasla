import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../../core/types/load_status.dart';
import '../../../home/domain/entities/company_details.dart';
import '../../../home/domain/entities/service_request.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
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
  static const String fieldStreetRequired = 'new_request_field_street_required';
  static const String fieldCityRequired = 'new_request_field_city_required';
  static const String fieldCityInvalid = 'new_request_field_city_invalid';
  static const String fieldCountryRequired =
      'new_request_field_country_required';

  static final RegExp _cityValidationPattern = RegExp(
    r"^[A-Za-zÀ-ÖØ-öø-ÿ\u0600-\u06FF](?:[A-Za-zÀ-ÖØ-öø-ÿ\u0600-\u06FF\s'-]*[A-Za-zÀ-ÖØ-öø-ÿ\u0600-\u06FF])?$",
  );

  final SubmitServiceRequestUseCase _submitServiceRequestUseCase;
  final GetCompanyDetailsUseCase _getCompanyDetailsUseCase;
  final RefreshCustomerSessionUseCase _refreshCustomerSessionUseCase;
  final SessionCubit _sessionCubit;

  NewServiceRequestCubit({
    required int companyId,
    required SubmitServiceRequestUseCase submitServiceRequestUseCase,
    required GetCompanyDetailsUseCase getCompanyDetailsUseCase,
    required RefreshCustomerSessionUseCase refreshCustomerSessionUseCase,
    required SessionCubit sessionCubit,
  }) : _submitServiceRequestUseCase = submitServiceRequestUseCase,
       _getCompanyDetailsUseCase = getCompanyDetailsUseCase,
       _refreshCustomerSessionUseCase = refreshCustomerSessionUseCase,
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
      emit(
        state.copyWith(
          servicesLoadStatus: LoadStatus.success,
          availableServices: details.serviceCatalog,
        ),
      );
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
    emit(state.copyWith(selectedServices: current, serviceTypeError: null));
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
    final normalized = value.trim();

    if (_isZipCodeField(key)) {
      return null;
    }

    if (normalized.isEmpty) {
      if (_isStreetField(key)) {
        return fieldStreetRequired;
      }

      if (_isCityField(key)) {
        return fieldCityRequired;
      }

      if (_isCountryField(key)) {
        return fieldCountryRequired;
      }

      return fieldRequired;
    }

    if (_isCityField(key) && !_isValidCity(normalized)) {
      return fieldCityInvalid;
    }

    return null;
  }

  bool _isZipCodeField(String key) {
    return key == 'fromZipCode' || key == 'toZipCode';
  }

  bool _isStreetField(String key) {
    return key == 'fromStreet' || key == 'toStreet';
  }

  bool _isCityField(String key) {
    return key == 'fromCity' || key == 'toCity';
  }

  bool _isCountryField(String key) {
    return key == 'fromCountry' || key == 'toCountry';
  }

  bool _isValidCity(String value) {
    return _cityValidationPattern.hasMatch(value);
  }

  void preferredDateChanged(DateTime? value) {
    emit(state.copyWith(preferredDate: value, preferredDateError: null));
  }

  void preferredTimeSlotChanged(String value) {
    emit(
      state.copyWith(preferredTimeSlot: value, preferredTimeSlotError: null),
    );
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

    emit(
      state.copyWith(
        preferredDateError: dateError,
        preferredTimeSlotError: slotError,
      ),
    );
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
    if (state.isSubmitLocked) {
      return;
    }

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

    if (state.selectedServices.isEmpty) {
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

    final totalCount = state.selectedServices.length;

    emit(
      state.copyWith(
        role: currentRole,
        status: NewServiceRequestStatus.submitting,
        errorCode: null,
        leadUpgradeStatus: LeadUpgradeStatus.idle,
        navigateToRequests: false,
        totalRequests: totalCount,
        completedRequests: 0,
      ),
    );

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

      if (currentRole == SessionRole.lead) {
        await _handleLeadUpgradeFlow(lastSubmission: lastSubmission);
        return;
      }

      emit(
        state.copyWith(
          role: _sessionCubit.state.role,
          status: NewServiceRequestStatus.success,
          lastSubmission: lastSubmission,
          errorCode: null,
          leadUpgradeStatus: LeadUpgradeStatus.idle,
          navigateToRequests: true,
        ),
      );
    } catch (e, st) {
      debugPrint('[NewServiceRequestCubit] submit error: $e');
      debugPrint('[NewServiceRequestCubit] stack: $st');
      emit(
        state.copyWith(
          status: NewServiceRequestStatus.failure,
          errorCode: submitFailedError,
          leadUpgradeStatus: LeadUpgradeStatus.idle,
        ),
      );
    }
  }

  Future<void> retryRefreshUserProfile() async {
    if (state.status != NewServiceRequestStatus.success) {
      return;
    }

    if (state.leadUpgradeStatus == LeadUpgradeStatus.refreshing) {
      return;
    }

    await _refreshLeadSessionAndNavigate();
  }

  void consumeNavigateToRequests() {
    if (!state.navigateToRequests) return;
    emit(state.copyWith(navigateToRequests: false));
  }

  void retryLoadServices() {
    _loadAvailableServices();
  }

  Future<void> _handleLeadUpgradeFlow({
    required ServiceRequestSubmission? lastSubmission,
  }) async {
    emit(
      state.copyWith(
        role: _sessionCubit.state.role,
        status: NewServiceRequestStatus.success,
        lastSubmission: lastSubmission,
        errorCode: null,
        leadUpgradeStatus: LeadUpgradeStatus.refreshing,
        navigateToRequests: false,
      ),
    );

    await _refreshLeadSessionAndNavigate();
  }

  Future<void> _refreshLeadSessionAndNavigate() async {
    emit(
      state.copyWith(
        leadUpgradeStatus: LeadUpgradeStatus.refreshing,
        navigateToRequests: false,
      ),
    );

    final result = await _refreshCustomerSessionUseCase();
    if (isClosed) {
      return;
    }

    final nextRole = _sessionCubit.state.role;
    final upgraded =
        result == RefreshCustomerSessionResult.upgraded ||
        result == RefreshCustomerSessionResult.alreadyCustomer;

    if (upgraded) {
      emit(
        state.copyWith(
          role: nextRole,
          leadUpgradeStatus: LeadUpgradeStatus.upgraded,
          navigateToRequests: true,
        ),
      );
      return;
    }

    if (result == RefreshCustomerSessionResult.reauthRequired ||
        result == RefreshCustomerSessionResult.noSession) {
      emit(
        state.copyWith(
          role: nextRole,
          leadUpgradeStatus: LeadUpgradeStatus.reauthRequired,
          navigateToRequests: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        role: nextRole,
        leadUpgradeStatus: LeadUpgradeStatus.failed,
        navigateToRequests: false,
      ),
    );
  }
}
