class CustomerServiceRequestSummary {
  final int serviceRequestId;
  final String? referenceNumber;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? serviceType;
  final String? status;
  final DateTime? preferredDate;
  final DateTime? createdAt;
  final bool hasOffer;
  final int? offerId;

  const CustomerServiceRequestSummary({
    required this.serviceRequestId,
    required this.companyId,
    this.referenceNumber,
    this.companyName,
    this.companyLogoUrl,
    this.serviceType,
    this.status,
    this.preferredDate,
    this.createdAt,
    this.hasOffer = false,
    this.offerId,
  });
}
