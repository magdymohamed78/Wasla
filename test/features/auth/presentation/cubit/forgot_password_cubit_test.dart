import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waslaapp/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:waslaapp/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:waslaapp/features/auth/presentation/cubit/forgot_password_state.dart';

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

void main() {
  group('ForgotPasswordCubit', () {
    late ForgotPasswordCubit cubit;
    late MockForgotPasswordUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockForgotPasswordUseCase();
      when(() => mockUseCase(email: any(named: 'email')))
          .thenAnswer((_) async {});
      cubit = ForgotPasswordCubit(forgotPasswordUseCase: mockUseCase);
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
      build: () {
        when(() => mockUseCase(email: any(named: 'email')))
            .thenAnswer((_) async {});
        return ForgotPasswordCubit(forgotPasswordUseCase: mockUseCase);
      },
      seed: () => const ForgotPasswordState(
        email: 'test@example.com',
        emailError: null,
      ),
      act: (cubit) => cubit.submit(),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.loading,
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

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'submit emits failure with notFound when API returns 404',
      build: () {
        when(() => mockUseCase(email: any(named: 'email'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/Auth/forgot-password'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/Auth/forgot-password'),
              statusCode: 404,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return ForgotPasswordCubit(forgotPasswordUseCase: mockUseCase);
      },
      seed: () => const ForgotPasswordState(
        email: 'notfound@example.com',
        emailError: null,
      ),
      act: (cubit) => cubit.submit(),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.loading,
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.status, 'status', ForgotPasswordStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'notFound'),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'submit emits failure with inactive when API returns 403',
      build: () {
        when(() => mockUseCase(email: any(named: 'email'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/Auth/forgot-password'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/Auth/forgot-password'),
              statusCode: 403,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return ForgotPasswordCubit(forgotPasswordUseCase: mockUseCase);
      },
      seed: () => const ForgotPasswordState(
        email: 'inactive@example.com',
        emailError: null,
      ),
      act: (cubit) => cubit.submit(),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.loading,
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.status, 'status', ForgotPasswordStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'inactive'),
      ],
    );
  });
}
