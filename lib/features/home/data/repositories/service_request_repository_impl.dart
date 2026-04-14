import '../../domain/entities/service_request.dart';
import '../../domain/repositories/service_request_repository.dart';
import '../data_sources/service_request_remote_data_source.dart';
import '../models/service_request_models.dart';

class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final ServiceRequestRemoteDataSource _remote;

  const ServiceRequestRepositoryImpl({
    required ServiceRequestRemoteDataSource remote,
  }) : _remote = remote;

  @override
  Future<ServiceRequestSubmission> submitServiceRequest({
    required SubmitServiceRequestInput input,
  }) async {
    final request = CreateServiceRequestDto.fromInput(input);
    final response = await _remote.submitServiceRequest(request: request);
    return response.toDomain();
  }
}
