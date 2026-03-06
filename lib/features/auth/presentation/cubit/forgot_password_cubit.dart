import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/use_cases/forgot_password_use_case.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit({
    required ForgotPasswordUseCase forgotPasswordUseCase,
  })  : _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const ForgotPasswordState());

  void emailChanged(String value) {
    final error = Validators.validateEmail(value);
    emit(
      state.copyWith(
        email: value,
        emailError: error,
        status: ForgotPasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> submit() async {
    if (!state.isValid) return;

    emit(state.copyWith(
      status: ForgotPasswordStatus.loading,
      isSubmitting: true,
      errorMessage: null,
    ));

    try {
      final normalizedEmail = _normalizeInput(state.email);
      await _forgotPasswordUseCase(email: normalizedEmail);

      emit(state.copyWith(
        isSubmitting: false,
        status: ForgotPasswordStatus.success,
      ));
    } on DioException catch (e) {
      _logError('DioException during forgot password', e);
      final errorMsg = _mapDioError(e);
      emit(state.copyWith(
        isSubmitting: false,
        status: ForgotPasswordStatus.failure,
        errorMessage: errorMsg,
      ));
    } catch (e, stackTrace) {
      _logError('Unexpected error during forgot password', e, stackTrace);
      emit(state.copyWith(
        isSubmitting: false,
        status: ForgotPasswordStatus.failure,
        errorMessage: 'server',
      ));
    }
  }

  void resetAfterToast() {
    emit(state.copyWith(
      status: ForgotPasswordStatus.initial,
      errorMessage: null,
    ));
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

  String _normalizeInput(String input) {
    String normalized = input.trim();

    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const westernDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicDigits.length; i++) {
      normalized = normalized.replaceAll(arabicDigits[i], westernDigits[i]);
    }

    normalized = normalized.replaceAll('\u200E', '');
    normalized = normalized.replaceAll('\u200F', '');
    normalized = normalized.replaceAll('\u202A', '');
    normalized = normalized.replaceAll('\u202B', '');
    normalized = normalized.replaceAll('\u202C', '');
    normalized = normalized.replaceAll('\u202D', '');
    normalized = normalized.replaceAll('\u202E', '');
    normalized = normalized.replaceAll('\u061C', '');

    return normalized;
  }

  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[ForgotPasswordCubit] ERROR: $message');
    debugPrint('[ForgotPasswordCubit] Error: $error');
    if (stackTrace != null) {
      debugPrint('[ForgotPasswordCubit] StackTrace: $stackTrace');
    }
    debugPrint('════════════════════════════════════════════════════');
  }
}
