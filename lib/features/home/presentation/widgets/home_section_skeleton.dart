import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class HomeSectionSkeleton extends StatelessWidget {
  final String title;
  final int itemCount;

  const HomeSectionSkeleton({
    super.key,
    required this.title,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacingSm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(itemCount, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == itemCount - 1 ? 0 : AppDimensions.spacingSm,
                ),
                child: Shimmer.fromColors(
                  baseColor: AppColors.buttonSecondary,
                  highlightColor: AppColors.cardShadow,
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusXl,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.divider,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMd,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: AppColors.divider,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.spacingSm,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.divider,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 10,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: AppColors.divider,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: AppColors.divider,
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        Row(
                          children: [
                            Container(
                              height: 24,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.divider,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusRound,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingXs),
                            Container(
                              height: 24,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.divider,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusRound,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingXs),
                            Container(
                              height: 24,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColors.divider,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusRound,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class HomeSectionInlineError extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const HomeSectionInlineError({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacingSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(localizations.networkErrorRetry),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeSectionEmpty extends StatelessWidget {
  final String title;
  final String message;

  const HomeSectionEmpty({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacingSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
          ),
          child: Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
