import 'package:flutter/material.dart';
import 'password_feedback_models.dart';

class PasswordStrengthMapper {
  static PasswordStrengthState getStrengthState(double score, String password) {
    if (password.isEmpty) return PasswordStrengthState.hidden;
    if (score <= 0.33) return PasswordStrengthState.weak;
    if (score <= 0.66) return PasswordStrengthState.medium;
    return PasswordStrengthState.strong;
  }

  static Color getStrengthColor(PasswordStrengthState state) {
    switch (state) {
      case PasswordStrengthState.hidden:
        return Colors.transparent;
      case PasswordStrengthState.weak:
        return Colors.red; // Or AppColors.error
      case PasswordStrengthState.medium:
        return Colors.orange; // Or AppColors.warning
      case PasswordStrengthState.strong:
        return Colors.green; // Or AppColors.success
    }
  }
}
