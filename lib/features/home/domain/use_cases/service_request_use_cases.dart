import '../entities/service_request.dart';
import '../repositories/service_request_repository.dart';

class SubmitServiceRequestUseCase {
  final ServiceRequestRepository _repository;

  const SubmitServiceRequestUseCase(this._repository);

  Future<ServiceRequestSubmission> call({
    required SubmitServiceRequestInput input,
  }) {
    if (input.companyId <= 0) {
      throw ArgumentError.value(
        input.companyId,
        'companyId',
        'Company id must be a positive integer.',
      );
    }

    final normalizedServiceType = input.serviceType.trim();
    if (normalizedServiceType.isEmpty) {
      throw ArgumentError.value(
        input.serviceType,
        'serviceType',
        'Service type is required.',
      );
    }

    final normalizedInput = input.copyWith(
      serviceType: normalizedServiceType,
      fromStreet: _normalizeNullable(input.fromStreet),
      fromCity: _normalizeNullable(input.fromCity),
      fromZipCode: _normalizeNullable(input.fromZipCode),
      fromCountry: _normalizeNullable(input.fromCountry),
      toStreet: _normalizeNullable(input.toStreet),
      toCity: _normalizeNullable(input.toCity),
      toZipCode: _normalizeNullable(input.toZipCode),
      toCountry: _normalizeNullable(input.toCountry),
      preferredTimeSlot: _normalizeNullable(input.preferredTimeSlot),
      notes: _normalizeNullable(input.notes),
    );

    return _repository.submitServiceRequest(input: normalizedInput);
  }

  String? _normalizeNullable(String? value) {
    if (value == null) {
      return null;
    }

    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
