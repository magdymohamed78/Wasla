import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/customer_portal_content.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';

class CustomerRequestsState {
  final LoadStatus status;
  final List<CustomerServiceRequestSummary> items;
  final String? errorMessage;

  const CustomerRequestsState({
    this.status = LoadStatus.initial,
    this.items = const <CustomerServiceRequestSummary>[],
    this.errorMessage,
  });

  CustomerRequestsState copyWith({
    LoadStatus? status,
    List<CustomerServiceRequestSummary>? items,
    String? errorMessage,
  }) {
    return CustomerRequestsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}

class CustomerRequestsCubit extends Cubit<CustomerRequestsState> {
  static const String loadFailedError = 'customer_requests_load_failed';

  final GetCustomerServiceRequestsUseCase _getCustomerServiceRequestsUseCase;

  CustomerRequestsCubit({
    required GetCustomerServiceRequestsUseCase
    getCustomerServiceRequestsUseCase,
  }) : _getCustomerServiceRequestsUseCase = getCustomerServiceRequestsUseCase,
       super(const CustomerRequestsState());

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, errorMessage: null));

    try {
      final items = await _getCustomerServiceRequestsUseCase();
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
