import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../domain/repositories/customer_portal_repository.dart';
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

  final CustomerPortalRepository _customerPortalRepository;
  late final StreamSubscription<int> _myReviewsSyncSubscription;

  DashboardCubit({required CustomerPortalRepository customerPortalRepository})
    : _customerPortalRepository = customerPortalRepository,
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

    try {
      final metrics = await _customerPortalRepository
          .getCustomerDashboardMetrics();

      emit(
        state.copyWith(
          status: LoadStatus.success,
          totalOffers: metrics.totalOffers < 0 ? 0 : metrics.totalOffers,
          acceptedOffers: metrics.acceptedOffers < 0
              ? 0
              : metrics.acceptedOffers,
          pendingOffers: metrics.pendingOffers < 0 ? 0 : metrics.pendingOffers,
          myReviews: metrics.totalReviews < 0 ? 0 : metrics.totalReviews,
          hasPartialData: false,
          errorCode: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoadStatus.error,
          hasPartialData: false,
          errorCode: 'dashboard_load_failed',
        ),
      );
    }
  }

  Future<void> retry() async {
    await load();
  }

  void syncMyReviewsCount(int count) {
    emit(state.copyWith(myReviews: count < 0 ? 0 : count));
  }

  @override
  Future<void> close() async {
    await _myReviewsSyncSubscription.cancel();
    return super.close();
  }
}
