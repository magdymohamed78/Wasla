import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../features/auth/presentation/cubit/settings_change_password_cubit.dart';
import '../../../../features/auth/presentation/cubit/settings_change_password_state.dart';
import '../../../../features/auth/presentation/widgets/password_rules_widget.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({super.key});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordFocusNode = FocusNode();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _newPasswordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocConsumer<SettingsChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
          ToastUtils.showSuccess(
            context,
            localizations.settingsChangePasswordSuccess,
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor: AppColors.surface,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLg,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.settingsChangePasswordTitle,
                        style: AppTypography.heading3.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(
                    'Ensure your new password meets all security requirements.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  _PasswordField(
                    controller: _currentPasswordController,
                    label: localizations.settingsCurrentPassword,
                    obscure: _obscureCurrent,
                    onToggle: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                    errorText: state.currentPasswordError,
                    onChanged: (v) => context
                        .read<SettingsChangePasswordCubit>()
                        .currentPasswordChanged(v),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _PasswordField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    label: localizations.settingsNewPassword,
                    obscure: _obscureNew,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    errorText: state.newPasswordError,
                    onChanged: (v) => context
                        .read<SettingsChangePasswordCubit>()
                        .newPasswordChanged(v),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  PasswordRulesWidget(
                    password: state.newPassword,
                    hasFocus: _newPasswordFocusNode.hasFocus,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _PasswordField(
                    controller: _confirmPasswordController,
                    label: localizations.settingsConfirmNewPassword,
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    errorText: state.confirmPasswordError,
                    onChanged: (v) => context
                        .read<SettingsChangePasswordCubit>()
                        .confirmPasswordChanged(v),
                  ),
                  if (state.generalError != null) ...[
                    const SizedBox(height: AppDimensions.spacingMd),
                    Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.generalError!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppDimensions.spacingXl),
                  ElevatedButton(
                    onPressed: state.isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandRed,
                      foregroundColor: AppColors.surface,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.surface,
                            ),
                          )
                        : Text(
                            localizations.settingsChangePasswordSubmit,
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.surface,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    context.read<SettingsChangePasswordCubit>().submit();
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _PasswordField({
    required this.controller,
    this.focusNode,
    required this.label,
    required this.obscure,
    required this.onToggle,
    this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          onChanged: onChanged,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMd,
              vertical: 16.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.brandRed,
                width: 1.5,
              ),
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
