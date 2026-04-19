import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../../home/domain/entities/customer_review_item.dart';
import '../../../home/domain/repositories/customer_reviews_repository.dart';
import '../../../home/presentation/cubit/dashboard_cubit.dart';
import 'my_reviews_state.dart';

class MyReviewsCubit extends Cubit<MyReviewsState> {
  static const String loadFailedError = 'my_reviews_load_failed';
  static const String updateBadRequestError = 'my_reviews_update_bad_request';
  static const int _pageSize = 10;

  final CustomerReviewsRepository _reviewsRepository;

  MyReviewsCubit({required CustomerReviewsRepository reviewsRepository})
    : _reviewsRepository = reviewsRepository,
      super(const MyReviewsState());

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        isLoadingMore: false,
        isMutating: false,
        nextPageIndex: 1,
        hasReachedEnd: false,
        errorCode: null,
      ),
    );

    try {
      final page = await _reviewsRepository.getMyReviews(
        pageIndex: 1,
        pageSize: _pageSize,
      );

      final normalizedTotalCount = page.totalCount < 0 ? 0 : page.totalCount;
      final nextPageIndex = page.pageIndex <= 0 ? 2 : page.pageIndex + 1;

      emit(
        state.copyWith(
          status: page.items.isEmpty ? LoadStatus.empty : LoadStatus.success,
          items: page.items,
          totalCount: normalizedTotalCount,
          nextPageIndex: nextPageIndex,
          hasReachedEnd: page.hasReachedEnd,
          isLoadingMore: false,
          isMutating: false,
          errorCode: null,
        ),
      );

      DashboardCubit.publishMyReviewsCount(normalizedTotalCount);
    } catch (_) {
      emit(
        state.copyWith(
          status: LoadStatus.error,
          isLoadingMore: false,
          isMutating: false,
          errorCode: loadFailedError,
        ),
      );
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Future<void> loadMore() async {
    if (state.status != LoadStatus.success ||
        state.hasReachedEnd ||
        state.isLoadingMore ||
        state.isMutating) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final page = await _reviewsRepository.getMyReviews(
        pageIndex: state.nextPageIndex,
        pageSize: _pageSize,
      );

      final existingIds = state.items.map((item) => item.reviewId).toSet();
      final uniqueNewItems = page.items
          .where((item) => !existingIds.contains(item.reviewId))
          .toList(growable: false);

      final mergedItems = List<CustomerReviewItem>.from(state.items)
        ..addAll(uniqueNewItems);

      final normalizedTotalCount = page.totalCount < 0
          ? state.totalCount
          : page.totalCount;

      final resolvedHasReachedEnd =
          page.hasReachedEnd || mergedItems.length >= normalizedTotalCount;

      emit(
        state.copyWith(
          items: mergedItems,
          totalCount: normalizedTotalCount,
          nextPageIndex: state.nextPageIndex + 1,
          hasReachedEnd: resolvedHasReachedEnd,
          isLoadingMore: false,
          errorCode: null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<bool> updateReview({
    required int reviewId,
    required int companyId,
    required int rating,
    String? reviewText,
  }) async {
    if (state.isMutating) {
      return false;
    }

    emit(state.copyWith(isMutating: true, errorCode: null));

    try {
      final updated = await _reviewsRepository.updateReview(
        companyId: companyId,
        rating: rating,
        reviewText: reviewText,
      );

      final updatedItems = state.items
          .map((item) {
            if (item.reviewId == reviewId || item.companyId == companyId) {
              return updated;
            }
            return item;
          })
          .toList(growable: false);

      emit(
        state.copyWith(
          status: updatedItems.isEmpty ? LoadStatus.empty : LoadStatus.success,
          items: updatedItems,
          isMutating: false,
          errorCode: null,
        ),
      );

      DashboardCubit.publishMyReviewsCount(state.totalCount);
      return true;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      emit(
        state.copyWith(
          isMutating: false,
          errorCode: statusCode == 400
              ? updateBadRequestError
              : loadFailedError,
        ),
      );
      return false;
    } catch (_) {
      emit(state.copyWith(isMutating: false, errorCode: loadFailedError));
      return false;
    }
  }

  Future<bool> deleteReview({
    required int reviewId,
    required int companyId,
  }) async {
    if (state.isMutating) {
      return false;
    }

    emit(state.copyWith(isMutating: true, errorCode: null));

    try {
      await _reviewsRepository.deleteReview(companyId: companyId);

      final remainingItems = state.items
          .where(
            (item) => item.reviewId != reviewId && item.companyId != companyId,
          )
          .toList(growable: false);

      final nextTotalCount = state.totalCount > 0 ? state.totalCount - 1 : 0;

      emit(
        state.copyWith(
          status: nextTotalCount == 0 ? LoadStatus.empty : LoadStatus.success,
          items: remainingItems,
          totalCount: nextTotalCount,
          isMutating: false,
          errorCode: null,
        ),
      );

      DashboardCubit.publishMyReviewsCount(nextTotalCount);
      return true;
    } catch (_) {
      emit(state.copyWith(isMutating: false, errorCode: loadFailedError));
      return false;
    }
  }
}
