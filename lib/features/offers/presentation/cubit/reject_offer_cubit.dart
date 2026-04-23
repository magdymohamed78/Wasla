import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../domain/use_cases/reject_offer_use_case.dart';
import 'reject_offer_state.dart';

/// Cubit managing the reject offer form lifecycle.
class RejectOfferCubit extends Cubit<RejectOfferState> {
  final RejectOfferUseCase _rejectOfferUseCase;

  RejectOfferCubit({
    required int offerId,
    required RejectOfferUseCase rejectOfferUseCase,
  })  : _rejectOfferUseCase = rejectOfferUseCase,
        super(RejectOfferState(offerId: offerId));

  void updateReason(String value) {
    emit(state.copyWith(rejectionReason: value));
  }

  Future<void> submit() async {
    // Client-side validation
    if (state.rejectionReason.trim().isEmpty) {
      emit(state.copyWith(errorCode: 'REASON_REQUIRED'));
      return;
    }
    if (state.rejectionReason.trim().length > 2000) {
      emit(state.copyWith(errorCode: 'REASON_TOO_LONG'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorCode: null));

    try {
      await _rejectOfferUseCase(
        offerId: state.offerId,
        rejectionReason: state.rejectionReason.trim(),
      );
      emit(state.copyWith(
        status: LoadStatus.success,
        isSubmitting: false,
      ));
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 409) {
        emit(state.copyWith(
          isSubmitting: false,
          errorCode: RejectOfferState.terminalStateError,
        ));
      } else if (code == 403) {
        emit(state.copyWith(
          isSubmitting: false,
          errorCode: RejectOfferState.forbiddenError,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorCode: RejectOfferState.genericError,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        errorCode: RejectOfferState.genericError,
      ));
    }
  }
}
