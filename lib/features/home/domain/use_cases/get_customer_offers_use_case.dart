import '../entities/customer_offer_summary.dart';
import '../repositories/customer_portal_repository.dart';

class GetCustomerOffersUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerOffersUseCase(this._repository);

  Future<List<CustomerOfferSummary>> call({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) {
    return _repository.getCustomerOffers(
      pageIndex: pageIndex,
      pageSize: pageSize,
      status: status,
    );
  }
}
