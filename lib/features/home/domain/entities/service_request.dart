class SubmitServiceRequestInput {
  final int companyId;
  final String serviceType;
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

  const SubmitServiceRequestInput({
    required this.companyId,
    required this.serviceType,
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
  });

  SubmitServiceRequestInput copyWith({
    int? companyId,
    String? serviceType,
    String? fromStreet,
    String? fromCity,
    String? fromZipCode,
    String? fromCountry,
    String? toStreet,
    String? toCity,
    String? toZipCode,
    String? toCountry,
    DateTime? preferredDate,
    String? preferredTimeSlot,
    String? notes,
  }) {
    return SubmitServiceRequestInput(
      companyId: companyId ?? this.companyId,
      serviceType: serviceType ?? this.serviceType,
      fromStreet: fromStreet ?? this.fromStreet,
      fromCity: fromCity ?? this.fromCity,
      fromZipCode: fromZipCode ?? this.fromZipCode,
      fromCountry: fromCountry ?? this.fromCountry,
      toStreet: toStreet ?? this.toStreet,
      toCity: toCity ?? this.toCity,
      toZipCode: toZipCode ?? this.toZipCode,
      toCountry: toCountry ?? this.toCountry,
      preferredDate: preferredDate ?? this.preferredDate,
      preferredTimeSlot: preferredTimeSlot ?? this.preferredTimeSlot,
      notes: notes ?? this.notes,
    );
  }
}

class ServiceRequestSubmission {
  final int serviceRequestId;
  final String? referenceNumber;
  final int companyId;
  final String? companyName;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceRequestSubmission({
    required this.serviceRequestId,
    required this.companyId,
    this.referenceNumber,
    this.companyName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
}
