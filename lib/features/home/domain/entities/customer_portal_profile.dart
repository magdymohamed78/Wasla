import 'connected_company.dart';

class CustomerPortalProfile {
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
  final List<ConnectedCompany> connectedCompanies;

  const CustomerPortalProfile({
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
    this.connectedCompanies = const <ConnectedCompany>[],
  });

  String get fullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final value = '$first $last'.trim();
    return value;
  }
}
