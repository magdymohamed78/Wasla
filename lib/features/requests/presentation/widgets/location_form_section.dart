import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/new_service_request_cubit.dart';

class LocationFormSection extends StatelessWidget {
  final String title;
  final bool isPickup;
  final String street;
  final String city;
  final String zipCode;
  final String country;
  final String streetKey;
  final String cityKey;
  final String zipCodeKey;
  final String countryKey;
  final Map<String, String?> fieldErrors;
  final Set<String> touchedFields;
  final void Function(String key, String value) onFieldChanged;
  final void Function(String key) onFieldBlurred;

  const LocationFormSection({
    super.key,
    required this.title,
    this.isPickup = true,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.country,
    required this.streetKey,
    required this.cityKey,
    required this.zipCodeKey,
    required this.countryKey,
    required this.fieldErrors,
    required this.touchedFields,
    required this.onFieldChanged,
    required this.onFieldBlurred,
  });

  String? _resolveError(String key, AppLocalizations localizations) {
    if (!touchedFields.contains(key)) return null;
    final error = fieldErrors[key];
    if (error == null) return null;

    switch (error) {
      case NewServiceRequestCubit.fieldStreetRequired:
        return localizations.newRequestValidationStreetRequired;
      case NewServiceRequestCubit.fieldCityRequired:
        return localizations.newRequestValidationCityRequired;
      case NewServiceRequestCubit.fieldCityInvalid:
        return localizations.newRequestValidationCityInvalid;
      case NewServiceRequestCubit.fieldCountryRequired:
        return localizations.newRequestValidationCountryRequired;
      case NewServiceRequestCubit.fieldRequired:
        return localizations.newRequestValidationRequired;
      default:
        return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPickup ? Icons.location_on : Icons.flag_outlined,
                size: AppDimensions.iconSizeMd - 2,
                color: isPickup ? AppColors.brandRed : AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          AppTextField(
            label: localizations.newRequestStreetLabel,
            initialValue: street,
            hintText: localizations.newRequestStreetPlaceholder,
            isRequired: true,
            reserveErrorSpace: true,
            onChanged: (v) => onFieldChanged(streetKey, v),
            onBlur: () => onFieldBlurred(streetKey),
            errorText: _resolveError(streetKey, localizations),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppTextField(
                  label: localizations.newRequestCityLabel,
                  initialValue: city,
                  hintText: localizations.newRequestCityPlaceholder,
                  isRequired: true,
                  reserveErrorSpace: true,
                  onChanged: (v) => onFieldChanged(cityKey, v),
                  onBlur: () => onFieldBlurred(cityKey),
                  errorText: _resolveError(cityKey, localizations),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: AppTextField(
                  label: localizations.newRequestZipCodeLabel,
                  initialValue: zipCode,
                  hintText: localizations.newRequestZipCodePlaceholder,
                  reserveErrorSpace: true,
                  onChanged: (v) => onFieldChanged(zipCodeKey, v),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          AppTextField(
            label: localizations.newRequestCountryLabel,
            initialValue: country,
            hintText: localizations.newRequestCountryPlaceholder,
            isRequired: true,
            reserveErrorSpace: true,
            onChanged: (v) => onFieldChanged(countryKey, v),
            onBlur: () => onFieldBlurred(countryKey),
            errorText: _resolveError(countryKey, localizations),
          ),
        ],
      ),
    );
  }
}
