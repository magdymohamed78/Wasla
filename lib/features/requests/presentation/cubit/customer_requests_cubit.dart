import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../../domain/entities/request_filter.dart';
import '../../domain/entities/request_page_result.dart';
import '../../domain/entities/request_status_counts.dart';
import '../../domain/entities/service_request_details.dart';
import 'customer_requests_state.dart';

class CustomerRequestsCubit extends Cubit<CustomerRequestsState> {
  static const String loadFailedError = 'customer_requests_load_failed';
  static const int _pageSize = 20;
  static const int _ensureDetailsMaxAttempts = 3;
  static const Duration _ensureDetailsRetryDelay = Duration(milliseconds: 300);

  final GetCustomerServiceRequestsUseCase _getCustomerServiceRequestsUseCase;
  final GetCustomerServiceRequestDetailsUseCase
  _getCustomerServiceRequestDetailsUseCase;

  int _requestOperationId = 0;
  int? _lastEnsureRequestId;

  CustomerRequestsCubit({
    required GetCustomerServiceRequestsUseCase
    getCustomerServiceRequestsUseCase,
    required GetCustomerServiceRequestDetailsUseCase
    getCustomerServiceRequestDetailsUseCase,
  }) : _getCustomerServiceRequestsUseCase = getCustomerServiceRequestsUseCase,
       _getCustomerServiceRequestDetailsUseCase =
           getCustomerServiceRequestDetailsUseCase,
       super(const CustomerRequestsState());

  Future<void> onPageOpened({int? ensureRequestId}) {
    _log('lifecycle:onPageOpened ensureRequestId=$ensureRequestId');
    return fetchRequests(
      forceRefresh: true,
      ensureRequestId: ensureRequestId,
      trigger: 'onPageOpened',
    );
  }

  Future<void> refresh({int? ensureRequestId}) {
    _log('lifecycle:refresh ensureRequestId=$ensureRequestId');
    return fetchRequests(
      forceRefresh: true,
      ensureRequestId: ensureRequestId,
      trigger: 'refresh',
    );
  }

  Future<void> load({int? ensureRequestId}) {
    _log('lifecycle:load ensureRequestId=$ensureRequestId');
    return fetchRequests(
      forceRefresh: true,
      ensureRequestId: ensureRequestId,
      trigger: 'load',
    );
  }

  Future<void> fetchRequests({
    bool forceRefresh = false,
    int? ensureRequestId,
    String trigger = 'manual',
  }) async {
    final operationId = ++_requestOperationId;
    final activeFilter = state.activeFilter;
    final effectiveEnsureRequestId = _effectiveEnsureRequestId(ensureRequestId);

    _log(
      'lifecycle:fetchRequests start op=$operationId trigger=$trigger '
      'forceRefresh=$forceRefresh activeFilter=${activeFilter.name} '
      'ensureRequestId=$effectiveEnsureRequestId',
    );

    _emitState(
      state.copyWith(
        status: CustomerRequestsViewStatus.loading,
        errorCode: null,
        items: const [],
        nextPageIndex: 1,
        hasReachedEnd: false,
        isLoadingMore: false,
      ),
      transition: 'enter loading op=$operationId trigger=$trigger',
    );

    try {
      final allResult = await _fetchPaged(
        filter: null,
        pageIndex: 1,
        forceRefresh: forceRefresh,
        operationId: operationId,
        trigger: trigger,
      );

      if (!_isLatestRequestOperation(operationId, stage: 'after all page')) {
        return;
      }

      final globalCounts = allResult.statusCounts;
      RequestPageResult visibleResult = allResult;

      if (activeFilter != RequestFilter.all) {
        visibleResult = await _fetchPaged(
          filter: activeFilter,
          pageIndex: 1,
          forceRefresh: forceRefresh,
          operationId: operationId,
          trigger: trigger,
        );

        if (!_isLatestRequestOperation(
          operationId,
          stage: 'after filtered page',
        )) {
          return;
        }
      }

      final ensuredItems = await _ensureRequestIncluded(
        items: visibleResult.items,
        activeFilter: activeFilter,
        ensureRequestId: effectiveEnsureRequestId,
      );

      if (!_isLatestRequestOperation(
        operationId,
        stage: 'after ensure include',
      )) {
        return;
      }

      _emitSuccess(
        ensuredItems,
        visibleResult.hasReachedEnd,
        globalCounts,
        operationId: operationId,
        trigger: trigger,
      );
    } catch (error, stackTrace) {
      if (!_isLatestRequestOperation(operationId, stage: 'error')) {
        return;
      }

      _log(
        'api:fetchRequests error op=$operationId trigger=$trigger error=$error',
      );
      _log('api:fetchRequests stack op=$operationId stack=$stackTrace');

      _emitState(
        state.copyWith(
          status: CustomerRequestsViewStatus.error,
          errorCode: loadFailedError,
          isLoadingMore: false,
        ),
        transition: 'enter error op=$operationId trigger=$trigger',
      );
    }
  }

  Future<void> changeFilter(
    RequestFilter filter, {
    bool forceRefresh = false,
  }) async {
    final shouldSkip =
        filter == state.activeFilter &&
        !forceRefresh &&
        state.status == CustomerRequestsViewStatus.success;

    if (shouldSkip) {
      _log(
        'lifecycle:changeFilter skipped filter=${filter.name} '
        'forceRefresh=$forceRefresh status=${state.status.name}',
      );
      return;
    }

    if (filter != state.activeFilter) {
      _emitState(
        state.copyWith(activeFilter: filter),
        transition: 'filter changed to ${filter.name}',
      );
    }

    await fetchRequests(
      forceRefresh: true,
      ensureRequestId: _effectiveEnsureRequestId(null),
      trigger: 'changeFilter:${filter.name}',
    );
  }

  Future<void> loadMore() async {
    if (state.hasReachedEnd) {
      _log('lifecycle:loadMore skipped because hasReachedEnd=true');
      return;
    }
    if (state.isLoadingMore) {
      _log('lifecycle:loadMore skipped because isLoadingMore=true');
      return;
    }

    final operationIdAtStart = _requestOperationId;
    final nextPageIndex = state.nextPageIndex;
    final filter = state.activeFilter == RequestFilter.all
        ? null
        : state.activeFilter;

    _log(
      'lifecycle:loadMore start baseOp=$operationIdAtStart page=$nextPageIndex '
      'filter=${state.activeFilter.name}',
    );

    _emitState(
      state.copyWith(isLoadingMore: true, errorCode: null),
      transition: 'loadMore set loadingMore=true baseOp=$operationIdAtStart',
    );

    try {
      final result = await _fetchPaged(
        filter: filter,
        pageIndex: nextPageIndex,
        forceRefresh: true,
        operationId: operationIdAtStart,
        trigger: 'loadMore',
      );

      if (!_isLatestRequestOperation(
        operationIdAtStart,
        stage: 'loadMore response',
      )) {
        return;
      }

      final existingIds = state.items
          .map((item) => item.serviceRequestId)
          .toSet();

      final newItems = result.items
          .where((item) => !existingIds.contains(item.serviceRequestId))
          .toList();

      final merged = _sortNewestFirst([...state.items, ...newItems]);

      _emitState(
        state.copyWith(
          status: merged.isEmpty
              ? CustomerRequestsViewStatus.empty
              : CustomerRequestsViewStatus.success,
          items: merged,
          nextPageIndex: nextPageIndex + 1,
          hasReachedEnd: result.hasReachedEnd,
          isLoadingMore: false,
          errorCode: null,
        ),
        transition:
            'loadMore success baseOp=$operationIdAtStart merged=${merged.length} '
            'new=${newItems.length} hasReachedEnd=${result.hasReachedEnd}',
      );
    } catch (error, stackTrace) {
      if (!_isLatestRequestOperation(
        operationIdAtStart,
        stage: 'loadMore error',
      )) {
        return;
      }

      _log('api:loadMore error baseOp=$operationIdAtStart error=$error');
      _log('api:loadMore stack baseOp=$operationIdAtStart stack=$stackTrace');

      _emitState(
        state.copyWith(isLoadingMore: false),
        transition:
            'loadMore failed reset loadingMore=false baseOp=$operationIdAtStart',
      );
    }
  }

  Future<void> retry() {
    _log('lifecycle:retry');
    return fetchRequests(
      forceRefresh: true,
      ensureRequestId: _effectiveEnsureRequestId(null),
      trigger: 'retry',
    );
  }

  int? _effectiveEnsureRequestId(int? ensureRequestId) {
    if (ensureRequestId != null && ensureRequestId > 0) {
      _lastEnsureRequestId = ensureRequestId;
    }
    return _lastEnsureRequestId;
  }

  bool _isLatestRequestOperation(int operationId, {required String stage}) {
    final isLatest = operationId == _requestOperationId;
    if (!isLatest) {
      _log(
        'lifecycle:stale operation ignored op=$operationId '
        'current=$_requestOperationId stage=$stage',
      );
    }
    return isLatest;
  }

  void _emitSuccess(
    List<RequestSummaryItem> items,
    bool hasReachedEnd,
    RequestStatusCounts globalCounts, {
    required int operationId,
    required String trigger,
  }) {
    final sortedItems = _sortNewestFirst(items);

    _emitState(
      state.copyWith(
        status: sortedItems.isEmpty
            ? CustomerRequestsViewStatus.empty
            : CustomerRequestsViewStatus.success,
        items: sortedItems,
        hasReachedEnd: hasReachedEnd,
        nextPageIndex: 2,
        globalCounts: globalCounts,
        isLoadingMore: false,
        errorCode: null,
      ),
      transition:
          'enter success op=$operationId trigger=$trigger '
          'items=${sortedItems.length} hasReachedEnd=$hasReachedEnd',
    );
  }

  void _emitState(
    CustomerRequestsState nextState, {
    required String transition,
  }) {
    _log(
      'state:$transition -> status=${nextState.status.name}, '
      'filter=${nextState.activeFilter.name}, '
      'items=${nextState.items.length}, '
      'nextPageIndex=${nextState.nextPageIndex}, '
      'hasReachedEnd=${nextState.hasReachedEnd}, '
      'isLoadingMore=${nextState.isLoadingMore}, '
      'errorCode=${nextState.errorCode}',
    );
    emit(nextState);
  }

  void _log(String message) {
    debugPrint('[CustomerRequestsCubit] $message');
  }

  Future<List<RequestSummaryItem>> _ensureRequestIncluded({
    required List<RequestSummaryItem> items,
    required RequestFilter activeFilter,
    int? ensureRequestId,
  }) async {
    if (ensureRequestId == null) {
      _log('api:ensure skipped reason=no-request-id');
      return items;
    }

    final hasRequestedItem = items.any(
      (item) => item.serviceRequestId == ensureRequestId,
    );
    if (hasRequestedItem) {
      _log('api:ensure skipped reason=already-present id=$ensureRequestId');
      return items;
    }

    _log(
      'api:ensure start id=$ensureRequestId activeFilter=${activeFilter.name}',
    );

    try {
      final details = await _fetchEnsuredDetailsWithRetry(
        ensureRequestId: ensureRequestId,
      );

      final shouldInject =
          activeFilter == RequestFilter.all ||
          details.normalizedFilter == activeFilter;
      if (!shouldInject) {
        _log(
          'api:ensure skipped reason=filter-mismatch '
          'requestFilter=${details.normalizedFilter.name} '
          'activeFilter=${activeFilter.name}',
        );
        return items;
      }

      _log('api:ensure injected id=$ensureRequestId');
      return [_toSummaryItem(details), ...items];
    } catch (error, stackTrace) {
      _log('api:ensure error id=$ensureRequestId error=$error');
      _log('api:ensure stack id=$ensureRequestId stack=$stackTrace');
      return items;
    }
  }

  Future<ServiceRequestDetails> _fetchEnsuredDetailsWithRetry({
    required int ensureRequestId,
  }) async {
    Object? lastError;

    for (var attempt = 0; attempt < _ensureDetailsMaxAttempts; attempt++) {
      try {
        _log(
          'api:ensure details attempt ${attempt + 1}/$_ensureDetailsMaxAttempts '
          'id=$ensureRequestId',
        );
        return await _getCustomerServiceRequestDetailsUseCase(
          serviceRequestId: ensureRequestId,
        );
      } catch (error, stackTrace) {
        lastError = error;
        _log(
          'api:ensure details attempt '
          '${attempt + 1}/$_ensureDetailsMaxAttempts failed: $error',
        );
        _log('api:ensure details stack id=$ensureRequestId stack=$stackTrace');

        final hasMoreAttempts = attempt < _ensureDetailsMaxAttempts - 1;
        if (hasMoreAttempts) {
          _log(
            'api:ensure details retrying after '
            '${_ensureDetailsRetryDelay.inMilliseconds}ms',
          );
          await Future<void>.delayed(_ensureDetailsRetryDelay);
        }
      }
    }

    throw Exception(
      'Failed to ensure request details for $ensureRequestId: '
      '${lastError ?? 'unknown error'}',
    );
  }

  RequestSummaryItem _toSummaryItem(ServiceRequestDetails details) {
    return RequestSummaryItem(
      serviceRequestId: details.serviceRequestId,
      referenceNumber: details.referenceNumber,
      companyId: details.companyId,
      companyName: details.companyName,
      companyLogoUrl: details.companyLogoUrl,
      serviceType: details.serviceType,
      rawStatus: details.rawStatus,
      normalizedFilter: details.normalizedFilter,
      preferredDate: details.preferredDate,
      createdAt: details.createdAt,
      hasOffer: details.hasOffer,
      offerId: details.offerId,
    );
  }

  List<RequestSummaryItem> _sortNewestFirst(List<RequestSummaryItem> items) {
    final sorted = List<RequestSummaryItem>.from(items);
    sorted.sort((a, b) {
      final aCreatedAt = a.createdAt;
      final bCreatedAt = b.createdAt;

      if (aCreatedAt != null && bCreatedAt != null) {
        final createdAtCompare = bCreatedAt.compareTo(aCreatedAt);
        if (createdAtCompare != 0) {
          return createdAtCompare;
        }
      } else if (aCreatedAt == null && bCreatedAt != null) {
        return 1;
      } else if (aCreatedAt != null && bCreatedAt == null) {
        return -1;
      }

      return b.serviceRequestId.compareTo(a.serviceRequestId);
    });
    return sorted;
  }

  Future<RequestPageResult> _fetchPaged({
    required RequestFilter? filter,
    required int pageIndex,
    required bool forceRefresh,
    required int operationId,
    required String trigger,
  }) async {
    final filterLabel = filter?.name ?? RequestFilter.all.name;
    _log(
      'api:getPaged start op=$operationId trigger=$trigger '
      'page=$pageIndex filter=$filterLabel forceRefresh=$forceRefresh',
    );

    final result = await _getCustomerServiceRequestsUseCase.getPaged(
      pageIndex: pageIndex,
      pageSize: _pageSize,
      filter: filter,
    );

    _log(
      'api:getPaged success op=$operationId trigger=$trigger '
      'page=$pageIndex filter=$filterLabel items=${result.items.length} '
      'totalPages=${result.totalPages} hasReachedEnd=${result.hasReachedEnd}',
    );

    return result;
  }

  RequestStatusCounts get currentCounts => state.globalCounts;
}
