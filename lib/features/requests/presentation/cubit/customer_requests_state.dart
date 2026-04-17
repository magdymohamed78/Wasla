import '../../domain/entities/request_filter.dart';
import '../../domain/entities/request_page_result.dart';
import '../../domain/entities/request_status_counts.dart';

enum CustomerRequestsViewStatus { initial, loading, success, empty, error }

class CustomerRequestsState {
  final CustomerRequestsViewStatus status;
  final RequestFilter activeFilter;
  final RequestStatusCounts globalCounts;
  final List<RequestSummaryItem> items;
  final int nextPageIndex;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? errorCode;

  const CustomerRequestsState({
    this.status = CustomerRequestsViewStatus.initial,
    this.activeFilter = RequestFilter.all,
    this.globalCounts = const RequestStatusCounts(),
    this.items = const [],
    this.nextPageIndex = 1,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.errorCode,
  });

  CustomerRequestsState copyWith({
    CustomerRequestsViewStatus? status,
    RequestFilter? activeFilter,
    RequestStatusCounts? globalCounts,
    List<RequestSummaryItem>? items,
    int? nextPageIndex,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? errorCode,
  }) {
    return CustomerRequestsState(
      status: status ?? this.status,
      activeFilter: activeFilter ?? this.activeFilter,
      globalCounts: globalCounts ?? this.globalCounts,
      items: items ?? this.items,
      nextPageIndex: nextPageIndex ?? this.nextPageIndex,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorCode: errorCode,
    );
  }
}
