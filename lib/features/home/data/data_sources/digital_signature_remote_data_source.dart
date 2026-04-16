import 'package:dio/dio.dart';

import '../models/customer_portal_models.dart';

class DigitalSignatureRemoteDataSource {
  static const String _endpoint = '/api/customer-portal/my/digital-signature';

  final Dio _dio;

  const DigitalSignatureRemoteDataSource(this._dio);

  Future<String> revealDigitalSignature({required String password}) async {
    final response = await _dio.post<dynamic>(
      _endpoint,
      data: <String, dynamic>{'password': password},
    );

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final dto = SignatureRevealResponseDto.fromJson(payload);
      if (dto.digitalSignature != null && dto.digitalSignature!.isNotEmpty) {
        return dto.digitalSignature!;
      }
    }

    if (payload is String && payload.isNotEmpty) {
      return payload;
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Invalid digital signature response.',
    );
  }
}
