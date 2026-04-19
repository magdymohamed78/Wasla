import '../../../../core/session/session_state.dart';

enum CompanyReviewSubmitErrorCode {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  server,
  network,
}

class CompanyReviewSubmitResult {
  final bool success;
  final CompanyReviewSubmitErrorCode? errorCode;
  final String? problemTitle;
  final String? problemDetail;

  const CompanyReviewSubmitResult.success()
    : success = true,
      errorCode = null,
      problemTitle = null,
      problemDetail = null;

  const CompanyReviewSubmitResult.failure({
    required this.errorCode,
    this.problemTitle,
    this.problemDetail,
  }) : success = false;
}

class CompanyReviewActionState {
  final SessionRole role;
  final bool isEligibilityLoading;
  final bool isConnectedCustomer;
  final bool isSubmitting;

  const CompanyReviewActionState({
    this.role = SessionRole.guest,
    this.isEligibilityLoading = false,
    this.isConnectedCustomer = false,
    this.isSubmitting = false,
  });

  bool get isCustomerRole => role == SessionRole.customer;

  bool get canWriteReview =>
      isCustomerRole && !isEligibilityLoading && isConnectedCustomer;

  bool get shouldShowNotConnectedInfo =>
      isCustomerRole && !isEligibilityLoading && !isConnectedCustomer;

  CompanyReviewActionState copyWith({
    SessionRole? role,
    bool? isEligibilityLoading,
    bool? isConnectedCustomer,
    bool? isSubmitting,
  }) {
    return CompanyReviewActionState(
      role: role ?? this.role,
      isEligibilityLoading: isEligibilityLoading ?? this.isEligibilityLoading,
      isConnectedCustomer: isConnectedCustomer ?? this.isConnectedCustomer,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
