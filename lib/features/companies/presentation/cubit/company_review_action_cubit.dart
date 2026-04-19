import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../home/domain/repositories/customer_reviews_repository.dart';
import '../../../home/domain/use_cases/customer_profile_use_cases.dart';
import 'company_review_action_state.dart';

class CompanyReviewActionCubit extends Cubit<CompanyReviewActionState> {
  final int _companyId;
  final SessionCubit _sessionCubit;
  final GetCustomerProfileUseCase _getCustomerProfileUseCase;
  final CustomerReviewsRepository _reviewsRepository;

  CompanyReviewActionCubit({
    required int companyId,
    required SessionCubit sessionCubit,
    required GetCustomerProfileUseCase getCustomerProfileUseCase,
    required CustomerReviewsRepository reviewsRepository,
  }) : _companyId = companyId,
       _sessionCubit = sessionCubit,
       _getCustomerProfileUseCase = getCustomerProfileUseCase,
       _reviewsRepository = reviewsRepository,
       super(CompanyReviewActionState(role: sessionCubit.state.role));

  Future<void> loadEligibility() async {
    final currentRole = _sessionCubit.state.role;

    if (currentRole != SessionRole.customer) {
      emit(
        state.copyWith(
          role: currentRole,
          isEligibilityLoading: false,
          isConnectedCustomer: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        role: currentRole,
        isEligibilityLoading: true,
        isConnectedCustomer: false,
      ),
    );

    try {
      final profile = await _getCustomerProfileUseCase();
      final isConnected = profile.connectedCompanies.any(
        (connectedCompany) => connectedCompany.companyId == _companyId,
      );

      emit(
        state.copyWith(
          isEligibilityLoading: false,
          isConnectedCustomer: isConnected,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(isEligibilityLoading: false, isConnectedCustomer: false),
      );
    }
  }

  Future<CompanyReviewSubmitResult> submitReview({
    required int rating,
    String? reviewText,
  }) async {
    if (_companyId <= 0 || rating < 1 || rating > 5) {
      return const CompanyReviewSubmitResult.failure(
        errorCode: CompanyReviewSubmitErrorCode.badRequest,
      );
    }

    if (!state.canWriteReview) {
      return const CompanyReviewSubmitResult.failure(
        errorCode: CompanyReviewSubmitErrorCode.forbidden,
      );
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      await _reviewsRepository.createReview(
        companyId: _companyId,
        rating: rating,
        reviewText: reviewText,
      );

      emit(state.copyWith(isSubmitting: false));
      return const CompanyReviewSubmitResult.success();
    } on DioException catch (error) {
      final mappedError = _mapDioException(error);
      emit(state.copyWith(isSubmitting: false));
      return mappedError;
    } catch (_) {
      emit(state.copyWith(isSubmitting: false));
      return const CompanyReviewSubmitResult.failure(
        errorCode: CompanyReviewSubmitErrorCode.server,
      );
    }
  }

  CompanyReviewSubmitResult _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final (problemTitle, problemDetail) = _extractProblemDetails(
      error.response?.data,
    );

    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return CompanyReviewSubmitResult.failure(
            errorCode: CompanyReviewSubmitErrorCode.badRequest,
            problemTitle: problemTitle,
            problemDetail: problemDetail,
          );
        case 401:
          return CompanyReviewSubmitResult.failure(
            errorCode: CompanyReviewSubmitErrorCode.unauthorized,
            problemTitle: problemTitle,
            problemDetail: problemDetail,
          );
        case 403:
          return CompanyReviewSubmitResult.failure(
            errorCode: CompanyReviewSubmitErrorCode.forbidden,
            problemTitle: problemTitle,
            problemDetail: problemDetail,
          );
        case 404:
          return CompanyReviewSubmitResult.failure(
            errorCode: CompanyReviewSubmitErrorCode.notFound,
            problemTitle: problemTitle,
            problemDetail: problemDetail,
          );
        case 409:
          return CompanyReviewSubmitResult.failure(
            errorCode: CompanyReviewSubmitErrorCode.conflict,
            problemTitle: problemTitle,
            problemDetail: problemDetail,
          );
        default:
          return CompanyReviewSubmitResult.failure(
            errorCode: CompanyReviewSubmitErrorCode.server,
            problemTitle: problemTitle,
            problemDetail: problemDetail,
          );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return CompanyReviewSubmitResult.failure(
          errorCode: CompanyReviewSubmitErrorCode.network,
          problemTitle: problemTitle,
          problemDetail: problemDetail,
        );
      default:
        return CompanyReviewSubmitResult.failure(
          errorCode: CompanyReviewSubmitErrorCode.server,
          problemTitle: problemTitle,
          problemDetail: problemDetail,
        );
    }
  }

  (String?, String?) _extractProblemDetails(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return (
        _normalizeString(payload['title']),
        _normalizeString(payload['detail']),
      );
    }

    if (payload is String) {
      final normalized = _normalizeString(payload);
      return (null, normalized);
    }

    return (null, null);
  }

  String? _normalizeString(dynamic value) {
    if (value == null) {
      return null;
    }

    final normalized = value.toString().trim();
    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
