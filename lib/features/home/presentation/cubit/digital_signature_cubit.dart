import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/reveal_signature_use_case.dart';
import 'digital_signature_state.dart';

class DigitalSignatureCubit extends Cubit<DigitalSignatureState> {
  final RevealDigitalSignatureUseCase _revealUseCase;
  Timer? _autoHideTimer;

  DigitalSignatureCubit({required RevealDigitalSignatureUseCase revealUseCase})
    : _revealUseCase = revealUseCase,
      super(const DigitalSignatureState());

  Future<void> revealSignature({required String password}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final signature = await _revealUseCase(password: password);
      emit(
        DigitalSignatureState(
          status: SignatureStatus.revealed,
          signatureText: signature,
          isLoading: false,
        ),
      );
      _startAutoHideTimer();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        final message = _extractErrorMessage(e);
        emit(
          DigitalSignatureState(
            status: SignatureStatus.locked,
            errorMessage: message,
            isLoading: false,
          ),
        );
      } else {
        final message = _extractErrorMessage(e);
        emit(state.copyWith(errorMessage: message, isLoading: false));
      }
    } catch (_) {
      emit(
        state.copyWith(
          errorMessage: 'An unexpected error occurred.',
          isLoading: false,
        ),
      );
    }
  }

  void hideSignature() {
    _autoHideTimer?.cancel();
    _autoHideTimer = null;
    emit(state.clearSignature());
  }

  void _startAutoHideTimer() {
    _autoHideTimer?.cancel();
    _autoHideTimer = Timer(const Duration(seconds: 60), () {
      if (!isClosed) {
        hideSignature();
      }
    });
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['errorMessage'] as String? ??
          e.message ??
          'An error occurred.';
    }
    return e.message ?? 'An error occurred.';
  }

  @override
  Future<void> close() {
    _autoHideTimer?.cancel();
    return super.close();
  }
}
