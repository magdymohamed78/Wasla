import '../../domain/entities/customer_portal_profile.dart';
import 'connected_company_dto.dart';
import 'json_helpers.dart';

class CustomerProfileDto {
  final int userId;
  final int customerId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? country;
  final String? digitalSignature;
  final DateTime? createdAt;
  final List<ConnectedCompanyDto> connectedCompanies;

  const CustomerProfileDto({
    required this.userId,
    required this.customerId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.zipCode,
    this.country,
    this.digitalSignature,
    this.createdAt,
    this.connectedCompanies = const <ConnectedCompanyDto>[],
  });

  factory CustomerProfileDto.fromJson(Map<String, dynamic> json) {
    return CustomerProfileDto(
      userId: asInt(json['userId']),
      customerId: asInt(json['customerId']),
      firstName: asString(json['firstName']),
      lastName: asString(json['lastName']),
      email: asString(json['email']),
      phoneNumber: asString(json['phoneNumber']),
      address: asString(json['address']),
      city: asString(json['city']),
      zipCode: asString(json['zipCode']),
      country: asString(json['country']),
      digitalSignature: asString(json['digitalSignature']),
      createdAt: asDate(json['createdAt']),
      connectedCompanies: asConnectedCompanies(json['connectedCompanies']),
    );
  }

  CustomerPortalProfile toDomain() {
    return CustomerPortalProfile(
      userId: userId,
      customerId: customerId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      city: city,
      zipCode: zipCode,
      country: country,
      digitalSignature: digitalSignature,
      createdAt: createdAt,
      connectedCompanies: connectedCompanies
          .map((company) => company.toDomain())
          .toList(growable: false),
    );
  }
}
