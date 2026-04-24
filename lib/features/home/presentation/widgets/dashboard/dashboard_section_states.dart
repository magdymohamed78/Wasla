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
        int crossAxisCount;
        if (width >= 1024) {
          crossAxisCount = 4;
        } else if (width >= 720) {
          crossAxisCount = 4;
        } else if (width >= 540) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        final spacing = width >= 540
            ? AppDimensions.spacingMd
            : AppDimensions.spacingSm;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: 140,
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
