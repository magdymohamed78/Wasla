import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProfilePageSkeleton extends StatelessWidget {
  const ProfilePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: const [
          _SkeletonAvatarHeader(),
          SizedBox(height: AppDimensions.spacingMd),
          _SkeletonSectionCard(hasIcon: true, hasTrailing: true, rowCount: 4),
          SizedBox(height: AppDimensions.spacingMd),
          _SkeletonSectionCard(hasIcon: true, hasTrailing: false, rowCount: 3),
          SizedBox(height: AppDimensions.spacingMd),
          _SkeletonSectionCard(
            hasIcon: true,
            hasTrailing: false,
            rowCount: 0,
            child: _SkeletonCompanyCards(),
          ),
          SizedBox(height: AppDimensions.spacingLg),
        ],
      ),
    );
  }
}

class _SkeletonAvatarHeader extends StatelessWidget {
  const _SkeletonAvatarHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: AppColors.divider,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Container(
          width: 160,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Container(
          width: 80,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusRound,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkeletonSectionCard extends StatelessWidget {
  final bool hasIcon;
  final bool hasTrailing;
  final int rowCount;
  final Widget? child;

  const _SkeletonSectionCard({
    required this.hasIcon,
    required this.hasTrailing,
    required this.rowCount,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (hasIcon) ...[
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
              ],
              Expanded(
                child: Container(
                  height: 18,
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              if (hasTrailing) ...[
                const SizedBox(width: AppDimensions.spacingSm),
                Container(
                  height: 32,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusRound,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (rowCount > 0 || child != null)
            const SizedBox(height: AppDimensions.spacingMd),
          for (int i = 0; i < rowCount; i++) ...[
            if (i > 0) const Divider(color: AppColors.divider),
            const _SkeletonInfoRow(),
          ],
          // ignore: use_null_aware_elements
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _SkeletonInfoRow extends StatelessWidget {
  const _SkeletonInfoRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Container(
            height: 12,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Spacer(),
          Container(
            height: 14,
            width: 100,
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

class _SkeletonCompanyCards extends StatelessWidget {
  const _SkeletonCompanyCards();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SkeletonCompanyCard(),
        SizedBox(height: AppDimensions.spacingSm),
        _SkeletonCompanyCard(),
      ],
    );
  }
}

class _SkeletonCompanyCard extends StatelessWidget {
  const _SkeletonCompanyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimensions.logoSizeSmall,
            height: AppDimensions.logoSizeSmall,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}
