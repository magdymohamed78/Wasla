import '../../../home/data/models/json_helpers.dart';
import '../../domain/entities/additional_cost_summary.dart';

/// Data transfer object for [AdditionalCostSummaryDto] from the API.
class AdditionalCostSummaryDto {
  final String? description;
  final double price;

  const AdditionalCostSummaryDto({
    this.description,
    this.price = 0,
  });

  factory AdditionalCostSummaryDto.fromJson(Map<String, dynamic> json) {
    return AdditionalCostSummaryDto(
      description: asString(json['description']),
      price: asDouble(json['price']),
    );
  }

  AdditionalCostSummary toDomain() {
    return AdditionalCostSummary(
      description: description,
      price: price,
    );
  }
}
