import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../../offers/domain/entities/offer_status_counts.dart';
import '../../domain/repositories/customer_offers_repository.dart';
import '../../domain/repositories/customer_reviews_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  static final StreamController<int> _myReviewsCountController =
      StreamController<int>.broadcast();

  static void publishMyReviewsCount(int count) {
    if (_myReviewsCountController.isClosed) {
      return;
    }
    _myReviewsCountController.add(count);
  }

  final CustomerOffersRepository _customerOffersRepository;
  final CustomerReviewsRepository _customerReviewsRepository;
  late final StreamSubscription<int> _myReviewsSyncSubscription;

  DashboardCubit({
    required CustomerOffersRepository customerOffersRepository,
    required CustomerReviewsRepository customerReviewsRepository,
  }) : _customerOffersRepository = customerOffersRepository,
       _customerReviewsRepository = customerReviewsRepository,
       super(const DashboardState()) {
    _myReviewsSyncSubscription = _myReviewsCountController.stream.listen(
      syncMyReviewsCount,
    );
  }

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        hasPartialData: false,
        errorCode: null,
      ),
    );

    OfferStatusCounts? offerStatusCounts;
    int? reviewsCount;

    try {
      final offerPage = await _customerOffersRepository.getCustomerOffersPaged(
        pageIndex: 1,
        pageSize: 1,
      );
      offerStatusCounts = offerPage.statusCounts;
    } catch (_) {
      offerStatusCounts = null;
    }

    try {
      reviewsCount = await _customerReviewsRepository.getMyReviewsCount();
    } catch (_) {
      reviewsCount = null;
    }

    final hasOffersData = offerStatusCounts != null;
    final hasReviewsData = reviewsCount != null;
    final hasAnyData = hasOffersData || hasReviewsData;

    if (!hasAnyData) {
      emit(
        state.copyWith(
          status: LoadStatus.error,
          hasPartialData: false,
          errorCode: 'dashboard_load_failed',
        ),
      );
      return;
    }

    final totalOffers = hasOffersData ? offerStatusCounts.all : 0;
    final acceptedOffers = hasOffersData ? offerStatusCounts.accepted : 0;
    final pendingOffers = hasOffersData ? offerStatusCounts.pending : 0;

    emit(
      state.copyWith(
        status: LoadStatus.success,
        totalOffers: totalOffers < 0 ? 0 : totalOffers,
        acceptedOffers: acceptedOffers < 0 ? 0 : acceptedOffers,
        pendingOffers: pendingOffers < 0 ? 0 : pendingOffers,
        myReviews: (reviewsCount ?? 0) < 0 ? 0 : (reviewsCount ?? 0),
        hasPartialData: !(hasOffersData && hasReviewsData),
        errorCode: hasOffersData && hasReviewsData ? null : 'dashboard_partial_data',
      ),
    );
  }

  Future<void> retry() async {
    await load();
  }

  void syncMyReviewsCount(int count) {
    emit(
      state.copyWith(
        myReviews: count < 0 ? 0 : count,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _myReviewsSyncSubscription.cancel();
    return super.close();
  }
}
