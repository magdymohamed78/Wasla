import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/discovery_types.dart';

class ServiceFilterChips extends StatelessWidget {
  final ServiceFilterOption selectedOption;
  final ValueChanged<ServiceFilterOption> onSelected;

  const ServiceFilterChips({
    super.key,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final options = <ServiceFilterOption, String>{
      ServiceFilterOption.allServices: localizations.exploreAllServices,
      ServiceFilterOption.move: localizations.exploreMove,
      ServiceFilterOption.cleaning: localizations.exploreCleaning,
      ServiceFilterOption.disposal: localizations.exploreDisposal,
      ServiceFilterOption.packing: localizations.explorePacking,
      ServiceFilterOption.unpacking: localizations.exploreUnpacking,
      ServiceFilterOption.storage: localizations.exploreStorage,
      ServiceFilterOption.transport: localizations.exploreTransport,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.entries
            .map((entry) {
              final isSelected = entry.key == selectedOption;

              return Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: AppDimensions.spacingSm,
                ),
                child: GestureDetector(
                  onTap: () => onSelected(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSm,
                      vertical: AppDimensions.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brandRed
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusRound,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.brandRed
                            : AppColors.divider,
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.brandRed.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      entry.value,
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.surface
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
