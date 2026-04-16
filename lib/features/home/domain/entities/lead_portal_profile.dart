import 'connected_company.dart';

class LeadPortalProfile {
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
  final List<ConnectedCompany> connectedCompanies;

  const LeadPortalProfile({
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
    this.connectedCompanies = const <ConnectedCompany>[],
  });

  String get fullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final value = '$first $last'.trim();
    return value;
  }
}
