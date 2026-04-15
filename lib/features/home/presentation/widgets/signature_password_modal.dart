import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/digital_signature_cubit.dart';
import '../cubit/digital_signature_state.dart';

class SignaturePasswordModal extends StatefulWidget {
  const SignaturePasswordModal({super.key});

  @override
  State<SignaturePasswordModal> createState() => _SignaturePasswordModalState();
}

class _SignaturePasswordModalState extends State<SignaturePasswordModal> {
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isSubmitting = false;
  DigitalSignatureCubit? _cubit;
  bool _revealed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<DigitalSignatureCubit>();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    if (!_revealed) {
      _cubit?.hideSignature();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<DigitalSignatureCubit, DigitalSignatureState>(
      listener: (context, state) {
        if (state.status == SignatureStatus.revealed) {
          _revealed = true;
          Navigator.of(context).pop();
          return;
        }

        if (state.status == SignatureStatus.locked &&
            state.errorMessage != null) {
          setState(() => _isSubmitting = false);
          return;
        }

        if (state.errorMessage != null &&
            state.status == SignatureStatus.hidden) {
          setState(() => _isSubmitting = false);
          return;
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.settingsSignaturePasswordTitle,
                    style: AppTypography.heading3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: _isSubmitting
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
                'Please enter your password to reveal your digital signature for 60 seconds.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXl),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                autofocus: true,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: localizations.settingsSignaturePasswordHint,
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: 16.0,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
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
                ),
              ),
              BlocBuilder<DigitalSignatureCubit, DigitalSignatureState>(
                builder: (context, state) {
                  if (state.errorMessage != null &&
                      state.status != SignatureStatus.revealed) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.spacingSm,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: AppDimensions.spacingXl),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandRed,
                  foregroundColor: AppColors.surface,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.surface,
                        ),
                      )
                    : Text(
                        localizations.settingsSignaturePasswordSubmit,
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
  }

  void _submit() {
    final password = _passwordController.text.trim();
    if (password.isEmpty) return;

    setState(() => _isSubmitting = true);
    context.read<DigitalSignatureCubit>().revealSignature(password: password);
  }
}
