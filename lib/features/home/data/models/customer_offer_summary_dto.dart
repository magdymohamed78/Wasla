import '../../domain/entities/customer_offer_summary.dart';
import 'json_helpers.dart';

class CustomerOfferSummaryDto {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? status;
  final String? serviceTypeOverall;
  final double totalAmount;
  final double discountAmount;
  final DateTime? issueDate;
  final DateTime? acceptDate;

  const CustomerOfferSummaryDto({
    required this.offerId,
    required this.companyId,
    required this.totalAmount,
    required this.discountAmount,
    this.offerNumber,
    this.companyName,
    this.companyLogoUrl,
    this.status,
    this.serviceTypeOverall,
    this.issueDate,
    this.acceptDate,
  });

  factory CustomerOfferSummaryDto.fromJson(Map<String, dynamic> json) {
    return CustomerOfferSummaryDto(
      offerId: asInt(json['offerId']),
      offerNumber: asString(json['offerNumber']),
      companyId: asInt(json['companyId']),
      companyName: asString(json['companyName']),
      companyLogoUrl: asString(json['companyLogoUrl']),
      status: asString(json['status']),
      serviceTypeOverall: asString(json['serviceTypeOverall']),
      totalAmount: asDouble(json['totalAmount']),
      discountAmount: asDouble(json['discountAmount']),
      issueDate: asDate(json['issueDate']),
      acceptDate: asDate(json['acceptDate']),
    );
  }

  CustomerOfferSummary toDomain() {
    return CustomerOfferSummary(
      offerId: offerId,
      offerNumber: offerNumber,
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      status: status,
      serviceTypeOverall: serviceTypeOverall,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      issueDate: issueDate,
      acceptDate: acceptDate,
    );
  }
}
