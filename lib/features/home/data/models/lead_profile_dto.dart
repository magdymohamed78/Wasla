import '../../domain/entities/lead_portal_profile.dart';
import 'connected_company_dto.dart';
import 'json_helpers.dart';

class LeadProfileDto {
  final int userId;
  final int leadId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? country;
  final DateTime? createdAt;
  final List<ConnectedCompanyDto> connectedCompanies;

  const LeadProfileDto({
    required this.userId,
    required this.leadId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.zipCode,
    this.country,
    this.createdAt,
    this.connectedCompanies = const <ConnectedCompanyDto>[],
  });

  factory LeadProfileDto.fromJson(Map<String, dynamic> json) {
    return LeadProfileDto(
      userId: asInt(json['userId']),
      leadId: asInt(json['leadId']),
      firstName: asString(json['firstName']),
      lastName: asString(json['lastName']),
      email: asString(json['email']),
      phoneNumber: asString(json['phoneNumber']),
      address: asString(json['address']),
      city: asString(json['city']),
      zipCode: asString(json['zipCode']),
      country: asString(json['country']),
      createdAt: asDate(json['createdAt']),
      connectedCompanies: asConnectedCompanies(json['connectedCompanies']),
    );
  }

  LeadPortalProfile toDomain() {
    return LeadPortalProfile(
      userId: userId,
      leadId: leadId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      city: city,
      zipCode: zipCode,
      country: country,
      createdAt: createdAt,
      connectedCompanies: connectedCompanies
          .map((company) => company.toDomain())
          .toList(growable: false),
    );
  }
}
