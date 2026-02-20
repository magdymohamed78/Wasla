import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/routing/app_router.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Home — Coming Soon',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: AppDimensions.spacingXxl),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                label: 'Logout',
                icon: Icons.logout,
                onPressed: () async {
                  final authRepository = context.read<AuthRepository>();
                  await authRepository.clearSession();
                  if (context.mounted) {
                    context.go(AppRouter.login);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
