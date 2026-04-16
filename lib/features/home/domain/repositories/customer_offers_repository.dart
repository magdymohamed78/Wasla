import '../entities/customer_offer_summary.dart';

abstract class CustomerOffersRepository {
  Future<List<CustomerOfferSummary>> getCustomerOffers({
    int pageIndex,
    int pageSize,
    String? status,
  });
}
