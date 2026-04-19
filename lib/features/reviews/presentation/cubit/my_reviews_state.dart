import '../../../../core/types/load_status.dart';
import '../../../home/domain/entities/customer_review_item.dart';

class MyReviewsState {
  static const Object _unset = Object();

  final LoadStatus status;
  final List<CustomerReviewItem> items;
  final int totalCount;
  final int nextPageIndex;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final bool isMutating;
  final String? errorCode;

  const MyReviewsState({
    this.status = LoadStatus.initial,
    this.items = const [],
    this.totalCount = 0,
    this.nextPageIndex = 1,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.errorCode,
  });

  MyReviewsState copyWith({
    LoadStatus? status,
    List<CustomerReviewItem>? items,
    int? totalCount,
    int? nextPageIndex,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    bool? isMutating,
    Object? errorCode = _unset,
  }) {
    return MyReviewsState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      nextPageIndex: nextPageIndex ?? this.nextPageIndex,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      errorCode: identical(errorCode, _unset) ? this.errorCode : errorCode as String?,
    );
  }
}
