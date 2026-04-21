import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../home/domain/use_cases/logout_all_use_case.dart';
import '../../../home/domain/use_cases/logout_use_case.dart';
import '../../../home/domain/use_cases/reveal_signature_use_case.dart';
import '../cubit/digital_signature_cubit.dart';
import '../cubit/logout_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_identity_card.dart';
import '../widgets/settings_skeleton.dart';
import '../widgets/settings_edit_profile_section.dart';
import '../widgets/settings_security_section.dart';
import '../widgets/settings_signature_section.dart';
import '../widgets/settings_language_section.dart';
import '../widgets/settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(localizations.navigationSettings),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SettingsPageSkeleton();
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.spacingSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingsIdentityCard(),
                  const SizedBox(height: AppDimensions.spacingLg),
                  SettingsSection(
                    label: localizations.settingsSectionAccountManagement,
                    child: const SettingsEditProfileSection(),
                  ),
                  Builder(
                    builder: (context) {
                      final role = context.watch<SessionCubit>().state.role;
                      if (role == SessionRole.guest) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          const SizedBox(height: AppDimensions.spacingLg),
                          SettingsSection(
                            label:
                                localizations.settingsSectionDigitalSignature,
                            child: BlocProvider<DigitalSignatureCubit>(
                              create: (_) => DigitalSignatureCubit(
                                revealUseCase: context
                                    .read<RevealDigitalSignatureUseCase>(),
                              ),
                              child: const SettingsSignatureSection(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  SettingsSection(
                    label: localizations.settingsSectionSecurity,
                    child: BlocProvider<LogoutCubit>(
                      create: (_) => LogoutCubit(
                        logoutUseCase: context.read<LogoutUseCase>(),
                        logoutAllUseCase: context.read<LogoutAllUseCase>(),
                        sessionCubit: context.read<SessionCubit>(),
                      ),
                      child: const SettingsSecuritySection(),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  SettingsSection(
                    label: localizations.settingsSectionPreferences,
                    child: const SettingsLanguageSection(),
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
