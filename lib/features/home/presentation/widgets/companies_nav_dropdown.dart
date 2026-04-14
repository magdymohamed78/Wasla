import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';

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

    const menuWidth = 224.0;
    const horizontalMargin = 12.0;
    const bottomOffset = 84.0;

    final itemWidth = screenSize.width / navigationItemCount;
    final anchorCenterX = itemWidth * (companiesItemIndex + 0.5);
    final unclampedLeft = anchorCenterX - (menuWidth / 2);
    final maxLeft = screenSize.width - menuWidth - horizontalMargin;
    final left = unclampedLeft.clamp(horizontalMargin, maxLeft);
    final right = screenSize.width - left - menuWidth;
    final top = screenSize.height - viewPadding.bottom - bottomOffset;

    return showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: AppRouter.allCompanies,
          child: _MenuLabel(
            icon: Icons.list_alt_rounded,
            label: localizations.navigationAllCompanies,
          ),
        ),
        PopupMenuItem<String>(
          value: AppRouter.recommendedCompanies,
          child: _MenuLabel(
            icon: Icons.thumb_up_alt_outlined,
            label: localizations.navigationRecommended,
          ),
        ),
        PopupMenuItem<String>(
          value: AppRouter.trendingCompanies,
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
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
      ],
    );
  }
}
