import '../entities/payment_method.dart';
import '../repositories/offers_repository.dart';

/// Accepts an offer with a digital signature and payment method.
///
/// Returns an optional checkout URL for online payments.
class AcceptOfferUseCase {
  final OffersRepository _repository;

  const AcceptOfferUseCase(this._repository);

  Future<String?> call({
    required int offerId,
    required String digitalSignature,
    required PaymentMethod paymentMethod,
  }) {
    return _repository.acceptOffer(
      offerId: offerId,
      digitalSignature: digitalSignature,
      paymentMethod: paymentMethod,
    );
  }
}
