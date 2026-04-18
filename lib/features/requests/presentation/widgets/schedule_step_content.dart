import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_date_picker_field.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';

class ScheduleStepContent extends StatelessWidget {
  final DateTime? preferredDate;
  final String preferredTimeSlot;
  final String notes;
  final String? preferredDateError;
  final String? preferredTimeSlotError;
  final ValueChanged<DateTime?> onPreferredDateChanged;
  final ValueChanged<String> onPreferredTimeSlotChanged;
  final ValueChanged<String> onNotesChanged;

  const ScheduleStepContent({
    super.key,
    this.preferredDate,
    required this.preferredTimeSlot,
    required this.notes,
    this.preferredDateError,
    this.preferredTimeSlotError,
    required this.onPreferredDateChanged,
    required this.onPreferredTimeSlotChanged,
    required this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDatePickerField(
                label: localizations.newRequestPreferredDate,
                value: preferredDate,
                onChanged: onPreferredDateChanged,
                errorText: preferredDateError != null
                    ? localizations.newRequestValidationRequired
                    : null,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              AppDropdownField<String>(
                label: localizations.newRequestTimeSlot,
                value: preferredTimeSlot.isEmpty ? null : preferredTimeSlot,
                hint: localizations.newRequestChooseCategory,
                items: [
                  DropdownMenuItem(
                    value: 'morning',
                    child: Text(localizations.newRequestMorning),
                  ),
                  DropdownMenuItem(
                    value: 'afternoon',
                    child: Text(localizations.newRequestAfternoon),
                  ),
                  DropdownMenuItem(
                    value: 'evening',
                    child: Text(localizations.newRequestEvening),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) onPreferredTimeSlotChanged(v);
                },
                errorText: preferredTimeSlotError != null
                    ? localizations.newRequestValidationRequired
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.newRequestNotes,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              AppTextField(
                label: '',
                hintText: localizations.newRequestNotesHint,
                initialValue: notes,
                onChanged: onNotesChanged,
                maxLines: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _InfoBox(message: localizations.newRequestInfoBox),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String message;

  const _InfoBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.brandRed.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(
          color: AppColors.brandRed.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: AppDimensions.iconSizeMd,
            color: AppColors.brandRed.withValues(alpha: 0.7),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
