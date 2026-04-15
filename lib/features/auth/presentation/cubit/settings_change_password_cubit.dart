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
    emit(
      state.copyWith(
        currentPassword: value,
        clearCurrentPasswordError: true,
        clearGeneralError: true,
      ),
    );
  }

  void newPasswordChanged(String value) {
    emit(
      state.copyWith(
        newPassword: value,
        clearNewPasswordError: true,
        clearGeneralError: true,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: value,
        clearConfirmPasswordError: true,
        clearGeneralError: true,
      ),
    );
  }

  Future<void> submit() async {
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
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearGeneralError: true));

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
