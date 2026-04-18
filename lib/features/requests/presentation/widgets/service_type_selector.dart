import 'package:flutter/material.dart';

import '../../../../core/types/load_status.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/company_details.dart';

class ServiceTypeSelector extends StatelessWidget {
  final LoadStatus servicesLoadStatus;
  final List<CompanyServiceItem> availableServices;
  final List<CompanyServiceItem> selectedServices;
  final String? errorText;
  final ValueChanged<CompanyServiceItem> onToggle;
  final ValueChanged<CompanyServiceItem> onRemove;
  final VoidCallback onRetry;

  const ServiceTypeSelector({
    super.key,
    required this.servicesLoadStatus,
    required this.availableServices,
    required this.selectedServices,
    this.errorText,
    required this.onToggle,
    required this.onRemove,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelector(context, localizations),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.paddingMd,
              top: AppDimensions.spacingXs,
            ),
            child: Text(
              errorText!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        const SizedBox(height: AppDimensions.spacingSm),
        Text(
          localizations.newRequestServiceTypesHelper,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (selectedServices.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          _SelectedChips(selected: selectedServices, onRemove: onRemove),
        ],
      ],
    );
  }

  Widget _buildSelector(BuildContext context, AppLocalizations localizations) {
    if (servicesLoadStatus == LoadStatus.loading) {
      return _buildLoadingField(localizations);
    }

    if (servicesLoadStatus == LoadStatus.error) {
      return _buildErrorState(localizations);
    }

    if (availableServices.isEmpty) {
      return _buildDisabledField(localizations.newRequestNoServicesAvailable);
    }

    final hasSelection = selectedServices.isNotEmpty;
    final displayText = hasSelection
        ? _selectedSummary
        : localizations.newRequestServiceTypesPlaceholder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        onTap: () => _openSelectionSheet(context, localizations),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm + 2,
          ),
          decoration: _fieldDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText,
                  style: AppTypography.bodyMedium.copyWith(
                    color: hasSelection
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: hasSelection
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _fieldDecoration({bool enabled = true}) {
    return BoxDecoration(
      color: enabled ? AppColors.surface : AppColors.buttonSecondary,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      border: Border.all(
        color: errorText != null ? AppColors.error : AppColors.divider,
        width: errorText != null ? 1.4 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.cardShadow.withValues(alpha: enabled ? 0.12 : 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildLoadingField(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm + 2,
      ),
      decoration: _fieldDecoration(enabled: false),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.brandRed.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              localizations.newRequestServiceTypesPlaceholder,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm + 2,
      ),
      decoration: _fieldDecoration(enabled: false),
      child: Text(
        text,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            localizations.newRequestServicesLoadFailed,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          TextButton(
            onPressed: onRetry,
            child: Text(localizations.offersRetry),
          ),
        ],
      ),
    );
  }

  String get _selectedSummary {
    if (selectedServices.length == 1) {
      return selectedServices.first.name;
    }
    return '${selectedServices.first.name} +${selectedServices.length - 1}';
  }

  Future<void> _openSelectionSheet(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
    final selectedNames = await _showServiceTypesBottomSheet(
      context,
      localizations,
    );
    if (selectedNames == null) return;

    final previousSelection = selectedServices.map((s) => s.name).toSet();

    for (final service in availableServices) {
      final wasSelected = previousSelection.contains(service.name);
      final isSelected = selectedNames.contains(service.name);
      if (wasSelected != isSelected) {
        onToggle(service);
      }
    }
  }

  Future<Set<String>?> _showServiceTypesBottomSheet(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final tempSelection = selectedServices.map((s) => s.name).toSet();

    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              child: FractionallySizedBox(
                heightFactor: 0.78,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.borderRadiusXl),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow.withValues(alpha: 0.22),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.paddingLg,
                      AppDimensions.spacingSm,
                      AppDimensions.paddingLg,
                      AppDimensions.paddingLg,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusRound,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                localizations.newRequestServiceTypesPlaceholder,
                                style: AppTypography.heading3,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        Expanded(
                          child: ListView.separated(
                            itemCount: availableServices.length,
                            separatorBuilder: (context, _) =>
                                const SizedBox(height: AppDimensions.spacingSm),
                            itemBuilder: (context, index) {
                              final service = availableServices[index];
                              final isSelected = tempSelection.contains(
                                service.name,
                              );

                              return _ServiceSelectionTile(
                                label: service.name,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      tempSelection.remove(service.name);
                                    } else {
                                      tempSelection.add(service.name);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SizedBox(
                          width: double.infinity,
                          height: AppDimensions.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.of(context).pop(tempSelection),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary,
                              foregroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMd,
                                ),
                              ),
                            ),
                            child: Text(
                              localizations.newRequestServiceTypesDone,
                              style: AppTypography.buttonLabel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SelectedChips extends StatelessWidget {
  final List<CompanyServiceItem> selected;
  final ValueChanged<CompanyServiceItem> onRemove;

  const _SelectedChips({required this.selected, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingXs,
      children: selected.map((service) {
        return InputChip(
          avatar: Icon(
            Icons.check_rounded,
            size: 16,
            color: AppColors.brandRed.withValues(alpha: 0.8),
          ),
          label: Text(
            service.name,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.brandRed,
              fontWeight: FontWeight.w600,
            ),
          ),
          deleteIcon: const Icon(Icons.close_rounded, size: 16),
          onDeleted: () => onRemove(service),
          deleteIconColor: AppColors.brandRed,
          backgroundColor: AppColors.brandRed.withValues(alpha: 0.08),
          side: BorderSide(color: AppColors.brandRed.withValues(alpha: 0.24)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusRound,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ServiceSelectionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceSelectionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.brandRed.withValues(alpha: 0.08)
                : AppColors.background,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
            border: Border.all(
              color: isSelected
                  ? AppColors.brandRed.withValues(alpha: 0.45)
                  : AppColors.divider,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyLarge.copyWith(
                    color: isSelected
                        ? AppColors.brandRed
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 20,
                color: isSelected
                    ? AppColors.brandRed
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
