import '../../domain/entities/request_filter.dart';
import '../../domain/use_cases/request_status_normalization_use_case.dart';

class RequestDetailsCompactDto {
  final int serviceRequestId;
  final String? referenceNumber;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? serviceType;
  final String? rawStatus;
  final RequestFilter normalizedFilter;
  final DateTime? preferredDate;
  final DateTime? createdAt;
  final bool hasOffer;
  final int? offerId;

  const RequestDetailsCompactDto({
    required this.serviceRequestId,
    required this.companyId,
    required this.normalizedFilter,
    this.referenceNumber,
    this.companyName,
    this.companyLogoUrl,
    this.serviceType,
    this.rawStatus,
    this.preferredDate,
    this.createdAt,
    this.hasOffer = false,
    this.offerId,
  });

  factory RequestDetailsCompactDto.fromJson(
    Map<String, dynamic> json, {
    RequestStatusNormalizationUseCase? normalizer,
  }) {
    final effectiveNormalizer =
        normalizer ?? RequestStatusNormalizationUseCase();
    final rawStatus = json['status']?.toString().trim();
    return RequestDetailsCompactDto(
      serviceRequestId: _asInt(json['serviceRequestId']),
      referenceNumber: _asString(json['referenceNumber']),
      companyId: _asInt(json['companyId']),
      companyName: _asString(json['companyName']),
      companyLogoUrl:
          _asString(json['companyLogoUrl']) ?? _asString(json['logoUrl']),
      serviceType: _asString(json['serviceType']),
      rawStatus: rawStatus,
      normalizedFilter: effectiveNormalizer.normalize(rawStatus),
      preferredDate: _asDate(json['preferredDate']),
      createdAt: _asDate(json['createdAt']),
      hasOffer: json['hasOffer'] == true,
      offerId: json['offerId'] == null ? null : _asInt(json['offerId']),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
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
