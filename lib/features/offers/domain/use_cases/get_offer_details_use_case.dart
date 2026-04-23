import '../entities/offer_details.dart';
import '../repositories/offers_repository.dart';

/// Fetches the full details of a specific offer.
class GetOfferDetailsUseCase {
  final OffersRepository _repository;

  const GetOfferDetailsUseCase(this._repository);

  Future<OfferDetails> call({required int offerId}) {
    return _repository.getOfferDetails(offerId: offerId);
  }
}
