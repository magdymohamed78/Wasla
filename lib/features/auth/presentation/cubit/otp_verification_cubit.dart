import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/resend_otp_use_case.dart';
import 'otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  final ResendOtpUseCase _resendOtpUseCase;
  Timer? _timer;

  OtpVerificationCubit({
    required ResendOtpUseCase resendOtpUseCase,
  })  : _resendOtpUseCase = resendOtpUseCase,
        super(const OtpVerificationState());

  void init(String email) {
    emit(state.copyWith(email: email));
    _startTimer();
  }

  void digitEntered(int index, String value) {
    if (index < 0 || index > 5) return;
    final normalizedValue = _normalizeDigit(value);
    final digits = List<String>.from(state.otpDigits);
    digits[index] = normalizedValue;
    final otp = digits.join();
    emit(state.copyWith(
      otpDigits: digits,
      otp: otp,
      status: OtpVerificationStatus.initial,
      errorMessage: null,
    ));
  }

  void digitRemoved(int index) {
    if (index < 0 || index > 5) return;
    final digits = List<String>.from(state.otpDigits);
    digits[index] = '';
    final otp = digits.join();
    emit(state.copyWith(
      otpDigits: digits,
      otp: otp,
      status: OtpVerificationStatus.initial,
      errorMessage: null,
    ));
  }

  void pasteOtp(String pastedText) {
    final normalized = _normalizeDigits(pastedText);
    final cleaned = normalized.replaceAll(RegExp(r'[^0-9]'), '');
    final digits = List<String>.generate(6, (i) {
      return i < cleaned.length ? cleaned[i] : '';
    });
    final otp = digits.join();
    emit(state.copyWith(
      otpDigits: digits,
      otp: otp,
      status: OtpVerificationStatus.initial,
      errorMessage: null,
    ));
  }

  void verify() {
    if (!state.isComplete) return;

    final otp = state.otpDigits.join();
    emit(state.copyWith(
      otp: otp,
      status: OtpVerificationStatus.success,
    ));
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;

    emit(state.copyWith(isResending: true, errorMessage: null));

    try {
      await _resendOtpUseCase(email: state.email);

      emit(state.copyWith(
        isResending: false,
        timerRemainingSeconds: 60,
        status: OtpVerificationStatus.initial,
      ));
      _startTimer();
    } on DioException catch (e) {
      _logError('DioException during resend OTP', e);
      final errorMsg = _mapDioError(e);
      emit(state.copyWith(
        isResending: false,
        status: OtpVerificationStatus.failure,
        errorMessage: errorMsg,
        timerRemainingSeconds: 60,
      ));
      _startTimer();
    } catch (e, stackTrace) {
      _logError('Unexpected error during resend OTP', e, stackTrace);
      emit(state.copyWith(
        isResending: false,
        status: OtpVerificationStatus.failure,
        errorMessage: 'server',
        timerRemainingSeconds: 60,
      ));
      _startTimer();
    }
  }

  String _normalizeDigit(String input) {
    return _normalizeDigits(input);
  }

  String _normalizeDigits(String input) {
    String normalized = input;
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const westernDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < arabicDigits.length; i++) {
      normalized = normalized.replaceAll(arabicDigits[i], westernDigits[i]);
    }
    return normalized;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.timerRemainingSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(timerRemainingSeconds: 0));
      } else {
        emit(state.copyWith(timerRemainingSeconds: remaining));
      }
    });
  }

  String _mapDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      if (statusCode == 429) return 'rateLimit';
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'network';
      case DioExceptionType.unknown:
        final errorStr = e.error?.toString() ?? '';
        if (errorStr.contains('SocketException') ||
            errorStr.contains('Connection refused') ||
            errorStr.contains('Network is unreachable')) {
          return 'network';
        }
        return 'server';
      default:
        return 'server';
    }
  }

  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[OtpVerificationCubit] ERROR: $message');
    debugPrint('[OtpVerificationCubit] Error: $error');
    if (stackTrace != null) {
      debugPrint('[OtpVerificationCubit] StackTrace: $stackTrace');
    }
    debugPrint('════════════════════════════════════════════════════');
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
