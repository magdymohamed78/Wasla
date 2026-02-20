import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Home',
          style: AppTypography.heading2,
        ),
      ),
      body: const Center(
        child: Text(
          'Home — Coming Soon',
          style: AppTypography.heading2,
        ),
      ),
    );
  }
}
