import '../entities/service_request.dart';

abstract class ServiceRequestRepository {
  Future<ServiceRequestSubmission> submitServiceRequest({
    required SubmitServiceRequestInput input,
  });
}
