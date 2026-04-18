import 'request_filter.dart';

class ServiceRequestDetails {
  final int serviceRequestId;
  final String? referenceNumber;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? serviceType;
  final String? rawStatus;
  final RequestFilter normalizedFilter;

  final String? fromStreet;
  final String? fromCity;
  final String? fromZipCode;
  final String? fromCountry;

  final String? toStreet;
  final String? toCity;
  final String? toZipCode;
  final String? toCountry;

  final DateTime? preferredDate;
  final String? preferredTimeSlot;
  final String? notes;

  final int? offerId;
  final String? offerNumber;
  final double? offerTotalAmount;
  final String? offerStatus;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceRequestDetails({
    required this.serviceRequestId,
    required this.companyId,
    required this.normalizedFilter,
    this.referenceNumber,
    this.companyName,
    this.companyLogoUrl,
    this.serviceType,
    this.rawStatus,
    this.fromStreet,
    this.fromCity,
    this.fromZipCode,
    this.fromCountry,
    this.toStreet,
    this.toCity,
    this.toZipCode,
    this.toCountry,
    this.preferredDate,
    this.preferredTimeSlot,
    this.notes,
    this.offerId,
    this.offerNumber,
    this.offerTotalAmount,
    this.offerStatus,
    this.createdAt,
    this.updatedAt,
  });

  String get fromAddress {
    final parts = [fromStreet, fromCity, fromCountry]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();
    return parts.join(', ');
  }

  String get toAddress {
    final parts = [toStreet, toCity, toCountry]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();
    return parts.join(', ');
  }

  bool get hasOffer => offerId != null;

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;
}
