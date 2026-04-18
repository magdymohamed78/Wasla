import '../entities/customer_offer_summary.dart';
import '../../../offers/domain/entities/offer_page_result.dart';

abstract class CustomerOffersRepository {
  Future<List<CustomerOfferSummary>> getCustomerOffers({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<OfferPageResult> getCustomerOffersPaged({
    required int pageIndex,
    required int pageSize,
    String? status,
  });
}
