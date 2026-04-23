import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/types/load_status.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/use_cases/accept_offer_use_case.dart';
import 'accept_offer_state.dart';

/// Cubit managing the accept offer form lifecycle.
class AcceptOfferCubit extends Cubit<AcceptOfferState> {
  final AcceptOfferUseCase _acceptOfferUseCase;

  AcceptOfferCubit({
    required int offerId,
    required AcceptOfferUseCase acceptOfferUseCase,
  })  : _acceptOfferUseCase = acceptOfferUseCase,
        super(AcceptOfferState(offerId: offerId));

  void selectPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  void updateSignature(String value) {
    emit(state.copyWith(signature: value));
  }

  void toggleConfirmation() {
    emit(state.copyWith(isConfirmed: !state.isConfirmed));
  }

  /// Validates inputs and submits the accept request.
  Future<void> submit() async {
    // Client-side validation
    if (state.signature.trim().isEmpty) {
      emit(state.copyWith(errorCode: 'SIGNATURE_REQUIRED'));
      return;
    }
    if (!state.signature.trim().startsWith('SIG-')) {
      emit(state.copyWith(errorCode: 'SIGNATURE_INVALID_PREFIX'));
      return;
    }
    if (state.selectedPaymentMethod == null) {
      emit(state.copyWith(errorCode: 'PAYMENT_REQUIRED'));
      return;
    }
    if (!state.isConfirmed) {
      emit(state.copyWith(errorCode: 'CONFIRMATION_REQUIRED'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorCode: null));

    try {
      final checkoutUrl = await _acceptOfferUseCase(
        offerId: state.offerId,
        digitalSignature: state.signature.trim(),
        paymentMethod: state.selectedPaymentMethod!,
      );

      if (state.selectedPaymentMethod == PaymentMethod.online) {
        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          emit(state.copyWith(
            status: LoadStatus.success,
            isSubmitting: false,
            checkoutUrl: checkoutUrl,
          ));
        } else {
          // Online payment but no checkout URL — recoverable error
          emit(state.copyWith(
            isSubmitting: false,
            errorCode: AcceptOfferState.paymentConfigMissingError,
          ));
        }
      } else {
        // COD — direct success
        emit(state.copyWith(
          status: LoadStatus.success,
          isSubmitting: false,
        ));
      }
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 409) {
        emit(state.copyWith(
          isSubmitting: false,
          errorCode: AcceptOfferState.terminalStateError,
        ));
      } else if (code == 403) {
        emit(state.copyWith(
          isSubmitting: false,
          errorCode: AcceptOfferState.forbiddenError,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorCode: AcceptOfferState.genericError,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        errorCode: AcceptOfferState.genericError,
      ));
    }
  }
}
