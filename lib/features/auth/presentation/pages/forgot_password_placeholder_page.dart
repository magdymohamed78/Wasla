import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ForgotPasswordPlaceholderPage extends StatelessWidget {
  const ForgotPasswordPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Forgot Password',
          style: AppTypography.heading2,
        ),
      ),
      body: const Center(
        child: Text(
          'Forgot Password — Coming Soon',
          style: AppTypography.heading2,
        ),
      ),
    );
  }
}
