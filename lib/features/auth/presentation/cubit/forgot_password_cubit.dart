import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void emailChanged(String value) {
    final error = Validators.validateEmail(value);
    emit(
      state.copyWith(
        email: value,
        emailError: error,
        status: ForgotPasswordStatus.initial,
      ),
    );
  }

  Future<void> submit() async {
    if (!state.isValid) return;

    emit(state.copyWith(isSubmitting: true));

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      state.copyWith(isSubmitting: false, status: ForgotPasswordStatus.success),
    );
  }

  void resetAfterToast() {
    emit(state.copyWith(status: ForgotPasswordStatus.initial));
  }
}
