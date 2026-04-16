class CustomerServiceRequestSummary {
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

  const CustomerServiceRequestSummary({
    required this.serviceRequestId,
    required this.companyId,
    this.referenceNumber,
    this.companyName,
    this.serviceType,
    this.status,
    this.preferredDate,
    this.createdAt,
    this.hasOffer = false,
    this.offerId,
  });
}

class ConnectedCompany {
  final int leadCompanyId;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? status;
  final int? customerId;
  final DateTime? requestedAt;
  final DateTime? respondedAt;

  const ConnectedCompany({
    required this.leadCompanyId,
    required this.companyId,
    this.companyName,
    this.companyLogoUrl,
    this.status,
    this.customerId,
    this.requestedAt,
    this.respondedAt,
  });
}

class UpdatePortalProfileInput {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? country;

  const UpdatePortalProfileInput({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.address,
    this.city,
    this.zipCode,
    this.country,
  });
}

class CustomerOfferSummary {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? status;
  final String? serviceTypeOverall;
  final double totalAmount;
  final DateTime? issueDate;

  const CustomerOfferSummary({
    required this.offerId,
    required this.companyId,
    required this.totalAmount,
    this.offerNumber,
    this.companyName,
    this.status,
    this.serviceTypeOverall,
    this.issueDate,
  });
}

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
