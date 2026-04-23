import 'additional_cost_summary.dart';

/// Domain entity for a service line item within an offer.
///
/// [serviceDetails] is a dynamic map because the API schema is untyped —
/// different service types (Cleaning, Moving, etc.) store different keys.
class OfferServiceLineItem {
  final String? serviceType;
  final double totalLinePrice;
  final Map<String, dynamic>? serviceDetails;
  final List<AdditionalCostSummary> additionalCosts;

  const OfferServiceLineItem({
    this.serviceType,
    this.totalLinePrice = 0,
    this.serviceDetails,
    this.additionalCosts = const [],
  });
}
