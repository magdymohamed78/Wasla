import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/repositories/customer_offers_repository.dart';
import '../../domain/entities/offer_filter.dart';
import '../../domain/entities/offer_page_result.dart';
import '../../domain/entities/offer_status_counts.dart';
import '../../domain/entities/offer_summary_item.dart';

enum CustomerOffersViewStatus { initial, loading, success, empty, error }

class CustomerOffersState {
  final CustomerOffersViewStatus status;
  final OfferFilter activeFilter;
  final OfferStatusCounts globalCounts;
  final List<OfferSummaryItem> items;
  final int nextPageIndex;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? errorCode;

  const CustomerOffersState({
    this.status = CustomerOffersViewStatus.initial,
    this.activeFilter = OfferFilter.all,
    this.globalCounts = const OfferStatusCounts(),
    this.items = const [],
    this.nextPageIndex = 1,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.errorCode,
  });

  CustomerOffersState copyWith({
    CustomerOffersViewStatus? status,
    OfferFilter? activeFilter,
    OfferStatusCounts? globalCounts,
    List<OfferSummaryItem>? items,
    int? nextPageIndex,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? errorCode,
  }) {
    return CustomerOffersState(
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

class CustomerOffersCubit extends Cubit<CustomerOffersState> {
  static const String loadFailedError = 'customer_offers_load_failed';
  static const int _pageSize = 20;

  final CustomerOffersRepository _repository;

  CustomerOffersCubit({
    required CustomerOffersRepository repository,
  }) : _repository = repository,
       super(const CustomerOffersState());

  Future<void> load() async {
    emit(
      state.copyWith(
        status: CustomerOffersViewStatus.loading,
        errorCode: null,
        items: const [],
        nextPageIndex: 1,
        hasReachedEnd: false,
      ),
    );

    try {
      final allResult = await _fetchPaged(filter: null, pageIndex: 1);
      final globalCounts = allResult.statusCounts;

      if (state.activeFilter == OfferFilter.all) {
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
      debugPrint('[CustomerOffersCubit] load error: $error');
      debugPrint('[CustomerOffersCubit] stack: $stackTrace');
      emit(
        state.copyWith(
          status: CustomerOffersViewStatus.error,
          errorCode: loadFailedError,
        ),
      );
    }
  }

  Future<void> changeFilter(OfferFilter filter) async {
    if (filter == state.activeFilter &&
        state.status == CustomerOffersViewStatus.success) {
      return;
    }

    emit(
      state.copyWith(
        status: CustomerOffersViewStatus.loading,
        activeFilter: filter,
        errorCode: null,
        items: const [],
        nextPageIndex: 1,
        hasReachedEnd: false,
      ),
    );

    try {
      final result = await _fetchPaged(
        filter: filter == OfferFilter.all ? null : filter,
        pageIndex: 1,
      );
      _emitSuccess(result.items, result.hasReachedEnd, state.globalCounts);
    } catch (error, stackTrace) {
      debugPrint('[CustomerOffersCubit] changeFilter error: $error');
      debugPrint('[CustomerOffersCubit] stack: $stackTrace');
      emit(
        state.copyWith(
          status: CustomerOffersViewStatus.error,
          errorCode: loadFailedError,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.hasReachedEnd || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final filter = state.activeFilter == OfferFilter.all
          ? null
          : state.activeFilter;
      final result = await _fetchPaged(
        filter: filter,
        pageIndex: state.nextPageIndex,
      );

      final existingIds = state.items.map((item) => item.offerId).toSet();

      final newItems = result.items
          .where((item) => !existingIds.contains(item.offerId))
          .toList();

      final merged = [...state.items, ...newItems];

      emit(
        state.copyWith(
          status: merged.isEmpty
              ? CustomerOffersViewStatus.empty
              : CustomerOffersViewStatus.success,
          items: merged,
          nextPageIndex: state.nextPageIndex + 1,
          hasReachedEnd: result.hasReachedEnd,
          isLoadingMore: false,
          errorCode: null,
        ),
      );
    } catch (error) {
      debugPrint('[CustomerOffersCubit] loadMore error: $error');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> retry() async {
    await load();
  }

  void _emitSuccess(
    List<OfferSummaryItem> items,
    bool hasReachedEnd,
    OfferStatusCounts globalCounts,
  ) {
    emit(
      state.copyWith(
        status: items.isEmpty
            ? CustomerOffersViewStatus.empty
            : CustomerOffersViewStatus.success,
        items: items,
        hasReachedEnd: hasReachedEnd,
        nextPageIndex: 2,
        globalCounts: globalCounts,
        errorCode: null,
      ),
    );
  }

  Future<OfferPageResult> _fetchPaged({
    required OfferFilter? filter,
    required int pageIndex,
  }) {
    final statusValue =
        filter != null && filter != OfferFilter.all
            ? filter.toQueryValue()
            : null;
    return _repository.getCustomerOffersPaged(
      pageIndex: pageIndex,
      pageSize: _pageSize,
      status: statusValue,
    );
  }
}
