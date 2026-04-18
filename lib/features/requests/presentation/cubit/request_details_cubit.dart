import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../../home/domain/use_cases/get_customer_service_request_details_use_case.dart';
import 'request_details_state.dart';

class RequestDetailsCubit extends Cubit<RequestDetailsState> {
  final GetCustomerServiceRequestDetailsUseCase _getDetailsUseCase;

  RequestDetailsCubit({
    required int serviceRequestId,
    required GetCustomerServiceRequestDetailsUseCase getDetailsUseCase,
  }) : _getDetailsUseCase = getDetailsUseCase,
       super(RequestDetailsState(serviceRequestId: serviceRequestId));

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, errorCode: null));

    try {
      final details = await _getDetailsUseCase(
        serviceRequestId: state.serviceRequestId,
      );
      emit(
        state.copyWith(
          status: LoadStatus.success,
          details: details,
          errorCode: null,
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404) {
        emit(
          state.copyWith(
            status: LoadStatus.error,
            errorCode: RequestDetailsState.notFoundError,
          ),
        );
      } else if (code == 403) {
        emit(
          state.copyWith(
            status: LoadStatus.error,
            errorCode: RequestDetailsState.accessDeniedError,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: LoadStatus.error,
            errorCode: RequestDetailsState.loadFailedError,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: LoadStatus.error,
          errorCode: RequestDetailsState.loadFailedError,
        ),
      );
    }
  }
}
