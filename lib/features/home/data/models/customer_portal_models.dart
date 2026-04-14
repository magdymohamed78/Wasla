import '../../domain/entities/customer_portal_content.dart';

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

double _asDouble(dynamic value, {double fallback = 0}) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? fallback;
  }
  return fallback;
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  if (normalized.isEmpty) {
    return null;
  }

  return normalized;
}

DateTime? _asDate(dynamic value) {
  final raw = _asString(value);
  if (raw == null) {
    return null;
  }

  return DateTime.tryParse(raw);
}

class CustomerServiceRequestSummaryDto {
  final int serviceRequestId;
  final String? referenceNumber;
  final int companyId;
  final String? companyName;
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
    this.serviceType,
    this.status,
    this.preferredDate,
    this.createdAt,
    required this.hasOffer,
    this.offerId,
  });

  factory CustomerServiceRequestSummaryDto.fromJson(Map<String, dynamic> json) {
    final offerId = json['offerId'] == null ? null : _asInt(json['offerId']);

    return CustomerServiceRequestSummaryDto(
      serviceRequestId: _asInt(json['serviceRequestId']),
      referenceNumber: _asString(json['referenceNumber']),
      companyId: _asInt(json['companyId']),
      companyName: _asString(json['companyName']),
      serviceType: _asString(json['serviceType']),
      status: _asString(json['status']),
      preferredDate: _asDate(json['preferredDate']),
      createdAt: _asDate(json['createdAt']),
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
      serviceType: serviceType,
      status: status,
      preferredDate: preferredDate,
      createdAt: createdAt,
      hasOffer: hasOffer,
      offerId: offerId,
    );
  }
}

class CustomerOfferSummaryDto {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? status;
  final String? serviceTypeOverall;
  final double totalAmount;
  final DateTime? issueDate;

  const CustomerOfferSummaryDto({
    required this.offerId,
    required this.companyId,
    required this.totalAmount,
    this.offerNumber,
    this.companyName,
    this.status,
    this.serviceTypeOverall,
    this.issueDate,
  });

  factory CustomerOfferSummaryDto.fromJson(Map<String, dynamic> json) {
    return CustomerOfferSummaryDto(
      offerId: _asInt(json['offerId']),
      offerNumber: _asString(json['offerNumber']),
      companyId: _asInt(json['companyId']),
      companyName: _asString(json['companyName']),
      status: _asString(json['status']),
      serviceTypeOverall: _asString(json['serviceTypeOverall']),
      totalAmount: _asDouble(json['totalAmount']),
      issueDate: _asDate(json['issueDate']),
    );
  }

  CustomerOfferSummary toDomain() {
    return CustomerOfferSummary(
      offerId: offerId,
      offerNumber: offerNumber,
      companyId: companyId,
      companyName: companyName,
      status: status,
      serviceTypeOverall: serviceTypeOverall,
      totalAmount: totalAmount,
      issueDate: issueDate,
    );
  }
}

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
  });

  factory CustomerProfileDto.fromJson(Map<String, dynamic> json) {
    return CustomerProfileDto(
      userId: _asInt(json['userId']),
      customerId: _asInt(json['customerId']),
      firstName: _asString(json['firstName']),
      lastName: _asString(json['lastName']),
      email: _asString(json['email']),
      phoneNumber: _asString(json['phoneNumber']),
      address: _asString(json['address']),
      city: _asString(json['city']),
      zipCode: _asString(json['zipCode']),
      country: _asString(json['country']),
      digitalSignature: _asString(json['digitalSignature']),
      createdAt: _asDate(json['createdAt']),
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
    );
  }
}

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
  });

  factory LeadProfileDto.fromJson(Map<String, dynamic> json) {
    return LeadProfileDto(
      userId: _asInt(json['userId']),
      leadId: _asInt(json['leadId']),
      firstName: _asString(json['firstName']),
      lastName: _asString(json['lastName']),
      email: _asString(json['email']),
      phoneNumber: _asString(json['phoneNumber']),
      address: _asString(json['address']),
      city: _asString(json['city']),
      zipCode: _asString(json['zipCode']),
      country: _asString(json['country']),
      createdAt: _asDate(json['createdAt']),
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
    );
  }
}
