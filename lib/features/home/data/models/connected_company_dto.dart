import '../../domain/entities/connected_company.dart';
import 'json_helpers.dart';

class ConnectedCompanyDto {
  final int leadCompanyId;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? status;
  final int? customerId;
  final DateTime? requestedAt;
  final DateTime? respondedAt;

  const ConnectedCompanyDto({
    required this.leadCompanyId,
    required this.companyId,
    this.companyName,
    this.companyLogoUrl,
    this.status,
    this.customerId,
    this.requestedAt,
    this.respondedAt,
  });

  factory ConnectedCompanyDto.fromJson(Map<String, dynamic> json) {
    final rawCustomerId = json['customerId'];

    return ConnectedCompanyDto(
      leadCompanyId: asInt(json['leadCompanyId']),
      companyId: asInt(json['companyId']),
      companyName: asString(json['companyName']),
      companyLogoUrl: asString(json['companyLogoUrl']),
      status: asString(json['status']),
      customerId: rawCustomerId == null ? null : asInt(rawCustomerId),
      requestedAt: asDate(json['requestedAt']),
      respondedAt: asDate(json['respondedAt']),
    );
  }

  ConnectedCompany toDomain() {
    return ConnectedCompany(
      leadCompanyId: leadCompanyId,
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      status: status,
      customerId: customerId,
      requestedAt: requestedAt,
      respondedAt: respondedAt,
    );
  }
}

List<ConnectedCompanyDto> asConnectedCompanies(dynamic value) {
  if (value is! List) {
    return const <ConnectedCompanyDto>[];
  }

  return value
      .whereType<Map<String, dynamic>>()
      .map(ConnectedCompanyDto.fromJson)
      .toList(growable: false);
}
