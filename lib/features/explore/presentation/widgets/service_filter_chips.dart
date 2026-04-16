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
                child: ChoiceChip(
                  selected: isSelected,
                  label: Text(entry.value),
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: AppColors.brandRed,
                  backgroundColor: AppColors.buttonSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusRound,
                    ),
                    side: isSelected
                        ? const BorderSide(
                            color: AppColors.brandRed,
                            width: 1.5,
                          )
                        : const BorderSide(color: Colors.transparent),
                  ),
                  onSelected: (_) => onSelected(entry.key),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
