import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';

class NewServiceRequestForm extends StatelessWidget {
  final int companyId;
  final String serviceType;
  final String fromStreet;
  final String fromCity;
  final String fromZipCode;
  final String fromCountry;
  final String toStreet;
  final String toCity;
  final String toZipCode;
  final String toCountry;
  final DateTime? preferredDate;
  final String preferredTimeSlot;
  final String notes;
  final String submitLabel;
  final String preferredDateLabel;
  final String pickDateLabel;
  final String clearDateLabel;
  final String? errorMessage;
  final bool isSubmitting;
  final ValueChanged<String> onServiceTypeChanged;
  final ValueChanged<String> onFromStreetChanged;
  final ValueChanged<String> onFromCityChanged;
  final ValueChanged<String> onFromZipCodeChanged;
  final ValueChanged<String> onFromCountryChanged;
  final ValueChanged<String> onToStreetChanged;
  final ValueChanged<String> onToCityChanged;
  final ValueChanged<String> onToZipCodeChanged;
  final ValueChanged<String> onToCountryChanged;
  final VoidCallback onPickPreferredDate;
  final VoidCallback onClearPreferredDate;
  final ValueChanged<String> onPreferredTimeSlotChanged;
  final ValueChanged<String> onNotesChanged;
  final VoidCallback onSubmit;

  const NewServiceRequestForm({
    super.key,
    required this.companyId,
    required this.serviceType,
    required this.fromStreet,
    required this.fromCity,
    required this.fromZipCode,
    required this.fromCountry,
    required this.toStreet,
    required this.toCity,
    required this.toZipCode,
    required this.toCountry,
    required this.preferredDate,
    required this.preferredTimeSlot,
    required this.notes,
    required this.submitLabel,
    required this.preferredDateLabel,
    required this.pickDateLabel,
    required this.clearDateLabel,
    required this.errorMessage,
    required this.isSubmitting,
    required this.onServiceTypeChanged,
    required this.onFromStreetChanged,
    required this.onFromCityChanged,
    required this.onFromZipCodeChanged,
    required this.onFromCountryChanged,
    required this.onToStreetChanged,
    required this.onToCityChanged,
    required this.onToZipCodeChanged,
    required this.onToCountryChanged,
    required this.onPickPreferredDate,
    required this.onClearPreferredDate,
    required this.onPreferredTimeSlotChanged,
    required this.onNotesChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company ID: $companyId', style: AppTypography.bodyMedium),
              const SizedBox(height: AppDimensions.spacingMd),
              _FormTextField(
                label: 'Service type *',
                initialValue: serviceType,
                onChanged: onServiceTypeChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'Preferred time slot',
                initialValue: preferredTimeSlot,
                onChanged: onPreferredTimeSlotChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                preferredDateLabel,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isSubmitting ? null : onPickPreferredDate,
                      icon: const Icon(Icons.calendar_month_rounded),
                      label: Text(pickDateLabel),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  TextButton(
                    onPressed: isSubmitting || preferredDate == null
                        ? null
                        : onClearPreferredDate,
                    child: Text(clearDateLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From', style: AppTypography.bodyLarge),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'Street',
                initialValue: fromStreet,
                onChanged: onFromStreetChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'City',
                initialValue: fromCity,
                onChanged: onFromCityChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'Zip code',
                initialValue: fromZipCode,
                onChanged: onFromZipCodeChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'Country',
                initialValue: fromCountry,
                onChanged: onFromCountryChanged,
                enabled: !isSubmitting,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('To', style: AppTypography.bodyLarge),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'Street',
                initialValue: toStreet,
                onChanged: onToStreetChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'City',
                initialValue: toCity,
                onChanged: onToCityChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'Zip code',
                initialValue: toZipCode,
                onChanged: onToZipCodeChanged,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _FormTextField(
                label: 'Country',
                initialValue: toCountry,
                onChanged: onToCountryChanged,
                enabled: !isSubmitting,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _sectionCard(
          child: _FormTextField(
            label: 'Notes',
            initialValue: notes,
            onChanged: onNotesChanged,
            enabled: !isSubmitting,
            minLines: 3,
            maxLines: 5,
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          _sectionCard(
            child: Text(
              errorMessage!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
        if (isSubmitting) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          const LinearProgressIndicator(),
        ],
        const SizedBox(height: AppDimensions.spacingMd),
        PrimaryButton(
          label: submitLabel,
          onPressed: isSubmitting ? null : onSubmit,
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FormTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final int minLines;
  final int maxLines;

  const _FormTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.enabled,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      initialValue: initialValue,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }
}
