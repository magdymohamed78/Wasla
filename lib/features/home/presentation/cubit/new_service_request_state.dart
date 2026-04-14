import '../../../../core/session/session_state.dart';
import '../../domain/entities/service_request.dart';

enum NewServiceRequestStatus { initial, submitting, success, failure }

class NewServiceRequestState {
  static const Object _unset = Object();

  final int companyId;
  final SessionRole role;
  final NewServiceRequestStatus status;
  final String serviceType;
  final String fromStreet;
  final String fromCity;
  final String fromZipCode;
  final String fromCountry;
  final String toStreet;
  final String toCity;
  final String toZipCode;
  final String toCountry;
  final DateTime? preferredDate;
  final String preferredTimeSlot;
  final String notes;
  final ServiceRequestSubmission? submission;
  final String? errorCode;
  final bool isLeadReloginPromptVisible;
  final bool navigateToRequests;

  const NewServiceRequestState({
    required this.companyId,
    required this.role,
    this.status = NewServiceRequestStatus.initial,
    this.serviceType = '',
    this.fromStreet = '',
    this.fromCity = '',
    this.fromZipCode = '',
    this.fromCountry = '',
    this.toStreet = '',
    this.toCity = '',
    this.toZipCode = '',
    this.toCountry = '',
    this.preferredDate,
    this.preferredTimeSlot = '',
    this.notes = '',
    this.submission,
    this.errorCode,
    this.isLeadReloginPromptVisible = false,
    this.navigateToRequests = false,
  });

  bool get canSubmit {
    return companyId > 0 &&
        serviceType.trim().isNotEmpty &&
        status != NewServiceRequestStatus.submitting;
  }

  NewServiceRequestState copyWith({
    int? companyId,
    SessionRole? role,
    NewServiceRequestStatus? status,
    String? serviceType,
    String? fromStreet,
    String? fromCity,
    String? fromZipCode,
    String? fromCountry,
    String? toStreet,
    String? toCity,
    String? toZipCode,
    String? toCountry,
    Object? preferredDate = _unset,
    String? preferredTimeSlot,
    String? notes,
    Object? submission = _unset,
    Object? errorCode = _unset,
    bool? isLeadReloginPromptVisible,
    bool? navigateToRequests,
  }) {
    return NewServiceRequestState(
      companyId: companyId ?? this.companyId,
      role: role ?? this.role,
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
      fromStreet: fromStreet ?? this.fromStreet,
      fromCity: fromCity ?? this.fromCity,
      fromZipCode: fromZipCode ?? this.fromZipCode,
      fromCountry: fromCountry ?? this.fromCountry,
      toStreet: toStreet ?? this.toStreet,
      toCity: toCity ?? this.toCity,
      toZipCode: toZipCode ?? this.toZipCode,
      toCountry: toCountry ?? this.toCountry,
      preferredDate: identical(preferredDate, _unset)
          ? this.preferredDate
          : preferredDate as DateTime?,
      preferredTimeSlot: preferredTimeSlot ?? this.preferredTimeSlot,
      notes: notes ?? this.notes,
      submission: identical(submission, _unset)
          ? this.submission
          : submission as ServiceRequestSubmission?,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
      isLeadReloginPromptVisible:
          isLeadReloginPromptVisible ?? this.isLeadReloginPromptVisible,
      navigateToRequests: navigateToRequests ?? this.navigateToRequests,
    );
  }
}
