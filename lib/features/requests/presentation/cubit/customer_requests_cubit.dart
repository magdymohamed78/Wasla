import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../../domain/entities/request_filter.dart';
import '../../domain/entities/request_page_result.dart';
import '../../domain/entities/request_status_counts.dart';
import 'customer_requests_state.dart';

class CustomerRequestsCubit extends Cubit<CustomerRequestsState> {
  static const String loadFailedError = 'customer_requests_load_failed';
  static const int _pageSize = 20;

  final GetCustomerServiceRequestsUseCase _getCustomerServiceRequestsUseCase;

  CustomerRequestsCubit({
    required GetCustomerServiceRequestsUseCase
    getCustomerServiceRequestsUseCase,
  }) : _getCustomerServiceRequestsUseCase = getCustomerServiceRequestsUseCase,
       super(const CustomerRequestsState());

  Future<void> load() async {
    emit(
      state.copyWith(
        status: CustomerRequestsViewStatus.loading,
        errorCode: null,
        items: const [],
        nextPageIndex: 1,
        hasReachedEnd: false,
      ),
    );

    try {
      final allResult = await _fetchPaged(filter: null, pageIndex: 1);
      final globalCounts = allResult.statusCounts;

      if (state.activeFilter == RequestFilter.all) {
        _emitSuccess(allResult.items, allResult.hasReachedEnd, globalCounts);
      } else {
        final filteredResult = await _fetchPaged(
          filter: state.activeFilter,
          pageIndex: 1,
        );
        _emitSuccess(
          filteredResult.items,
          filteredResult.hasReachedEnd,
          globalCounts,
        );
      }
    } catch (error, stackTrace) {
      debugPrint('[CustomerRequestsCubit] load error: $error');
      debugPrint('[CustomerRequestsCubit] stack: $stackTrace');
      emit(
        state.copyWith(
          status: CustomerRequestsViewStatus.error,
          errorCode: loadFailedError,
        ),
      );
    }
  }

  Future<void> changeFilter(RequestFilter filter) async {
    if (filter == state.activeFilter &&
        state.status == CustomerRequestsViewStatus.success) {
      return;
    }

    emit(
      state.copyWith(
        status: CustomerRequestsViewStatus.loading,
        activeFilter: filter,
        errorCode: null,
        items: const [],
        nextPageIndex: 1,
        hasReachedEnd: false,
      ),
    );

    try {
      final result = await _fetchPaged(
        filter: filter == RequestFilter.all ? null : filter,
        pageIndex: 1,
      );
      _emitSuccess(result.items, result.hasReachedEnd, state.globalCounts);
    } catch (error, stackTrace) {
      debugPrint('[CustomerRequestsCubit] changeFilter error: $error');
      debugPrint('[CustomerRequestsCubit] stack: $stackTrace');
      emit(
        state.copyWith(
          status: CustomerRequestsViewStatus.error,
          errorCode: loadFailedError,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.hasReachedEnd || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final filter = state.activeFilter == RequestFilter.all
          ? null
          : state.activeFilter;
      final result = await _fetchPaged(
        filter: filter,
        pageIndex: state.nextPageIndex,
      );

      final existingIds = state.items
          .map((item) => item.serviceRequestId)
          .toSet();

      final newItems = result.items
          .where((item) => !existingIds.contains(item.serviceRequestId))
          .toList();

      final merged = [...state.items, ...newItems];

      emit(
        state.copyWith(
          status: merged.isEmpty
              ? CustomerRequestsViewStatus.empty
              : CustomerRequestsViewStatus.success,
          items: merged,
          nextPageIndex: state.nextPageIndex + 1,
          hasReachedEnd: result.hasReachedEnd,
          isLoadingMore: false,
          errorCode: null,
        ),
      );
    } catch (error) {
      debugPrint('[CustomerRequestsCubit] loadMore error: $error');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> retry() async {
    await load();
  }

  void _emitSuccess(
    List<RequestSummaryItem> items,
    bool hasReachedEnd,
    RequestStatusCounts globalCounts,
  ) {
    emit(
      state.copyWith(
        status: items.isEmpty
            ? CustomerRequestsViewStatus.empty
            : CustomerRequestsViewStatus.success,
        items: items,
        hasReachedEnd: hasReachedEnd,
        nextPageIndex: 2,
        globalCounts: globalCounts,
        errorCode: null,
      ),
    );
  }

  Future<RequestPageResult> _fetchPaged({
    required RequestFilter? filter,
    required int pageIndex,
  }) {
    return _getCustomerServiceRequestsUseCase.getPaged(
      pageIndex: pageIndex,
      pageSize: _pageSize,
      filter: filter,
    );
  }

  RequestStatusCounts get currentCounts => state.globalCounts;
}
