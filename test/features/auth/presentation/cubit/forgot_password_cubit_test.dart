import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waslaapp/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:waslaapp/features/auth/presentation/cubit/forgot_password_state.dart';

void main() {
  group('ForgotPasswordCubit', () {
    late ForgotPasswordCubit cubit;

    setUp(() {
      cubit = ForgotPasswordCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state.email, '');
      expect(cubit.state.emailError, isNull);
      expect(cubit.state.isSubmitting, false);
      expect(cubit.state.status, ForgotPasswordStatus.initial);
    });

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emailChanged updates email and clears error for valid email',
      build: () => cubit,
      act: (cubit) => cubit.emailChanged('test@example.com'),
      expect: () => [
        isA<ForgotPasswordState>()
            .having((s) => s.email, 'email', 'test@example.com')
            .having((s) => s.emailError, 'emailError', isNull)
            .having((s) => s.isValid, 'isValid', true),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emailChanged sets error for empty email',
      build: () => cubit,
      act: (cubit) => cubit.emailChanged(''),
      expect: () => [
        isA<ForgotPasswordState>()
            .having((s) => s.email, 'email', '')
            .having((s) => s.emailError, 'emailError', 'email_empty')
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emailChanged sets error for invalid email format',
      build: () => cubit,
      act: (cubit) => cubit.emailChanged('invalid-email'),
      expect: () => [
        isA<ForgotPasswordState>()
            .having((s) => s.email, 'email', 'invalid-email')
            .having((s) => s.emailError, 'emailError', 'email_invalid')
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'submit does nothing when email is invalid',
      build: () => cubit,
      act: (cubit) => cubit.submit(),
      expect: () => [],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'submit sets isSubmitting and then success for valid email',
      build: () => cubit,
      seed: () => const ForgotPasswordState(
        email: 'test@example.com',
        emailError: null,
      ),
      act: (cubit) => cubit.submit(),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.isSubmitting,
          'isSubmitting',
          true,
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.status, 'status', ForgotPasswordStatus.success),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'resetAfterToast resets status to initial',
      build: () => cubit,
      seed: () =>
          const ForgotPasswordState(status: ForgotPasswordStatus.success),
      act: (cubit) => cubit.resetAfterToast(),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.initial,
        ),
      ],
    );
  });
}
