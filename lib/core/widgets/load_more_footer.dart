import 'package:flutter/material.dart';

import '../../../core/localization/l10n/AppLocalizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class LoadMoreFooter extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final VoidCallback onLoadMore;
  final String? noMoreItemsLabel;

  const LoadMoreFooter({
    super.key,
    required this.isLoadingMore,
    required this.hasReachedEnd,
    required this.onLoadMore,
    this.noMoreItemsLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (hasReachedEnd) {
      if (noMoreItemsLabel != null && noMoreItemsLabel!.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingMd,
          ),
          child: Center(
            child: Text(
              noMoreItemsLabel!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingMd,
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.brandRed,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingMd,
      ),
      child: Center(
        child: TextButton(
          onPressed: onLoadMore,
          child: Text(
            AppLocalizations.of(context).loadMoreButton,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.brandRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}