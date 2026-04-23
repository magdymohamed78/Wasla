/// Domain entity for an additional cost line within a service line item.
class AdditionalCostSummary {
  final String? description;
  final double price;

  const AdditionalCostSummary({
    this.description,
    this.price = 0,
  });
}
