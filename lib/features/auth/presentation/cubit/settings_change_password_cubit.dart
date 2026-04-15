import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/use_cases/change_password_use_case.dart';
import 'settings_change_password_state.dart';

class SettingsChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  SettingsChangePasswordCubit({
    required ChangePasswordUseCase changePasswordUseCase,
  }) : _changePasswordUseCase = changePasswordUseCase,
       super(const ChangePasswordState());

  void currentPasswordChanged(String value) {
    final shouldValidate = state.hasSubmitted || state.currentPasswordTouched;
    final currentError = shouldValidate
        ? _validateCurrentPassword(value)
        : null;

    emit(
      state.copyWith(
        currentPassword: value,
        currentPasswordError: currentError,
        clearCurrentPasswordError: !shouldValidate || currentError == null,
        clearGeneralError: true,
      ),
    );
  }

  void newPasswordChanged(String value) {
    final shouldValidateNew = state.hasSubmitted || state.newPasswordTouched;
    final newError = shouldValidateNew
        ? Validators.validatePasswordLength(value)
        : null;

    final shouldValidateConfirm =
        state.hasSubmitted || state.confirmPasswordTouched;
    final confirmError = shouldValidateConfirm
        ? Validators.validatePasswordMatch(value, state.confirmPassword)
        : null;

    emit(
      state.copyWith(
        newPassword: value,
        newPasswordError: newError,
        clearNewPasswordError: !shouldValidateNew || newError == null,
        confirmPasswordError: confirmError,
        clearConfirmPasswordError:
            !shouldValidateConfirm || confirmError == null,
        clearGeneralError: true,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    final shouldValidate = state.hasSubmitted || state.confirmPasswordTouched;
    final confirmError = shouldValidate
        ? Validators.validatePasswordMatch(state.newPassword, value)
        : null;

    emit(
      state.copyWith(
        confirmPassword: value,
        confirmPasswordError: confirmError,
        clearConfirmPasswordError: !shouldValidate || confirmError == null,
        clearGeneralError: true,
      ),
    );
  }

  void currentPasswordBlurred() {
    emit(
      state.copyWith(
        currentPasswordTouched: true,
        currentPasswordError: _validateCurrentPassword(state.currentPassword),
      ),
    );
  }

  void newPasswordBlurred() {
    emit(
      state.copyWith(
        newPasswordTouched: true,
        newPasswordError: Validators.validatePasswordLength(state.newPassword),
      ),
    );
  }

  void confirmPasswordBlurred() {
    emit(
      state.copyWith(
        confirmPasswordTouched: true,
        confirmPasswordError: Validators.validatePasswordMatch(
          state.newPassword,
          state.confirmPassword,
        ),
      ),
    );
  }

  Future<void> submit() async {
    emit(state.copyWith(hasSubmitted: true));

    final currentError = _validateCurrentPassword(state.currentPassword);
    final newError = Validators.validatePasswordLength(state.newPassword);
    final confirmError = Validators.validatePasswordMatch(
      state.newPassword,
      state.confirmPassword,
    );

    if (currentError != null || newError != null || confirmError != null) {
      emit(
        state.copyWith(
          currentPasswordError: currentError,
          newPasswordError: newError,
          confirmPasswordError: confirmError,
          hasSubmitted: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearGeneralError: true,
        hasSubmitted: true,
      ),
    );

    try {
      await _changePasswordUseCase(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
        confirmNewPassword: state.confirmPassword,
      );
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on Exception catch (e) {
      final message = _extractErrorMessage(e);
      emit(state.copyWith(isSubmitting: false, generalError: message));
    }
  }

  String? _validateCurrentPassword(String value) {
    if (value.trim().isEmpty) {
      return 'password_empty';
    }
    return null;
  }

  String _extractErrorMessage(Exception e) {
    final str = e.toString();
    final match = RegExp(r'message:\s*(.+?)\)').firstMatch(str);
    if (match != null) {
      return match.group(1) ?? str;
    }
    return str;
  }
}
