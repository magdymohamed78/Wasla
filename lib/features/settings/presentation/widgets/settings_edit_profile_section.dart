import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_state.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import 'settings_tile.dart';

class SettingsEditProfileSection extends StatelessWidget {
  const SettingsEditProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsTile(
          icon: Icons.person_outline_rounded,
          title: localizations.settingsEditProfileTitle,
          subtitle: localizations.settingsEditProfileSubtitle,
          onTap: () => _navigateToProfile(context, state.role),
        );
      },
    );
  }

  void _navigateToProfile(BuildContext context, SessionRole role) {
    if (role == SessionRole.lead) {
      context.go(AppRouter.leadProfile);
    } else {
      context.go(AppRouter.customerProfile);
    }
  }
}
