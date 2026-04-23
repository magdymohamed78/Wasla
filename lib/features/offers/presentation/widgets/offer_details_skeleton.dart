import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Shimmer loading placeholder matching the offer details layout structure.
class OfferDetailsSkeleton extends StatelessWidget {
  const OfferDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge + chips
            Row(
              children: [
                _Box(width: 80, height: 24),
                const SizedBox(width: 8),
                _Box(width: 60, height: 24),
              ],
            ),
            const SizedBox(height: 16),
            // Total card
            _Box(width: double.infinity, height: 90),
            const SizedBox(height: 12),
            // Savings card
            _Box(width: double.infinity, height: 60),
            const SizedBox(height: 20),
            // Locations section title
            _Box(width: 120, height: 20),
            const SizedBox(height: 8),
            _Box(width: double.infinity, height: 100),
            const SizedBox(height: 8),
            _Box(width: double.infinity, height: 100),
            const SizedBox(height: 20),
            // Services section title
            _Box(width: 100, height: 20),
            const SizedBox(height: 8),
            _Box(width: double.infinity, height: 130),
            const SizedBox(height: 20),
            // Insurance
            _Box(width: double.infinity, height: 50),
            const SizedBox(height: 12),
            // Attachment
            _Box(width: double.infinity, height: 60),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width;
  final double height;

  const _Box({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
    );
  }
}
