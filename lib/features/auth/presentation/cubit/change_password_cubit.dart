import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ChangePasswordCubit({
    required ResetPasswordUseCase resetPasswordUseCase,
    required String email,
  }) : _resetPasswordUseCase = resetPasswordUseCase,
       super(ChangePasswordState(email: email));

  void otpChanged(String otp) {
    emit(
      state.copyWith(
        otp: otp,
        status: ChangePasswordStatus.initial,
        errorMessage: null,
        serverMessage: null,
        errorType: null,
      ),
    );
  }

  void newPasswordChanged(String value) {
    final error = Validators.validatePasswordLength(value);
    final confirmError = state.confirmPassword.isNotEmpty
        ? Validators.validatePasswordMatch(value, state.confirmPassword)
        : state.confirmPasswordError;

    emit(
      state.copyWith(
        newPassword: value,
        newPasswordError: error,
        confirmPasswordError: confirmError,
        status: ChangePasswordStatus.initial,
        errorMessage: null,
        serverMessage: null,
        errorType: null,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    final error = Validators.validatePasswordMatch(state.newPassword, value);

    emit(
      state.copyWith(
        confirmPassword: value,
        confirmPasswordError: error,
        status: ChangePasswordStatus.initial,
        errorMessage: null,
        serverMessage: null,
        errorType: null,
      ),
    );
  }

  void toggleNewPasswordVisibility() {
    emit(state.copyWith(obscureNewPassword: !state.obscureNewPassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  Future<void> submit() async {
    // Mark as submitted so inline errors show
    emit(state.copyWith(hasSubmitted: true));

    // Validate fields
    final otpError = state.otp.length < 6 ? 'otp_invalid' : null;
    final newPwError = Validators.validatePasswordLength(state.newPassword);
    final confirmPwError = Validators.validatePasswordMatch(
      state.newPassword,
      state.confirmPassword,
    );

    if (newPwError != null || confirmPwError != null || otpError != null) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          newPasswordError: newPwError,
          confirmPasswordError: confirmPwError,
          errorMessage: otpError != null ? 'otpInvalid' : null,
          errorType: otpError != null ? ChangePasswordErrorType.otpInvalid : null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ChangePasswordStatus.loading,
        errorMessage: null,
        serverMessage: null,
        errorType: null,
      ),
    );

    try {
      await _resetPasswordUseCase(
        email: state.email,
        otp: state.otp,
        newPassword: state.newPassword,
        confirmNewPassword: state.confirmPassword,
      );

      emit(state.copyWith(status: ChangePasswordStatus.success));
    } on DioException catch (e) {
      _logError('DioException during reset password', e);
      _handleDioError(e);
    } catch (e, stackTrace) {
      _logError('Unexpected error during reset password', e, stackTrace);
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: 'server',
          errorType: ChangePasswordErrorType.server,
        ),
      );
    }
  }

  void _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;

      if (statusCode == 429) {
        emit(
          state.copyWith(
            status: ChangePasswordStatus.failure,
            errorMessage: 'rateLimit',
            errorType: ChangePasswordErrorType.rateLimit,
          ),
        );
        return;
      }

      if (statusCode == 400) {
        final serverMsg = _extractServerMessage(e.response!.data);
        final combined  = serverMsg.toLowerCase();

        // Permanently invalidated after 5 failed attempts → redirect to forgot-password.
        // Only trigger this navigation when we are very confident.
        if (combined.contains('permanently') || combined.contains('invalidated')) {
          emit(
            state.copyWith(
              status: ChangePasswordStatus.failure,
              serverMessage: serverMsg.isNotEmpty ? serverMsg : null,
              errorMessage: serverMsg.isEmpty ? 'otpExpired' : null,
              errorType: ChangePasswordErrorType.otpExpired,
            ),
          );
          return;
        }

        // Password policy — only classify as such when the server explicitly says so.
        if (combined.contains('password') &&
            (combined.contains('policy') ||
                combined.contains('minimum') ||
                combined.contains('requirement') ||
                combined.contains('uppercase') ||
                combined.contains('lowercase') ||
                combined.contains('digit') ||
                combined.contains('special'))) {
          emit(
            state.copyWith(
              status: ChangePasswordStatus.failure,
              serverMessage: serverMsg.isNotEmpty ? serverMsg : null,
              errorMessage: serverMsg.isEmpty ? 'passwordPolicy' : null,
              errorType: ChangePasswordErrorType.passwordPolicy,
            ),
          );
          return;
        }

        // Everything else (wrong OTP, expired OTP, unknown 400) → otpInvalid.
        // The password is already validated client-side, so any remaining 400
        // from this endpoint is most likely an OTP issue.
        emit(
          state.copyWith(
            status: ChangePasswordStatus.failure,
            serverMessage: serverMsg.isNotEmpty ? serverMsg : null,
            errorMessage: serverMsg.isEmpty ? 'otpInvalid' : null,
            errorType: ChangePasswordErrorType.otpInvalid,
          ),
        );
        return;
      }
    }

    // Network / timeout errors
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        emit(
          state.copyWith(
            status: ChangePasswordStatus.failure,
            errorMessage: 'network',
            errorType: ChangePasswordErrorType.network,
          ),
        );
        return;
      case DioExceptionType.unknown:
        final errorStr = e.error?.toString() ?? '';
        if (errorStr.contains('SocketException') ||
            errorStr.contains('Connection refused') ||
            errorStr.contains('Network is unreachable')) {
          emit(
            state.copyWith(
              status: ChangePasswordStatus.failure,
              errorMessage: 'network',
              errorType: ChangePasswordErrorType.network,
            ),
          );
          return;
        }
        break;
      default:
        break;
    }

    emit(
      state.copyWith(
        status: ChangePasswordStatus.failure,
        errorMessage: 'server',
        errorType: ChangePasswordErrorType.server,
      ),
    );
  }

  /// Extracts a human-readable error string from an ASP.NET Core response body.
  ///
  /// Handles all common formats returned by the API:
  ///   • ProblemDetails Map  → `detail`, then `title`
  ///   • Validation errors   → first message inside `errors` map
  ///   • Plain String body   → returned as-is
  ///   • Anything else       → empty string (caller will use a localised fallback)
  String _extractServerMessage(dynamic data) {
    if (data == null) return '';

    // Plain string body
    if (data is String) {
      final trimmed = data.trim();
      // Ignore raw HTML error pages
      if (trimmed.startsWith('<')) return '';
      return trimmed;
    }

    if (data is Map) {
      // Standard ProblemDetails: prefer 'detail' (specific), then 'title' (generic)
      final detail = (data['detail'] ?? '').toString().trim();
      if (detail.isNotEmpty) return detail;

      final title = (data['title'] ?? '').toString().trim();
      if (title.isNotEmpty) return title;

      // ASP.NET Core validation errors: { "errors": { "Field": ["msg1"] } }
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString().trim();
        }
        return firstValue.toString().trim();
      }

      // Catch-all: any top-level 'message' field
      final message = (data['message'] ?? '').toString().trim();
      if (message.isNotEmpty) return message;
    }

    return '';
  }

  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[ChangePasswordCubit] ERROR: $message');
    debugPrint('[ChangePasswordCubit] Error: $error');
    if (stackTrace != null) {
      debugPrint('[ChangePasswordCubit] StackTrace: $stackTrace');
    }
    debugPrint('════════════════════════════════════════════════════');
  }
}
