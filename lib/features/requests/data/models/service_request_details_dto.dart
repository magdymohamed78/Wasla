import '../../domain/entities/request_filter.dart';
import '../../domain/entities/service_request_details.dart';
import '../../domain/use_cases/request_status_normalization_use_case.dart';

class ServiceRequestDetailsDto {
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
  final bool hasOffer;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceRequestDetailsDto({
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
    this.hasOffer = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceRequestDetailsDto.fromJson(
    Map<String, dynamic> json, {
    RequestStatusNormalizationUseCase? normalizer,
  }) {
    final effectiveNormalizer =
        normalizer ?? RequestStatusNormalizationUseCase();
    final rawStatus = json['status']?.toString().trim();
    return ServiceRequestDetailsDto(
      serviceRequestId: _asInt(json['serviceRequestId']),
      referenceNumber: _asString(json['referenceNumber']),
      companyId: _asInt(json['companyId']),
      companyName: _asString(json['companyName']),
      companyLogoUrl:
          _asString(json['companyLogoUrl']) ?? _asString(json['logoUrl']),
      serviceType: _asString(json['serviceType']),
      rawStatus: rawStatus,
      normalizedFilter: effectiveNormalizer.normalize(rawStatus),
      fromStreet: _asString(json['fromStreet']),
      fromCity: _asString(json['fromCity']),
      fromZipCode: _asString(json['fromZipCode']),
      fromCountry: _asString(json['fromCountry']),
      toStreet: _asString(json['toStreet']),
      toCity: _asString(json['toCity']),
      toZipCode: _asString(json['toZipCode']),
      toCountry: _asString(json['toCountry']),
      preferredDate: _asDate(json['preferredDate']),
      preferredTimeSlot: _asString(json['preferredTimeSlot']),
      notes: _asString(json['notes']),
      offerId: json['offerId'] == null ? null : _asInt(json['offerId']),
      offerNumber: _asString(json['offerNumber']),
      offerTotalAmount: json['offerTotalAmount'] == null
          ? null
          : _asDouble(json['offerTotalAmount']),
      offerStatus: _asString(json['offerStatus']),
      hasOffer: json['hasOffer'] == true,
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }

  ServiceRequestDetails toDomain() {
    return ServiceRequestDetails(
      serviceRequestId: serviceRequestId,
      referenceNumber: referenceNumber,
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      serviceType: serviceType,
      rawStatus: rawStatus,
      normalizedFilter: normalizedFilter,
      fromStreet: fromStreet,
      fromCity: fromCity,
      fromZipCode: fromZipCode,
      fromCountry: fromCountry,
      toStreet: toStreet,
      toCity: toCity,
      toZipCode: toZipCode,
      toCountry: toCountry,
      preferredDate: preferredDate,
      preferredTimeSlot: preferredTimeSlot,
      notes: notes,
      offerId: offerId,
      offerNumber: offerNumber,
      offerTotalAmount: offerTotalAmount,
      offerStatus: offerStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

double _asDouble(dynamic value, {double fallback = 0.0}) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

String? _asString(dynamic value) {
  if (value == null) return null;
  final normalized = value.toString().trim();
  return normalized.isEmpty ? null : normalized;
}

DateTime? _asDate(dynamic value) {
  final raw = _asString(value);
  if (raw == null) return null;
  return DateTime.tryParse(raw);
}
