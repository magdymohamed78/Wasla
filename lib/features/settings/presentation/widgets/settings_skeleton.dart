import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class SettingsPageSkeleton extends StatelessWidget {
  const SettingsPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.spacingSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SkeletonIdentityCard(),
              SizedBox(height: AppDimensions.spacingLg),
              _SkeletonSection(rowCount: 1, hasIcon: true, hasTrailing: true),
              SizedBox(height: AppDimensions.spacingLg),
              _SkeletonSection(rowCount: 3, hasIcon: true, hasTrailing: false),
              SizedBox(height: AppDimensions.spacingLg),
              _SkeletonSection(rowCount: 2, hasIcon: true, hasTrailing: false),
              SizedBox(height: AppDimensions.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonIdentityCard extends StatelessWidget {
  const _SkeletonIdentityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        child: Row(
          children: [
            Container(width: 4, height: 80, color: AppColors.brandRed),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                  vertical: AppDimensions.paddingSm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.divider,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 16,
                            width: 120,
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 14,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusRound,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonSection extends StatelessWidget {
  final int rowCount;
  final bool hasIcon;
  final bool hasTrailing;

  const _SkeletonSection({
    required this.rowCount,
    required this.hasIcon,
    required this.hasTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.spacingSm,
            right: AppDimensions.spacingSm,
            bottom: AppDimensions.spacingSm,
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 11,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: List.generate(rowCount, (index) {
              return Column(
                children: [
                  _SkeletonTileRow(hasIcon: hasIcon, hasTrailing: hasTrailing),
                  if (index < rowCount - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMd,
                      ),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SkeletonTileRow extends StatelessWidget {
  final bool hasIcon;
  final bool hasTrailing;

  const _SkeletonTileRow({required this.hasIcon, required this.hasTrailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      child: Row(
        children: [
          if (hasIcon) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMd,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          if (hasTrailing)
            Container(
              height: 14,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
