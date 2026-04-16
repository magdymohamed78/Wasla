import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileAvatarHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String roleLabel;

  const ProfileAvatarHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.roleLabel,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = buildFullName(firstName: firstName, lastName: lastName);
    final initials = buildInitials(firstName: firstName, lastName: lastName);

    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brandRed, Color(0xFFC70039)],
            ),
            border: Border.all(color: AppColors.surface, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandRed.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: AppTypography.heading1.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(
          fullName,
          style: AppTypography.heading3.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Text(
          roleLabel,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class EditProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const EditProfileButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit, size: 14, color: AppColors.surface),
      label: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandRed,
        foregroundColor: AppColors.surface,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        minimumSize: const Size(0, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
        ),
      ),
    );
  }
}

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // ignore: use_null_aware_elements
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.brandRed),
            const SizedBox(width: AppDimensions.spacingSm),
          ],
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const ProfileEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.brandRed.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.domain_outlined,
              size: 48,
              color: AppColors.brandRed,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.heading3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

String buildFullName({required String? firstName, required String? lastName}) {
  final first = _capitalizeWords(firstName ?? '');
  final last = _capitalizeWords(lastName ?? '');
  final value = '$first $last'.trim();
  return value.isEmpty ? '-' : value;
}

String buildInitials({required String? firstName, required String? lastName}) {
  final first = (firstName ?? '').trim();
  final last = (lastName ?? '').trim();

  if (first.isNotEmpty && last.isNotEmpty) {
    return '${first[0].toUpperCase()}${last[0].toUpperCase()}';
  }
  if (first.isNotEmpty) {
    return first[0].toUpperCase();
  }
  if (last.isNotEmpty) {
    return last[0].toUpperCase();
  }

  return '?';
}

String _capitalizeWords(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return '';
  }

  return trimmed
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) {
        final first = word.substring(0, 1).toUpperCase();
        final rest = word.length > 1 ? word.substring(1).toLowerCase() : '';
        return '$first$rest';
      })
      .join(' ');
}
