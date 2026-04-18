import 'offer_filter.dart';

class OfferSummaryItem {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? status;
  final OfferFilter normalizedFilter;
  final String? serviceTypeOverall;
  final double totalAmount;
  final double discountAmount;
  final DateTime? issueDate;
  final DateTime? acceptDate;

  const OfferSummaryItem({
    required this.offerId,
    required this.companyId,
    required this.totalAmount,
    required this.discountAmount,
    required this.normalizedFilter,
    this.offerNumber,
    this.companyName,
    this.companyLogoUrl,
    this.status,
    this.serviceTypeOverall,
    this.issueDate,
    this.acceptDate,
  });

  bool get hasDiscount => discountAmount > 0;

  bool get isAccepted =>
      status?.toLowerCase() == 'accepted';

  DateTime? get displayDate => isAccepted ? acceptDate : issueDate;
}
