import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/register_use_case.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;

  RegisterCubit({
    required RegisterUseCase registerUseCase,
    required AuthRepository authRepository,
  })  : _registerUseCase = registerUseCase,
        _authRepository = authRepository,
        super(const RegisterState());

  void firstNameChanged(String firstName) {
    emit(state.copyWith(
      firstName: firstName,
      firstNameError: state.hasSubmitted ? _validateName(firstName) : null,
      status: RegisterStatus.initial,
      errorCode: null,
      errorCategory: null,
      serverErrorMessage: null,
    ));
  }

  void lastNameChanged(String lastName) {
    emit(state.copyWith(
      lastName: lastName,
      lastNameError: state.hasSubmitted ? _validateName(lastName) : null,
      status: RegisterStatus.initial,
      errorCode: null,
      errorCategory: null,
      serverErrorMessage: null,
    ));
  }

  void phoneChanged(String phoneNumber) {
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      phoneError: state.hasSubmitted ? _validatePhone(phoneNumber) : null,
      status: RegisterStatus.initial,
      errorCode: null,
      errorCategory: null,
      serverErrorMessage: null,
    ));
  }

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      emailError: state.hasSubmitted ? _validateEmail(email) : null,
      status: RegisterStatus.initial,
      errorCode: null,
      errorCategory: null,
      serverErrorMessage: null,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      passwordError: state.hasSubmitted ? _validatePassword(password) : null,
      confirmPasswordError: state.hasSubmitted && state.confirmPassword.isNotEmpty
          ? _validateConfirmPassword(state.confirmPassword, password)
          : null,
      status: RegisterStatus.initial,
      errorCode: null,
      errorCategory: null,
      serverErrorMessage: null,
    ));
  }

  void confirmPasswordChanged(String confirmPassword) {
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      confirmPasswordError: state.hasSubmitted
          ? _validateConfirmPassword(confirmPassword, state.password)
          : null,
      status: RegisterStatus.initial,
      errorCode: null,
      errorCategory: null,
      serverErrorMessage: null,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  Future<void> register() async {
    emit(state.copyWith(hasSubmitted: true));

    final firstNameError = _validateName(state.firstName);
    final lastNameError = _validateName(state.lastName);
    final phoneError = _validatePhone(state.phoneNumber);
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);
    final confirmPasswordError = _validateConfirmPassword(state.confirmPassword, state.password);

    if (firstNameError != null ||
        lastNameError != null ||
        phoneError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      emit(state.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
        phoneError: phoneError,
        emailError: emailError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      ));
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      final normalizedEmail = _normalizeInput(state.email);
      final normalizedPassword = _normalizeInput(state.password);
      final normalizedFirstName = _normalizeInput(state.firstName);
      final normalizedLastName = _normalizeInput(state.lastName);
      final normalizedPhone = state.phoneNumber.trim().isEmpty
          ? null
          : _normalizeInput(state.phoneNumber);

      final user = await _registerUseCase(
        email: normalizedEmail,
        password: normalizedPassword,
        firstName: normalizedFirstName,
        lastName: normalizedLastName,
        phoneNumber: normalizedPhone,
      );

      await _authRepository.saveSession(user, rememberMe: false);

      final signature = user.digitalSignature;
      if (signature == null || signature.isEmpty) {
        emit(state.copyWith(
          status: RegisterStatus.failure,
          errorCode: RegisterErrorCode.missingSignature,
          errorCategory: RegisterErrorCategory.server,
        ));
        return;
      }

      emit(state.copyWith(
        status: RegisterStatus.success,
        user: user,
        digitalSignature: signature,
      ));
    } on DioException catch (e) {
      final errorResult = _extractErrorCode(e);
      _logError('DioException during register', e);
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorCode: errorResult.code,
        errorCategory: errorResult.category,
        serverErrorMessage: errorResult.message,
      ));
    } catch (e, stackTrace) {
      _logError('Unexpected error during register', e, stackTrace);
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorCode: RegisterErrorCode.unexpectedError,
        errorCategory: RegisterErrorCategory.server,
      ));
    }
  }

  String? _validateName(String name) {
    return Validators.validateName(name);
  }

  String? _validatePhone(String phone) {
    return Validators.validatePhone(phone);
  }

  String? _validateEmail(String email) {
    return Validators.validateEmail(email);
  }

  String? _validatePassword(String password) {
    return Validators.validatePasswordLength(password);
  }

  String? _validateConfirmPassword(String confirmPassword, String password) {
    if (confirmPassword.isEmpty) return 'confirm_password_empty';
    if (confirmPassword != password) return 'confirm_password_mismatch';
    return null;
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

  ({RegisterErrorCode code, RegisterErrorCategory category, String? message}) _extractErrorCode(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;
      String? serverMessage;

      if (responseData is Map<String, dynamic>) {
        serverMessage = responseData['message'] as String?;
      }

      switch (statusCode) {
        case 200:
        case 201:
          return (
            code: RegisterErrorCode.serverError,
            category: RegisterErrorCategory.server,
            message: null,
          );
        case 400:
          if (serverMessage != null && serverMessage.toLowerCase().contains('email')) {
            return (
              code: RegisterErrorCode.validationError,
              category: RegisterErrorCategory.field,
              message: serverMessage,
            );
          }
          return (
            code: RegisterErrorCode.validationError,
            category: RegisterErrorCategory.field,
            message: serverMessage,
          );
        case 409:
          return (
            code: RegisterErrorCode.emailAlreadyRegistered,
            category: RegisterErrorCategory.field,
            message: null,
          );
        case 500:
        case 502:
        case 503:
          return (
            code: RegisterErrorCode.serverError,
            category: RegisterErrorCategory.server,
            message: null,
          );
        default:
          return (
            code: RegisterErrorCode.unexpectedError,
            category: RegisterErrorCategory.server,
            message: serverMessage,
          );
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return (
          code: RegisterErrorCode.networkError,
          category: RegisterErrorCategory.network,
          message: null,
        );
      case DioExceptionType.badResponse:
        return (
          code: RegisterErrorCode.serverError,
          category: RegisterErrorCategory.server,
          message: null,
        );
      case DioExceptionType.cancel:
        return (
          code: RegisterErrorCode.serverError,
          category: RegisterErrorCategory.server,
          message: null,
        );
      case DioExceptionType.unknown:
        final errorStr = e.error?.toString() ?? '';
        if (errorStr.contains('SocketException') ||
            errorStr.contains('Connection refused') ||
            errorStr.contains('Network is unreachable')) {
          return (
            code: RegisterErrorCode.networkError,
            category: RegisterErrorCategory.network,
            message: null,
          );
        }
        return (
          code: RegisterErrorCode.unexpectedError,
          category: RegisterErrorCategory.server,
          message: null,
        );
      default:
        return (
          code: RegisterErrorCode.unexpectedError,
          category: RegisterErrorCategory.server,
          message: null,
        );
    }
  }

  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[RegisterCubit] ERROR: $message');
    debugPrint('[RegisterCubit] Error: $error');
    if (stackTrace != null) {
      debugPrint('[RegisterCubit] StackTrace: $stackTrace');
    }
    debugPrint('════════════════════════════════════════════════════');
  }
}
