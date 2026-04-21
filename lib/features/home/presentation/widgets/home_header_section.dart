import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../../core/theme/app_typography.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionCubit>().state;
    final role = sessionState.role;

    if (role == SessionRole.guest) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context);
    final rawFirstName = sessionState.user?.firstName ?? '';
    final firstName = rawFirstName.toUpperCase();
    final greeting = firstName.isEmpty
        ? localizations.homeGreeting
        : localizations.homeGreetingWithName(firstName);

    return Text(
      greeting,
      style: AppTypography.heading3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
