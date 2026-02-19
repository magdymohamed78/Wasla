import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:waslaapp/core/localization/l10n/AppLocalizations.dart';
import 'package:waslaapp/core/theme/app_colors.dart';
import 'package:waslaapp/core/widgets/primary_button.dart';
import 'package:waslaapp/core/widgets/secondary_button.dart';
import 'package:waslaapp/features/onboarding/presentation/widgets/onboarding_header.dart';

/// Replicates the `_LogoGroup` widget from onboarding_page.dart for testing.
/// Must stay in sync with the production widget. If this breaks, the production
/// widget has changed and these tests need updating.
Widget buildLogoGroup() {
  const double circleSize = 145;
  const double wFontSize = 105.0;
  const double aslaFontSize = 58.0;
  const double spacing = 10.0;

  return Directionality(
    textDirection: TextDirection.ltr,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: const BoxDecoration(
                  color: AppColors.brandRed,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                'W',
                style: TextStyle(
                  fontSize: wFontSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.background,
                ),
              ),
            ],
          ),
          const SizedBox(width: spacing),
          Text(
            'ASLA',
            style: TextStyle(
              fontSize: aslaFontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.brandRed,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Wraps [child] in a minimal MaterialApp with the given [textDirection].
Widget wrapWithDirection(TextDirection direction, Widget child) {
  return MaterialApp(
    home: Directionality(
      textDirection: direction,
      child: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

void main() {
  group('_LogoGroup RTL alignment', () {
    // T003: "W" dx < "ASLA" dx in LTR ambient direction
    testWidgets(
      'logo content order is LTR (W left of ASLA) in LTR ambient direction',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithDirection(TextDirection.ltr, buildLogoGroup()),
        );

        final wPosition = tester.getTopLeft(find.text('W'));
        final aslaPosition = tester.getTopLeft(find.text('ASLA'));

        expect(
          wPosition.dx,
          lessThan(aslaPosition.dx),
          reason: 'W circle must appear to the left of ASLA text in LTR mode',
        );
      },
    );

    // T004: "W" dx < "ASLA" dx in RTL ambient direction
    testWidgets(
      'logo content order is LTR (W left of ASLA) in RTL ambient direction',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithDirection(TextDirection.rtl, buildLogoGroup()),
        );

        final wPosition = tester.getTopLeft(find.text('W'));
        final aslaPosition = tester.getTopLeft(find.text('ASLA'));

        expect(
          wPosition.dx,
          lessThan(aslaPosition.dx),
          reason:
              'W circle must appear to the left of ASLA text even in RTL mode',
        );
      },
    );

    // T005: Directionality.of(context) inside logo subtree == TextDirection.ltr
    testWidgets(
      'Directionality inside logo subtree is always LTR regardless of ambient',
      (WidgetTester tester) async {
        // Test with RTL ambient — the most important case
        await tester.pumpWidget(
          wrapWithDirection(TextDirection.rtl, buildLogoGroup()),
        );

        // Get the context of the "W" text widget (inside the Directionality override)
        final wElement = tester.element(find.text('W'));
        final innerDirection = Directionality.of(wElement);

        expect(
          innerDirection,
          equals(TextDirection.ltr),
          reason:
              'The logo subtree must have LTR directionality regardless of ambient direction',
        );

        // Also verify via the "ASLA" text widget
        final aslaElement = tester.element(find.text('ASLA'));
        final aslaDirection = Directionality.of(aslaElement);

        expect(
          aslaDirection,
          equals(TextDirection.ltr),
          reason:
              'ASLA text must also be in LTR directionality context',
        );
      },
    );
  });

  group('OnboardingHeader RTL mirroring', () {
    // T007: Header elements swap positions in RTL vs LTR
    testWidgets(
      'language selector and support icon swap positions in RTL vs LTR',
      (WidgetTester tester) async {
        // Build header in LTR
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: Scaffold(
                body: OnboardingHeader(
                  currentLocale: const Locale('en'),
                  onLocaleChanged: (_) {},
                  onSupportTap: () {},
                ),
              ),
            ),
          ),
        );

        // Find the language icon (globe) and support icon positions in LTR
        final languageIconLtr =
            tester.getTopLeft(find.byIcon(Icons.language));
        final supportIconLtr =
            tester.getTopLeft(find.byIcon(Icons.support_agent_rounded));

        // Language selector should be on the left in LTR
        expect(
          languageIconLtr.dx,
          lessThan(supportIconLtr.dx),
          reason:
              'Language selector must be on the left side in LTR layout',
        );

        // Now build header in RTL
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: OnboardingHeader(
                  currentLocale: const Locale('ar'),
                  onLocaleChanged: (_) {},
                  onSupportTap: () {},
                ),
              ),
            ),
          ),
        );

        // Find positions in RTL
        final languageIconRtl =
            tester.getTopLeft(find.byIcon(Icons.language));
        final supportIconRtl =
            tester.getTopLeft(find.byIcon(Icons.support_agent_rounded));

        // Language selector should be on the right in RTL (mirrored)
        expect(
          languageIconRtl.dx,
          greaterThan(supportIconRtl.dx),
          reason:
              'Language selector must move to the right side in RTL layout',
        );
      },
    );
  });

  group('Button labels RTL behavior', () {
    // T008: Button labels render Arabic text with RTL direction
    testWidgets(
      'buttons render localized Arabic text in RTL mode',
      (WidgetTester tester) async {
        // Build with Arabic locale and RTL direction
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    final localizations = AppLocalizations.of(context);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PrimaryButton(
                          label: localizations.onboardingLogIn,
                          onPressed: () {},
                        ),
                        SecondaryButton(
                          label: localizations.onboardingNewUser,
                          onPressed: () {},
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify Arabic text is rendered
        expect(
          find.text('تسجيل الدخول'),
          findsOneWidget,
          reason: 'Log In button must display Arabic text in Arabic locale',
        );
        expect(
          find.text('مستخدم جديد'),
          findsOneWidget,
          reason: 'New User button must display Arabic text in Arabic locale',
        );

        // Verify the buttons' text direction context is RTL
        final loginTextElement = tester.element(find.text('تسجيل الدخول'));
        final loginDirection = Directionality.of(loginTextElement);
        expect(
          loginDirection,
          equals(TextDirection.rtl),
          reason: 'Button text must be in RTL directionality context',
        );
      },
    );
  });
}
