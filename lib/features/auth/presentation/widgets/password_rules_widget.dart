import 'package:flutter/material.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import 'password_feedback_models.dart';

class PasswordRulesWidget extends StatelessWidget {
  final String password;
  final bool hasFocus;

  const PasswordRulesWidget({
    super.key,
    required this.password,
    required this.hasFocus,
  });

  PasswordRuleState _getRuleState(bool isMet) {
    if (password.isEmpty) return PasswordRuleState.neutral;
    if (isMet) return PasswordRuleState.valid;
    return PasswordRuleState.invalid;
  }

  Color _getStateColor(PasswordRuleState state) {
    switch (state) {
      case PasswordRuleState.neutral:
        return AppColors.textSecondary;
      case PasswordRuleState.valid:
        return Colors.green;
      case PasswordRuleState.invalid:
        return AppColors.error;
    }
  }

  IconData _getStateIcon(PasswordRuleState state) {
    switch (state) {
      case PasswordRuleState.neutral:
        return Icons.circle_outlined;
      case PasswordRuleState.valid:
        return Icons.check_circle;
      case PasswordRuleState.invalid:
        return Icons.cancel;
    }
  }

  Widget _buildRuleItem(String text, PasswordRuleState state) {
    final color = _getStateColor(state);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_getStateIcon(state), size: 16, color: color),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final hasMinLength = Validators.hasMinLength(password);
    final hasNumber = Validators.hasNumber(password);
    final hasUppercase = Validators.hasUppercase(password);
    final hasSpecialChar = Validators.hasSpecialChar(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRuleItem(loc.passwordRuleMinLength, _getRuleState(hasMinLength)),
        _buildRuleItem(loc.passwordRuleUppercase, _getRuleState(hasUppercase)),
        _buildRuleItem(loc.passwordRuleNumber, _getRuleState(hasNumber)),
        _buildRuleItem(loc.passwordRuleSpecial, _getRuleState(hasSpecialChar)),
      ],
    );
  }
}
