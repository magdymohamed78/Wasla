import '../../domain/entities/offer_details.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/offers_repository.dart';
import '../data_sources/offers_remote_data_source.dart';

/// Concrete implementation of [OffersRepository] backed by [OffersRemoteDataSource].
class OffersRepositoryImpl implements OffersRepository {
  final OffersRemoteDataSource _remote;

  const OffersRepositoryImpl({required OffersRemoteDataSource remote})
      : _remote = remote;

  @override
  Future<OfferDetails> getOfferDetails({required int offerId}) async {
    final dto = await _remote.getOfferDetails(offerId);
    return dto.toDomain();
  }

  @override
  Future<String?> acceptOffer({
    required int offerId,
    required String digitalSignature,
    required PaymentMethod paymentMethod,
  }) async {
    final response = await _remote.acceptOffer(
      offerId: offerId,
      digitalSignature: digitalSignature,
      paymentMethod: paymentMethod.toApiValue(),
    );
    return response.checkoutUrl;
  }

  @override
  Future<void> rejectOffer({
    required int offerId,
    required String rejectionReason,
  }) async {
    await _remote.rejectOffer(
      offerId: offerId,
      rejectionReason: rejectionReason,
    );
  }
}
