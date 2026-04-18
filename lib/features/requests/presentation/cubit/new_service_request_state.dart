import '../../../../core/session/session_state.dart';
import '../../../../core/types/load_status.dart';
import '../../../home/domain/entities/company_details.dart';
import '../../../home/domain/entities/service_request.dart';

enum NewServiceRequestStatus { initial, submitting, success, failure }

class NewServiceRequestState {
  static const Object _unset = Object();

  final int companyId;
  final SessionRole role;
  final int currentStep;
  final NewServiceRequestStatus status;

  final LoadStatus servicesLoadStatus;
  final List<CompanyServiceItem> availableServices;
  final List<CompanyServiceItem> selectedServices;
  final String? serviceTypeError;

  final String fromStreet;
  final String fromCity;
  final String fromZipCode;
  final String fromCountry;
  final String toStreet;
  final String toCity;
  final String toZipCode;
  final String toCountry;
  final Map<String, String?> fieldErrors;
  final Set<String> touchedFields;

  final DateTime? preferredDate;
  final String preferredTimeSlot;
  final String notes;
  final String? preferredDateError;
  final String? preferredTimeSlotError;

  final ServiceRequestSubmission? lastSubmission;
  final String? errorCode;
  final bool isLeadReloginPromptVisible;
  final bool navigateToRequests;
  final int totalRequests;
  final int completedRequests;

  const NewServiceRequestState({
    required this.companyId,
    required this.role,
    this.currentStep = 0,
    this.status = NewServiceRequestStatus.initial,
    this.servicesLoadStatus = LoadStatus.initial,
    this.availableServices = const <CompanyServiceItem>[],
    this.selectedServices = const <CompanyServiceItem>[],
    this.serviceTypeError,
    this.fromStreet = '',
    this.fromCity = '',
    this.fromZipCode = '',
    this.fromCountry = '',
    this.toStreet = '',
    this.toCity = '',
    this.toZipCode = '',
    this.toCountry = '',
    this.fieldErrors = const <String, String?>{},
    this.touchedFields = const <String>{},
    this.preferredDate,
    this.preferredTimeSlot = '',
    this.notes = '',
    this.preferredDateError,
    this.preferredTimeSlotError,
    this.lastSubmission,
    this.errorCode,
    this.isLeadReloginPromptVisible = false,
    this.navigateToRequests = false,
    this.totalRequests = 0,
    this.completedRequests = 0,
  });

  bool get isSubmitting => status == NewServiceRequestStatus.submitting;

  NewServiceRequestState copyWith({
    int? companyId,
    SessionRole? role,
    int? currentStep,
    NewServiceRequestStatus? status,
    LoadStatus? servicesLoadStatus,
    List<CompanyServiceItem>? availableServices,
    List<CompanyServiceItem>? selectedServices,
    Object? serviceTypeError = _unset,
    String? fromStreet,
    String? fromCity,
    String? fromZipCode,
    String? fromCountry,
    String? toStreet,
    String? toCity,
    String? toZipCode,
    String? toCountry,
    Map<String, String?>? fieldErrors,
    Set<String>? touchedFields,
    Object? preferredDate = _unset,
    String? preferredTimeSlot,
    String? notes,
    Object? preferredDateError = _unset,
    Object? preferredTimeSlotError = _unset,
    Object? lastSubmission = _unset,
    Object? errorCode = _unset,
    bool? isLeadReloginPromptVisible,
    bool? navigateToRequests,
    int? totalRequests,
    int? completedRequests,
  }) {
    return NewServiceRequestState(
      companyId: companyId ?? this.companyId,
      role: role ?? this.role,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      servicesLoadStatus: servicesLoadStatus ?? this.servicesLoadStatus,
      availableServices: availableServices ?? this.availableServices,
      selectedServices: selectedServices ?? this.selectedServices,
      serviceTypeError: identical(serviceTypeError, _unset)
          ? this.serviceTypeError
          : serviceTypeError as String?,
      fromStreet: fromStreet ?? this.fromStreet,
      fromCity: fromCity ?? this.fromCity,
      fromZipCode: fromZipCode ?? this.fromZipCode,
      fromCountry: fromCountry ?? this.fromCountry,
      toStreet: toStreet ?? this.toStreet,
      toCity: toCity ?? this.toCity,
      toZipCode: toZipCode ?? this.toZipCode,
      toCountry: toCountry ?? this.toCountry,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      touchedFields: touchedFields ?? this.touchedFields,
      preferredDate: identical(preferredDate, _unset)
          ? this.preferredDate
          : preferredDate as DateTime?,
      preferredTimeSlot: preferredTimeSlot ?? this.preferredTimeSlot,
      notes: notes ?? this.notes,
      preferredDateError: identical(preferredDateError, _unset)
          ? this.preferredDateError
          : preferredDateError as String?,
      preferredTimeSlotError: identical(preferredTimeSlotError, _unset)
          ? this.preferredTimeSlotError
          : preferredTimeSlotError as String?,
      lastSubmission: identical(lastSubmission, _unset)
          ? this.lastSubmission
          : lastSubmission as ServiceRequestSubmission?,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
      isLeadReloginPromptVisible:
          isLeadReloginPromptVisible ?? this.isLeadReloginPromptVisible,
      navigateToRequests: navigateToRequests ?? this.navigateToRequests,
      totalRequests: totalRequests ?? this.totalRequests,
      completedRequests: completedRequests ?? this.completedRequests,
    );
  }
}
