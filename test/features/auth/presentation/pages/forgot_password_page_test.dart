import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waslaapp/core/localization/l10n/AppLocalizations.dart';
import 'package:waslaapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:waslaapp/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:waslaapp/features/auth/presentation/pages/forgot_password_page.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ForgotPasswordPage', () {
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      when(
        () => mockAuthRepository.forgotPassword(email: any(named: 'email')),
      ).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      final router = GoRouter(
        initialLocation: '/forgot-password',
        routes: [
          GoRoute(
            path: '/forgot-password',
            builder: (_, _) => const ForgotPasswordPage(),
          ),
          GoRoute(
            path: '/otp-verification',
            builder: (_, _) => const Scaffold(body: Text('OTP Page')),
          ),
          GoRoute(
            path: '/register',
            builder: (_, _) => const Scaffold(body: Text('Register Page')),
          ),
          GoRoute(
            path: '/support',
            builder: (_, _) => const Scaffold(body: Text('Support Page')),
          ),
        ],
      );

      return RepositoryProvider<AuthRepository>.value(
        value: mockAuthRepository,
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
    }

    AppLocalizations localizations(WidgetTester tester) {
      return AppLocalizations.of(
        tester.element(find.byType(ForgotPasswordPage)),
      );
    }

    testWidgets('renders page with all required elements', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Forget Password ?'), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows email field with correct placeholder', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('yourmail@gmail.com'), findsOneWidget);
    });

    testWidgets('send button is disabled initially', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('enables button when valid email is entered', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('calls forgotPassword API when send is clicked', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.pump();

      await tester.ensureVisible(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      verify(
        () => mockAuthRepository.forgotPassword(email: 'test@example.com'),
      ).called(1);
    });

    testWidgets('shows error for invalid email', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final l10n = localizations(tester);

      await tester.enterText(find.byType(TextField), 'invalid-email');
      await tester.pump();

      tester
          .element(find.byType(TextField))
          .read<ForgotPasswordCubit>()
          .emailBlurred();
      await tester.pump();

      expect(find.text(l10n.forgotPasswordEmailInvalid), findsOneWidget);
    });

    testWidgets('shows error for empty email', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final l10n = localizations(tester);

      await tester.enterText(find.byType(TextField), 'test@test.com');
      await tester.pump();

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      tester
          .element(find.byType(TextField))
          .read<ForgotPasswordCubit>()
          .emailBlurred();
      await tester.pump();

      expect(find.text(l10n.forgotPasswordEmailRequired), findsOneWidget);
    });

    testWidgets('sign-up link is always visible on the page', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('sign-up link navigates to register page', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Sign Up'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Register Page'), findsOneWidget);
    });

    testWidgets(
      '403 error shows snackbar with Contact Support action that navigates to support page',
      (tester) async {
        when(
          () => mockAuthRepository.forgotPassword(email: any(named: 'email')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/Auth/forgot-password'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/Auth/forgot-password'),
              statusCode: 403,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'inactive@example.com');
        await tester.pump();

        await tester.ensureVisible(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        expect(find.text('Contact Support'), findsOneWidget);

        await tester.tap(find.text('Contact Support'));
        await tester.pumpAndSettle();

        expect(find.text('Support Page'), findsOneWidget);
      },
    );
  });
}
