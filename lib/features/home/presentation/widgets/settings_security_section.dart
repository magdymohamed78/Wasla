import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../features/auth/domain/use_cases/change_password_use_case.dart';
import '../../../../features/auth/presentation/cubit/settings_change_password_cubit.dart';
import '../cubit/logout_cubit.dart';
import '../cubit/logout_state.dart';
import 'change_password_modal.dart';
import 'logout_confirmation_dialog.dart';
import 'settings_danger_tile.dart';
import 'settings_tile.dart';

class SettingsSecuritySection extends StatelessWidget {
  const SettingsSecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        SettingsTile(
          icon: Icons.lock_outline_rounded,
          title: localizations.settingsChangePasswordTitle,
          onTap: () => _openChangePasswordModal(context),
        ),
        Divider(
          color: AppColors.divider,
          height: 1,
          indent:
              AppDimensions.paddingMd +
              AppDimensions.iconSizeMd +
              AppDimensions.spacingMd,
        ),
        BlocBuilder<LogoutCubit, LogoutState>(
          builder: (context, state) {
            return SettingsTile(
              icon: Icons.phonelink_erase_rounded,
              title: localizations.settingsLogoutAll,
              subtitle: localizations.settingsLogoutAllSubtitle,
              onTap: state.isLoggingOutAll
                  ? null
                  : () => _confirmLogoutAll(context),
              isLoading: state.isLoggingOutAll,
            );
          },
        ),
        Divider(
          color: AppColors.divider,
          height: 1,
          indent:
              AppDimensions.paddingMd +
              AppDimensions.iconSizeMd +
              AppDimensions.spacingMd,
        ),
        BlocBuilder<LogoutCubit, LogoutState>(
          builder: (context, state) {
            return SettingsDangerTile(
              icon: Icons.logout_rounded,
              title: localizations.settingsLogoutCurrent,
              subtitle: localizations.settingsLogoutCurrentSubtitle,
              onTap: state.isLoggingOutCurrent
                  ? null
                  : () async {
                      await context.read<LogoutCubit>().logoutCurrent();
                      if (context.mounted) context.go(AppRouter.login);
                    },
              isLoading: state.isLoggingOutCurrent,
            );
          },
        ),
        const SizedBox(height: AppDimensions.spacingSm),
      ],
    );
  }

  void _openChangePasswordModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<SettingsChangePasswordCubit>(
        create: (_) => SettingsChangePasswordCubit(
          changePasswordUseCase: context.read<ChangePasswordUseCase>(),
        ),
        child: const ChangePasswordModal(),
      ),
    );
  }

  void _confirmLogoutAll(BuildContext context) async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (confirmed == true && context.mounted) {
      context.read<LogoutCubit>().logoutAll().then((_) {
        if (context.mounted) context.go(AppRouter.login);
      });
    }
  }
}
