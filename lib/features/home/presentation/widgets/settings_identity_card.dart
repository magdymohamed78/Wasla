import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsIdentityCard extends StatelessWidget {
  const SettingsIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingMd,
            horizontal: AppDimensions.paddingSm,
          ),
          child: Row(
            children: [
              _Avatar(initials: state.initials),
              const SizedBox(width: AppDimensions.spacingLg),
              Expanded(
                child: Text(
                  state.fullName,
                  style: AppTypography.heading2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;

  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        image: const DecorationImage(
          image: NetworkImage(
            'https://i.pravatar.cc/150?img=11',
          ), // Placeholder mimicking the image
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      // If image fails or isn't available, we'd show initials, but for matching the UI exactly:
      // child: Text(initials),
    );
  }
}
