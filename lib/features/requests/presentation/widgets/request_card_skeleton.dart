import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class RequestCardSkeleton extends StatelessWidget {
  final int count;

  const RequestCardSkeleton({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
        ),
        itemCount: count,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimensions.spacingSm),
        itemBuilder: (context, index) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: AppColors.divider),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: AppDimensions.logoSizeSmall,
                          height: AppDimensions.logoSizeSmall,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusSm,
                            ),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingSm,
                      ),
                      child: Divider(height: 1),
                    ),
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Row(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingMd),
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
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
