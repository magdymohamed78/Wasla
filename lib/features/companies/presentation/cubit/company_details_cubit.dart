import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../home/domain/entities/company_details.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';
import '../../../home/domain/use_cases/role_guard_use_cases.dart';
import 'company_details_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  static const String invalidCompanyIdError = 'invalid_company_id';
  static const String loadDetailsFailedError = 'load_company_details_failed';

  final GetCompanyDetailsUseCase _getCompanyDetailsUseCase;
  final SessionCubit _sessionCubit;
  final RoleGuardUseCases _roleGuardUseCases;

  CompanyDetailsCubit({
    required int companyId,
    required GetCompanyDetailsUseCase getCompanyDetailsUseCase,
    required SessionCubit sessionCubit,
    required RoleGuardUseCases roleGuardUseCases,
  }) : _getCompanyDetailsUseCase = getCompanyDetailsUseCase,
       _sessionCubit = sessionCubit,
       _roleGuardUseCases = roleGuardUseCases,
       super(CompanyDetailsState(companyId: companyId));

  Future<void> loadDetails() async {
    if (state.companyId <= 0) {
      emit(
        state.copyWith(
          detailsStatus: LoadStatus.error,
          errorMessage: invalidCompanyIdError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        detailsStatus: LoadStatus.loading,
        errorMessage: null,
        reviewsErrorMessage: null,
        isLoadingMoreReviews: false,
        isRestrictionPromptVisible: false,
        pendingRequestServiceCompanyId: null,
      ),
    );

    try {
      final details = await _getCompanyDetailsUseCase(state.companyId);
      final normalizedServices = _normalizeServices(details.serviceCatalog);
      final normalizedReviews = _normalizeReviews(details.recentReviews);
      final normalizedRating = _normalizeAverageRating(
        details.averageRating,
        normalizedReviews,
      );

      emit(
        state.copyWith(
          detailsStatus: LoadStatus.success,
          companyName: _normalizeText(details.companyName),
          companyLogoUrl: _normalizeOptionalText(details.companyLogoUrl),
          averageRating: normalizedRating,
          reviewCount: _normalizeReviewCount(
            details.reviewCount,
            normalizedReviews.length,
          ),
          contactEmail: _normalizeText(details.contactEmail),
          phoneNumber: _normalizeText(details.phoneNumber),
          addressLine: _normalizeText(details.address),
          locationLine: _buildLocationLine(
            city: details.city,
            zipCode: details.zipCode,
            country: details.country,
          ),
          services: normalizedServices,
          reviews: normalizedReviews,
          hasMoreReviews: false,
          isLoadingMoreReviews: false,
          nextReviewsPage: 1,
          errorMessage: null,
          reviewsErrorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          detailsStatus: LoadStatus.error,
          errorMessage: loadDetailsFailedError,
        ),
      );
    }
  }

  void onRequestServiceTapped() {
    if (state.isRestrictionPromptVisible) {
      return;
    }

    final guardDecision = _roleGuardUseCases.guardRequestServiceAction(
      role: _sessionCubit.state.role,
      companyId: state.companyId,
    );

    if (!guardDecision.allowed) {
      if (guardDecision.reason == GuardReason.unauthenticated) {
        emit(state.copyWith(isRestrictionPromptVisible: true));
      }

      return;
    }

    emit(state.copyWith(pendingRequestServiceCompanyId: state.companyId));
  }

  void consumeRequestServiceNavigation() {
    if (state.pendingRequestServiceCompanyId == null) {
      return;
    }

    emit(state.copyWith(pendingRequestServiceCompanyId: null));
  }

  void hideRestrictionPrompt() {
    if (!state.isRestrictionPromptVisible) {
      return;
    }

    emit(state.copyWith(isRestrictionPromptVisible: false));
  }

  Future<void> loadMoreReviews() async {
    return;
  }

  String _normalizeText(String? value) {
    return value?.trim() ?? '';
  }

  String? _normalizeOptionalText(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  int _normalizeReviewCount(int? reviewCount, int fallbackCount) {
    if (reviewCount != null && reviewCount > 0) {
      return reviewCount;
    }
    return fallbackCount;
  }

  double? _normalizeAverageRating(
    double? averageRating,
    List<CompanyReviewItem> reviews,
  ) {
    if (averageRating != null && averageRating > 0) {
      return averageRating;
    }

    final ratingValues = reviews
        .map((review) => review.rating)
        .whereType<double>()
        .where((rating) => rating > 0)
        .toList(growable: false);

    if (ratingValues.isEmpty) {
      return null;
    }

    final total = ratingValues.fold<double>(0, (sum, rating) => sum + rating);
    return total / ratingValues.length;
  }

  String _buildLocationLine({String? city, String? zipCode, String? country}) {
    final normalizedCity = _normalizeOptionalText(city);
    final normalizedZipCode = _normalizeOptionalText(zipCode);
    final normalizedCountry = _normalizeOptionalText(country);

    final segments = <String>[];
    if (normalizedCity != null && normalizedZipCode != null) {
      segments.add('$normalizedCity, $normalizedZipCode');
    } else if (normalizedCity != null) {
      segments.add(normalizedCity);
    } else if (normalizedZipCode != null) {
      segments.add(normalizedZipCode);
    }

    if (normalizedCountry != null) {
      segments.add(normalizedCountry);
    }

    return segments.join(' • ');
  }

  List<CompanyServiceItem> _normalizeServices(List<CompanyServiceItem> items) {
    return items
        .map(
          (item) => CompanyServiceItem(
            id: item.id,
            name: _normalizeText(item.name),
            description: _normalizeOptionalText(item.description),
            price: item.price,
            indicativePriceFrom: item.indicativePriceFrom,
            indicativePriceTo: item.indicativePriceTo,
            pricingUnit: _normalizeOptionalText(item.pricingUnit),
          ),
        )
        .toList(growable: false);
  }

  List<CompanyReviewItem> _normalizeReviews(List<CompanyReviewItem> items) {
    return items
        .map(
          (item) => CompanyReviewItem(
            reviewId: item.reviewId,
            customerName: _normalizeOptionalText(item.customerName),
            comment: _normalizeOptionalText(item.comment),
            rating: item.rating,
            createdAt: item.createdAt,
          ),
        )
        .where(
          (item) =>
              item.customerName != null ||
              item.comment != null ||
              item.rating != null,
        )
        .toList(growable: false);
  }
}
