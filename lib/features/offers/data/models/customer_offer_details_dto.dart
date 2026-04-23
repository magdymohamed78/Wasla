import '../../../home/data/models/json_helpers.dart';
import '../../domain/entities/offer_details.dart';
import '../../domain/entities/offer_filter.dart';
import 'offer_location_summary_dto.dart';
import 'offer_service_line_item_summary_dto.dart';

/// Data transfer object for [CustomerOfferDetailsDto] from the API.
///
/// Maps the JSON response from
/// `GET /api/customer-portal/my/offers/{offerId}`
/// to the domain [OfferDetails] entity.
class CustomerOfferDetailsDto {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? status;
  final String? serviceTypeOverall;
  final double totalAmount;
  final double discountAmount;
  final DateTime? issueDate;
  final DateTime? acceptDate;
  final String? digitalSignature;
  final String? rejectionReason;
  final String? insurance;
  final String? includedInPrice;
  final bool? costsIncludeVAT;
  final String? pdfUrl;
  final List<OfferLocationSummaryDto> locations;
  final List<OfferServiceLineItemSummaryDto> serviceLineItems;

  const CustomerOfferDetailsDto({
    required this.offerId,
    this.offerNumber,
    this.companyId = 0,
    this.companyName,
    this.status,
    this.serviceTypeOverall,
    this.totalAmount = 0,
    this.discountAmount = 0,
    this.issueDate,
    this.acceptDate,
    this.digitalSignature,
    this.rejectionReason,
    this.insurance,
    this.includedInPrice,
    this.costsIncludeVAT,
    this.pdfUrl,
    this.locations = const [],
    this.serviceLineItems = const [],
  });

  factory CustomerOfferDetailsDto.fromJson(Map<String, dynamic> json) {
    final rawLocations = json['locations'] as List<dynamic>?;
    final rawLineItems = json['serviceLineItems'] as List<dynamic>?;

    return CustomerOfferDetailsDto(
      offerId: asInt(json['offerId']),
      offerNumber: asString(json['offerNumber']),
      companyId: asInt(json['companyId']),
      companyName: asString(json['companyName']),
      status: asString(json['status']),
      serviceTypeOverall: asString(json['serviceTypeOverall']),
      totalAmount: asDouble(json['totalAmount']),
      discountAmount: asDouble(json['discountAmount']),
      issueDate: asDate(json['issueDate']),
      acceptDate: asDate(json['acceptDate']),
      digitalSignature: asString(json['digitalSignature']),
      rejectionReason: asString(json['rejectionReason']),
      insurance: asString(json['insurance']),
      includedInPrice: asString(json['includedInPrice']),
      costsIncludeVAT: json['costsIncludeVAT'] as bool?,
      pdfUrl: asString(json['pdfUrl']),
      locations: rawLocations
              ?.map(
                (e) =>
                    OfferLocationSummaryDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(growable: false) ??
          const [],
      serviceLineItems: rawLineItems
              ?.map(
                (e) => OfferServiceLineItemSummaryDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(growable: false) ??
          const [],
    );
  }

  OfferDetails toDomain() {
    return OfferDetails(
      offerId: offerId,
      offerNumber: offerNumber,
      companyId: companyId,
      companyName: companyName,
      status: status,
      normalizedFilter: OfferFilter.fromQueryValue(status),
      serviceTypeOverall: serviceTypeOverall,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      issueDate: issueDate,
      acceptDate: acceptDate,
      digitalSignature: digitalSignature,
      rejectionReason: rejectionReason,
      insurance: insurance,
      includedInPrice: includedInPrice,
      costsIncludeVAT: costsIncludeVAT,
      pdfUrl: pdfUrl,
      locations:
          locations.map((l) => l.toDomain()).toList(growable: false),
      serviceLineItems:
          serviceLineItems.map((s) => s.toDomain()).toList(growable: false),
    );
  }
}
