import '../entities/offer_details.dart';
import '../entities/payment_method.dart';

/// Abstract repository for offer detail operations (get, accept, reject).
///
/// The listing (paged) operations remain in [CustomerOffersRepository].
abstract class OffersRepository {
  /// Fetches full details for a specific offer.
  Future<OfferDetails> getOfferDetails({required int offerId});

  /// Accepts an offer with a digital signature and payment method.
  ///
  /// Returns an optional checkout URL for online payments.
  /// Returns `null` for COD payments.
  Future<String?> acceptOffer({
    required int offerId,
    required String digitalSignature,
    required PaymentMethod paymentMethod,
  });

  /// Rejects an offer with a reason.
  Future<void> rejectOffer({
    required int offerId,
    required String rejectionReason,
  });
}
