import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_portal_content.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/customer_portal_use_cases.dart';

class CustomerOffersState {
  final LoadStatus status;
  final List<CustomerOfferSummary> items;
  final String? errorMessage;

  const CustomerOffersState({
    this.status = LoadStatus.initial,
    this.items = const <CustomerOfferSummary>[],
    this.errorMessage,
  });

  CustomerOffersState copyWith({
    LoadStatus? status,
    List<CustomerOfferSummary>? items,
    String? errorMessage,
  }) {
    return CustomerOffersState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}

class CustomerOffersCubit extends Cubit<CustomerOffersState> {
  static const String loadFailedError = 'customer_offers_load_failed';

  final GetCustomerOffersUseCase _getCustomerOffersUseCase;

  CustomerOffersCubit({
    required GetCustomerOffersUseCase getCustomerOffersUseCase,
  }) : _getCustomerOffersUseCase = getCustomerOffersUseCase,
       super(const CustomerOffersState());

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, errorMessage: null));

    try {
      final items = await _getCustomerOffersUseCase();
      emit(
        state.copyWith(
          status: items.isEmpty ? LoadStatus.empty : LoadStatus.success,
          items: items,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(status: LoadStatus.error, errorMessage: loadFailedError),
      );
    }
  }
}
