import '../../../../core/types/load_status.dart';

class DashboardState {
  static const Object _unset = Object();

  final LoadStatus status;
  final int totalOffers;
  final int acceptedOffers;
  final int pendingOffers;
  final int myReviews;
  final bool hasPartialData;
  final String? errorCode;

  const DashboardState({
    this.status = LoadStatus.initial,
    this.totalOffers = 0,
    this.acceptedOffers = 0,
    this.pendingOffers = 0,
    this.myReviews = 0,
    this.hasPartialData = false,
    this.errorCode,
  });

  DashboardState copyWith({
    LoadStatus? status,
    int? totalOffers,
    int? acceptedOffers,
    int? pendingOffers,
    int? myReviews,
    bool? hasPartialData,
    Object? errorCode = _unset,
  }) {
    return DashboardState(
      status: status ?? this.status,
      totalOffers: totalOffers ?? this.totalOffers,
      acceptedOffers: acceptedOffers ?? this.acceptedOffers,
      pendingOffers: pendingOffers ?? this.pendingOffers,
      myReviews: myReviews ?? this.myReviews,
      hasPartialData: hasPartialData ?? this.hasPartialData,
      errorCode: identical(errorCode, _unset) ? this.errorCode : errorCode as String?,
    );
  }
}
