import '../../domain/entities/customer_service_request_summary.dart';
import 'json_helpers.dart';

class CustomerServiceRequestSummaryDto {
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

  const CustomerServiceRequestSummaryDto({
    required this.serviceRequestId,
    required this.companyId,
    this.referenceNumber,
    this.companyName,
    this.companyLogoUrl,
    this.serviceType,
    this.status,
    this.preferredDate,
    this.createdAt,
    required this.hasOffer,
    this.offerId,
  });

  factory CustomerServiceRequestSummaryDto.fromJson(Map<String, dynamic> json) {
    final offerId = json['offerId'] == null ? null : asInt(json['offerId']);

    return CustomerServiceRequestSummaryDto(
      serviceRequestId: asInt(json['serviceRequestId']),
      referenceNumber: asString(json['referenceNumber']),
      companyId: asInt(json['companyId']),
      companyName: asString(json['companyName']),
      companyLogoUrl:
          asString(json['companyLogoUrl']) ?? asString(json['logoUrl']),
      serviceType: asString(json['serviceType']),
      status: asString(json['status']),
      preferredDate: asDate(json['preferredDate']),
      createdAt: asDate(json['createdAt']),
      hasOffer: json['hasOffer'] == true,
      offerId: offerId,
    );
  }

  CustomerServiceRequestSummary toDomain() {
    return CustomerServiceRequestSummary(
      serviceRequestId: serviceRequestId,
      referenceNumber: referenceNumber,
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      serviceType: serviceType,
      status: status,
      preferredDate: preferredDate,
      createdAt: createdAt,
      hasOffer: hasOffer,
      offerId: offerId,
    );
  }
}
