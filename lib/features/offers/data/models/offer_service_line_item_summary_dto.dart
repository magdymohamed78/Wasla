import '../../../home/data/models/json_helpers.dart';
import '../../domain/entities/offer_service_line_item.dart';
import 'additional_cost_summary_dto.dart';

/// Data transfer object for [OfferServiceLineItemSummaryDto] from the API.
class OfferServiceLineItemSummaryDto {
  final String? serviceType;
  final double totalLinePrice;
  final Map<String, dynamic>? serviceDetails;
  final List<AdditionalCostSummaryDto> additionalCosts;

  const OfferServiceLineItemSummaryDto({
    this.serviceType,
    this.totalLinePrice = 0,
    this.serviceDetails,
    this.additionalCosts = const [],
  });

  factory OfferServiceLineItemSummaryDto.fromJson(Map<String, dynamic> json) {
    final rawCosts = json['additionalCosts'] as List<dynamic>?;
    return OfferServiceLineItemSummaryDto(
      serviceType: asString(json['serviceType']),
      totalLinePrice: asDouble(json['totalLinePrice']),
      serviceDetails: json['serviceDetails'] is Map<String, dynamic>
          ? json['serviceDetails'] as Map<String, dynamic>
          : null,
      additionalCosts: rawCosts
              ?.map(
                (e) => AdditionalCostSummaryDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(growable: false) ??
          const [],
    );
  }

  OfferServiceLineItem toDomain() {
    return OfferServiceLineItem(
      serviceType: serviceType,
      totalLinePrice: totalLinePrice,
      serviceDetails: serviceDetails,
      additionalCosts: additionalCosts
          .map((c) => c.toDomain())
          .toList(growable: false),
    );
  }
}
