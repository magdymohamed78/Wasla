import '../repositories/offers_repository.dart';

/// Rejects an offer with a required reason.
class RejectOfferUseCase {
  final OffersRepository _repository;

  const RejectOfferUseCase(this._repository);

  Future<void> call({
    required int offerId,
    required String rejectionReason,
  }) {
    return _repository.rejectOffer(
      offerId: offerId,
      rejectionReason: rejectionReason,
    );
  }
}
