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
