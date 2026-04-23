import 'package:dio/dio.dart';

import '../models/accept_offer_response_dto.dart';
import '../models/customer_offer_details_dto.dart';

/// Remote data source for offer detail, accept, and reject operations.
///
/// Uses the customer-portal API endpoints:
/// - `GET  /api/customer-portal/my/offers/{offerId}`
/// - `POST /api/customer-portal/my/offers/{offerId}/accept`
/// - `POST /api/customer-portal/my/offers/{offerId}/reject`
class OffersRemoteDataSource {
  static const String _basePath = '/api/customer-portal/my/offers';

  final Dio _dio;

  const OffersRemoteDataSource(this._dio);

  /// Fetches full details for a specific offer.
  Future<CustomerOfferDetailsDto> getOfferDetails(int offerId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_basePath/$offerId',
    );
    return CustomerOfferDetailsDto.fromJson(response.data!);
  }

  /// Accepts an offer with the given digital signature and payment method.
  ///
  /// Returns an [AcceptOfferResponseDto] which may contain a checkout URL
  /// for online payments.
  Future<AcceptOfferResponseDto> acceptOffer({
    required int offerId,
    required String digitalSignature,
    required int paymentMethod,
  }) async {
    final response = await _dio.post<dynamic>(
      '$_basePath/$offerId/accept',
      data: <String, dynamic>{
        'digitalSignature': digitalSignature,
        'paymentMethod': paymentMethod,
      },
    );

    final body = response.data;
    if (body is Map<String, dynamic>) {
      return AcceptOfferResponseDto.fromJson(body);
    }
    return const AcceptOfferResponseDto();
  }

  /// Rejects an offer with the given reason.
  Future<void> rejectOffer({
    required int offerId,
    required String rejectionReason,
  }) async {
    await _dio.post<dynamic>(
      '$_basePath/$offerId/reject',
      data: <String, dynamic>{
        'rejectionReason': rejectionReason,
      },
    );
  }
}
