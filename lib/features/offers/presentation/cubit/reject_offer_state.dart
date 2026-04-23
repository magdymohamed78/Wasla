import '../../../../core/types/load_status.dart';

/// Immutable state for the reject offer screen.
class RejectOfferState {
  static const String terminalStateError = 'TERMINAL_STATE';
  static const String forbiddenError = 'FORBIDDEN';
  static const String genericError = 'GENERIC';

  final int offerId;
  final LoadStatus status;
  final String rejectionReason;
  final bool isSubmitting;
  final String? errorCode;

  const RejectOfferState({
    required this.offerId,
    this.status = LoadStatus.initial,
    this.rejectionReason = '',
    this.isSubmitting = false,
    this.errorCode,
  });

  RejectOfferState copyWith({
    LoadStatus? status,
    String? rejectionReason,
    bool? isSubmitting,
    String? errorCode,
  }) {
    return RejectOfferState(
      offerId: offerId,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorCode: errorCode,
    );
  }
}
