import '../../domain/entities/service_request.dart';

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  if (value is double) {
    return value.toInt();
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

class CreateServiceRequestDto {
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

  const CreateServiceRequestDto({
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

  factory CreateServiceRequestDto.fromInput(SubmitServiceRequestInput input) {
    return CreateServiceRequestDto(
      companyId: input.companyId,
      serviceType: input.serviceType,
      fromStreet: input.fromStreet,
      fromCity: input.fromCity,
      fromZipCode: input.fromZipCode,
      fromCountry: input.fromCountry,
      toStreet: input.toStreet,
      toCity: input.toCity,
      toZipCode: input.toZipCode,
      toCountry: input.toCountry,
      preferredDate: input.preferredDate,
      preferredTimeSlot: input.preferredTimeSlot,
      notes: input.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'companyId': companyId,
      'serviceType': serviceType,
      if (fromStreet != null) 'fromStreet': fromStreet,
      if (fromCity != null) 'fromCity': fromCity,
      if (fromZipCode != null) 'fromZipCode': fromZipCode,
      if (fromCountry != null) 'fromCountry': fromCountry,
      if (toStreet != null) 'toStreet': toStreet,
      if (toCity != null) 'toCity': toCity,
      if (toZipCode != null) 'toZipCode': toZipCode,
      if (toCountry != null) 'toCountry': toCountry,
      if (preferredDate != null)
        'preferredDate': preferredDate!.toIso8601String(),
      if (preferredTimeSlot != null) 'preferredTimeSlot': preferredTimeSlot,
      if (notes != null) 'notes': notes,
    };
  }
}

class CustomerServiceRequestDetailsDto {
  final int serviceRequestId;
  final String? referenceNumber;
  final int companyId;
  final String? companyName;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CustomerServiceRequestDetailsDto({
    required this.serviceRequestId,
    required this.companyId,
    this.referenceNumber,
    this.companyName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerServiceRequestDetailsDto.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(_asString(json['createdAt']) ?? '');
    final updatedAt = DateTime.tryParse(_asString(json['updatedAt']) ?? '');

    return CustomerServiceRequestDetailsDto(
      serviceRequestId: _asInt(json['serviceRequestId']),
      companyId: _asInt(json['companyId']),
      referenceNumber: _asString(json['referenceNumber']),
      companyName: _asString(json['companyName']),
      status: _asString(json['status']),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ServiceRequestSubmission toDomain() {
    return ServiceRequestSubmission(
      serviceRequestId: serviceRequestId,
      companyId: companyId,
      referenceNumber: referenceNumber,
      companyName: companyName,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
