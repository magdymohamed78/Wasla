import '../../../../core/types/load_status.dart';
import '../../domain/entities/payment_method.dart';

/// Immutable state for the accept offer screen.
class AcceptOfferState {
  static const String terminalStateError = 'TERMINAL_STATE';
  static const String forbiddenError = 'FORBIDDEN';
  static const String paymentConfigMissingError = 'PAYMENT_CONFIG_MISSING';
  static const String genericError = 'GENERIC';

  final int offerId;
  final LoadStatus status;
  final PaymentMethod? selectedPaymentMethod;
  final String signature;
  final bool isConfirmed;
  final bool isSubmitting;
  final String? errorCode;
  final String? checkoutUrl;

  const AcceptOfferState({
    required this.offerId,
    this.status = LoadStatus.initial,
    this.selectedPaymentMethod,
    this.signature = '',
    this.isConfirmed = false,
    this.isSubmitting = false,
    this.errorCode,
    this.checkoutUrl,
  });

  AcceptOfferState copyWith({
    LoadStatus? status,
    PaymentMethod? selectedPaymentMethod,
    String? signature,
    bool? isConfirmed,
    bool? isSubmitting,
    String? errorCode,
    String? checkoutUrl,
  }) {
    return AcceptOfferState(
      offerId: offerId,
      status: status ?? this.status,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      signature: signature ?? this.signature,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorCode: errorCode,
      checkoutUrl: checkoutUrl,
    );
  }
}
