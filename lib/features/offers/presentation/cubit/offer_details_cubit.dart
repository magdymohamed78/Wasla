import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../domain/use_cases/get_offer_details_use_case.dart';
import 'offer_details_state.dart';

/// Cubit that loads and manages the state of the offer details screen.
class OfferDetailsCubit extends Cubit<OfferDetailsState> {
  final GetOfferDetailsUseCase _getDetailsUseCase;

  OfferDetailsCubit({
    required int offerId,
    required GetOfferDetailsUseCase getDetailsUseCase,
  })  : _getDetailsUseCase = getDetailsUseCase,
        super(OfferDetailsState(offerId: offerId));

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, errorCode: null));

    try {
      final details = await _getDetailsUseCase(offerId: state.offerId);
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
            errorCode: OfferDetailsState.notFoundError,
          ),
        );
      } else if (code == 403) {
        emit(
          state.copyWith(
            status: LoadStatus.error,
            errorCode: OfferDetailsState.accessDeniedError,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: LoadStatus.error,
            errorCode: OfferDetailsState.loadFailedError,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: LoadStatus.error,
          errorCode: OfferDetailsState.loadFailedError,
        ),
      );
    }
  }
}
