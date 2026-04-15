import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
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

    return Row(
      children: [
        Expanded(
          child: Text(
            greeting,
            style: AppTypography.heading3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (role == SessionRole.customer) ...[
          const SizedBox(width: AppDimensions.spacingMd),
          _NotificationBellButton(
            onTap: () => context.push(AppRouter.notifications),
          ),
        ],
      ],
    );
  }
}

class _NotificationBellButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NotificationBellButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.iconSizeXl,
        height: AppDimensions.iconSizeXl,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.notifications_none_rounded,
          color: AppColors.brandRed,
          size: AppDimensions.iconSizeMd,
        ),
      ),
    );
  }
}
