class CustomerOfferSummary {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? status;
  final String? serviceTypeOverall;
  final double totalAmount;
  final DateTime? issueDate;

  const CustomerOfferSummary({
    required this.offerId,
    required this.companyId,
    required this.totalAmount,
    this.offerNumber,
    this.companyName,
    this.status,
    this.serviceTypeOverall,
    this.issueDate,
  });
}
