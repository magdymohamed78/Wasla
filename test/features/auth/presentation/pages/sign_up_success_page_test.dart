import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waslaapp/core/localization/l10n/AppLocalizations.dart';
import 'package:waslaapp/core/widgets/small_primary_button.dart';
import 'package:waslaapp/features/auth/presentation/pages/sign_up_success_page.dart';

void main() {
  group('SignUpSuccessPage', () {
    testWidgets('renders page with all required elements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SignUpSuccessPage(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('You are successfully registered!'), findsOneWidget);
      expect(find.text("Let's Start"), findsOneWidget);
      expect(find.byType(SmallPrimaryButton), findsOneWidget);
    });

    testWidgets('has PopScope with canPop false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SignUpSuccessPage(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PopScope), findsOneWidget);
      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, isFalse);
    });

    testWidgets('CTA button is enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SignUpSuccessPage(),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<SmallPrimaryButton>(find.byType(SmallPrimaryButton));
      expect(button.onPressed, isNotNull);
    });
  });
}
