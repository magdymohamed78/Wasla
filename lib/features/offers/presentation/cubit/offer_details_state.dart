import '../../../../core/types/load_status.dart';
import '../../domain/entities/offer_details.dart';

/// Immutable state for the offer details screen.
class OfferDetailsState {
  static const String notFoundError = 'NOT_FOUND';
  static const String accessDeniedError = 'ACCESS_DENIED';
  static const String loadFailedError = 'LOAD_FAILED';

  final int offerId;
  final LoadStatus status;
  final OfferDetails? details;
  final String? errorCode;

  const OfferDetailsState({
    required this.offerId,
    this.status = LoadStatus.initial,
    this.details,
    this.errorCode,
  });

  OfferDetailsState copyWith({
    LoadStatus? status,
    OfferDetails? details,
    String? errorCode,
  }) {
    return OfferDetailsState(
      offerId: offerId,
      status: status ?? this.status,
      details: details ?? this.details,
      errorCode: errorCode,
    );
  }
}
