import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/localization/locale_cubit/locale_cubit.dart';
import '../../../../core/localization/locale_cubit/locale_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/routing/app_router.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_header.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          switch (state.navigation) {
            case OnboardingNavigation.navigateToLogin:
              context.push(AppRouter.login);
              context.read<OnboardingCubit>().resetNavigation();
              break;
            case OnboardingNavigation.navigateToRegister:
              context.push(AppRouter.register);
              context.read<OnboardingCubit>().resetNavigation();
              break;
            case OnboardingNavigation.navigateToSupport:
              context.push(AppRouter.support);
              context.read<OnboardingCubit>().resetNavigation();
              break;
            case OnboardingNavigation.idle:
              break;
          }
        },
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            final localizations = AppLocalizations.of(context);
            
            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Column(
                  children: [
                    OnboardingHeader(
                      currentLocale: localeState.locale,
                      onLocaleChanged: (locale) {
                        context.read<LocaleCubit>().changeLocale(locale);
                      },
                      onSupportTap: () {
                        context.read<OnboardingCubit>().goToSupport();
                      },
                    ),
                    const SizedBox(height: 120),
                       Center(
                        child: _LogoGroup(),
                      ),
                    const SizedBox(height: AppDimensions.spacingXxl),
                    Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: AppDimensions.paddingLg,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton(
                            label: localizations.onboardingLogIn,
                            onPressed: () {
                              context.read<OnboardingCubit>().goToLogin();
                            },
                          ),
                          const SizedBox(height: AppDimensions.spacingMd),
                          SecondaryButton(
                            label: localizations.onboardingNewUser,
                            onPressed: () {
                              context.read<OnboardingCubit>().goToRegister();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXl),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Displays the Wasla brand logo group: red circle with "W" followed by "ASLA".
///
/// This widget is wrapped in [Directionality] with [TextDirection.ltr] to
/// ensure the internal content order (circle "W" → "ASLA") never mirrors
/// when the app switches to an RTL language (e.g. Arabic). Brand elements
/// must remain visually fixed regardless of locale direction.
///
/// The parent [Center] widget keeps the group horizontally centered on screen,
/// and [FittedBox] scales it down proportionally on smaller devices.
class _LogoGroup extends StatelessWidget {
  const _LogoGroup();

  static const double _circleSize = 145;
  static const double _wFontSize = 105.0;
  static const double _aslaFontSize = 58.0;
  static const double _spacing = 10.0;

  @override
  Widget build(BuildContext context) {
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
                  width: _circleSize,
                  height: _circleSize,
                  decoration: const BoxDecoration(
                    color: AppColors.brandRed,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  'W',
                  style: TextStyle(
                    fontSize: _wFontSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.background,
                  ),
                ),
              ],
            ),
            const SizedBox(width: _spacing),
            Text(
              'ASLA',
              style: TextStyle(
                fontSize: _aslaFontSize,
                fontWeight: FontWeight.w800,
                color: AppColors.brandRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
