import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class CompaniesNavDropdown {
  const CompaniesNavDropdown._();

  static Future<String?> show({
    required BuildContext context,
    required AppLocalizations localizations,
    required int navigationItemCount,
    int companiesItemIndex = 0,
  }) {
    final screenSize = MediaQuery.sizeOf(context);
    final viewPadding = MediaQuery.paddingOf(context);
    final textDirection = Directionality.of(context);

    const menuWidth = 260.0;
    const horizontalMargin = 8.0;
    const navigationBarHeight = 100.0;
    const menuToIconGap = 8.0;

    // We perfectly calculate the exact dynamic height of the menu:
    // 3 items * 44px + 16px (8px vertical top/bottom material padding)
    const exactMenuHeight = (3 * 44.0) + 16.0;

    final itemWidth = screenSize.width / navigationItemCount;
    final visualItemIndex = textDirection == TextDirection.rtl
        ? (navigationItemCount - 1 - companiesItemIndex)
        : companiesItemIndex;
    final anchorCenterX = itemWidth * (visualItemIndex + 0.5);
    final unclampedLeft = anchorCenterX - (menuWidth / 2);
    final maxLeft = screenSize.width - menuWidth - horizontalMargin;
    final left = unclampedLeft.clamp(horizontalMargin, maxLeft);

    // Calculate top-left so the menu's bottom sits precisely above the nav bar
    final anchorY =
        (screenSize.height -
                viewPadding.bottom -
                navigationBarHeight -
                exactMenuHeight -
                menuToIconGap)
            .clamp(0.0, screenSize.height - 1);

    final anchorRect = Rect.fromLTWH(left, anchorY, menuWidth, 0);
    final overlayRect = Offset.zero & screenSize;

    return showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(anchorRect, overlayRect),
      color: AppColors.surface,
      elevation: 8,
      shadowColor: AppColors.cardShadow,
      clipBehavior: Clip.antiAlias,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
      ),
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 240),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: AppRouter.allCompanies,
          height: 44,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
          ),
          child: _MenuLabel(
            icon: Icons.list_alt_rounded,
            label: localizations.navigationAllCompanies,
          ),
        ),
        PopupMenuItem<String>(
          value: AppRouter.recommendedCompanies,
          height: 44,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
          ),
          child: _MenuLabel(
            icon: Icons.star_border_purple500_rounded,
            label: localizations.navigationRecommended,
          ),
        ),
        PopupMenuItem<String>(
          value: AppRouter.trendingCompanies,
          height: 44,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
          ),
          child: _MenuLabel(
            icon: Icons.trending_up_rounded,
            label: localizations.navigationTrending,
          ),
        ),
      ],
    );
  }
}

class _MenuLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingXs),
            decoration: BoxDecoration(
              color: AppColors.brandRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconSizeMd,
              color: AppColors.brandRed,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
