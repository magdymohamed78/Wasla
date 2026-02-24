import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/small_primary_button.dart';
import '../../../../core/widgets/wasla_logo.dart';

class SignUpSuccessPage extends StatelessWidget {
  const SignUpSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const WaslaLogo(size: AppDimensions.logoSizeMedium),
                            Text(
                              'ASLA',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: AppColors.brandRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXxl),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingLg,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cardShadow,
                                  blurRadius: 60,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: AppDimensions.spacingLg),

                                Image.asset(
                                  'assets/images/Start.png',
                                  height: 230,
                                  width: 305,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: AppDimensions.spacingLg),
                                Text(
                                  localizations.signUpSuccessMessage,
                                  style: AppTypography.heading3.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: AppDimensions.spacingXxl,
                                ),
                                SmallPrimaryButton(
                                  label: localizations.signUpSuccessButton,
                                  icon: Icons.arrow_forward_rounded,
                                  onPressed: () => context.go(AppRouter.login),
                                ),
                                const SizedBox(height: AppDimensions.spacingXl),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXxl),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
