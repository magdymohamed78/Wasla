import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';

class DashboardSectionSkeleton extends StatelessWidget {
  const DashboardSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isTablet = width >= 720;
        final isMedium = width >= 540 && width < 720;
        final crossAxisCount = isTablet ? 4 : (isMedium ? 3 : 2);
        final spacing = isMedium || isTablet
            ? AppDimensions.spacingMd
            : AppDimensions.spacingSm;
        final childAspectRatio = isTablet ? 1.65 : (isMedium ? 1.45 : 1.3);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: AppColors.buttonSecondary,
              highlightColor: AppColors.cardShadow,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusXl,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DashboardSectionInlineError extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const DashboardSectionInlineError({
    super.key,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  message ?? localizations.homeDashboardLoadFailed,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.networkErrorRetry),
            ),
          ),
        ],
      ),
    );
  }
}
