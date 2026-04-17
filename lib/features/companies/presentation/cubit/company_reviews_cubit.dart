import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../../home/domain/entities/company_details.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';

class CompanyReviewsCubit extends Cubit<CompanyReviewsState> {
  final int companyId;
  final GetCompanyReviewsUseCase _getCompanyReviews;

  CompanyReviewsCubit({
    required this.companyId,
    required GetCompanyReviewsUseCase getCompanyReviews,
  }) : _getCompanyReviews = getCompanyReviews,
       super(const CompanyReviewsState());

  Future<void> loadFirstPage() async {
    emit(state.copyWith(status: LoadStatus.loading, errorMessage: null));

    try {
      final page = await _getCompanyReviews(
        companyId: companyId,
        pageIndex: 1,
        pageSize: 100,
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            reviews: page.items,
            currentPage: page.pageIndex,
            hasMore: !page.hasReachedEnd && page.items.isNotEmpty,
            errorMessage: null,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: LoadStatus.error,
            errorMessage: 'load_reviews_failed',
          ),
        );
      }
    }
  }

  Future<void> loadMoreReviews() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final page = await _getCompanyReviews(
        companyId: companyId,
        pageIndex: nextPage,
        pageSize: 10,
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            reviews: [...state.reviews, ...page.items],
            currentPage: nextPage,
            hasMore: !page.hasReachedEnd && page.items.isNotEmpty,
            isLoadingMore: false,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(isLoadingMore: false));
      }
    }
  }
}

class CompanyReviewsState {
  final LoadStatus status;
  final List<CompanyReviewItem> reviews;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const CompanyReviewsState({
    this.status = LoadStatus.initial,
    this.reviews = const <CompanyReviewItem>[],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  CompanyReviewsState copyWith({
    LoadStatus? status,
    List<CompanyReviewItem>? reviews,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return CompanyReviewsState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
