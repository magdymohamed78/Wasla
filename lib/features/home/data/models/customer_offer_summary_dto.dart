import '../../domain/entities/customer_offer_summary.dart';
import 'json_helpers.dart';

class CustomerOfferSummaryDto {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? status;
  final String? serviceTypeOverall;
  final double totalAmount;
  final DateTime? issueDate;

  const CustomerOfferSummaryDto({
    required this.offerId,
    required this.companyId,
    required this.totalAmount,
    this.offerNumber,
    this.companyName,
    this.status,
    this.serviceTypeOverall,
    this.issueDate,
  });

  factory CustomerOfferSummaryDto.fromJson(Map<String, dynamic> json) {
    return CustomerOfferSummaryDto(
      offerId: asInt(json['offerId']),
      offerNumber: asString(json['offerNumber']),
      companyId: asInt(json['companyId']),
      companyName: asString(json['companyName']),
      status: asString(json['status']),
      serviceTypeOverall: asString(json['serviceTypeOverall']),
      totalAmount: asDouble(json['totalAmount']),
      issueDate: asDate(json['issueDate']),
    );
  }

  CustomerOfferSummary toDomain() {
    return CustomerOfferSummary(
      offerId: offerId,
      offerNumber: offerNumber,
      companyId: companyId,
      companyName: companyName,
      status: status,
      serviceTypeOverall: serviceTypeOverall,
      totalAmount: totalAmount,
      issueDate: issueDate,
    );
  }
}
