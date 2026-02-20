import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class WaslaLogo extends StatelessWidget {
  final double size;

  const WaslaLogo({
    super.key,
    this.size = AppDimensions.logoSizeMedium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.brandRed,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'W',
          style: TextStyle(
            color: AppColors.background,
            fontSize: size *0.8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
