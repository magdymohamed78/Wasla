import 'package:flutter/material.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:flutter_password_strength_meter/password_strength_checker.dart';
import 'password_strength_mapper.dart';
import 'password_feedback_models.dart';
import 'password_rules_widget.dart';

class PasswordFeedbackSection extends StatelessWidget {
  final String password;
  final bool hasFocus;

  const PasswordFeedbackSection({
    super.key,
    required this.password,
    required this.hasFocus,
  });

  Widget _buildPasswordStrength(AppLocalizations localizations) {
    if (password.isEmpty) return const SizedBox.shrink();

    final checker = PasswordStrengthChecker(
      password,
      const {'weak': '', 'fair': '', 'good': '', 'strong': ''},
      const {'length': '', 'uppercase': '', 'number': '', 'special': '', 'sequence': ''},
    );
    final strengthInfo = checker.checkStrength();
    final double strengthRaw = strengthInfo['strength'] as double? ?? 0.0;
    
    final strengthState = PasswordStrengthMapper.getStrengthState(strengthRaw, password);
    final color = PasswordStrengthMapper.getStrengthColor(strengthState);
    
    String label = '';
    if (strengthState == PasswordStrengthState.weak) label = localizations.passwordStrengthWeak;
    if (strengthState == PasswordStrengthState.medium) label = localizations.passwordStrengthMedium;
    if (strengthState == PasswordStrengthState.strong) label = localizations.passwordStrengthStrong;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: strengthRaw,
            backgroundColor: AppColors.divider,
            color: color,
            minHeight: 4,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (strengthState == PasswordStrengthState.weak) ...[
            const SizedBox(height: 2),
            Text(
              localizations.passwordStrengthHelperFeedback,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PasswordRulesWidget(
          password: password,
          hasFocus: hasFocus,
        ),
        _buildPasswordStrength(localizations),
      ],
    );
  }
}
