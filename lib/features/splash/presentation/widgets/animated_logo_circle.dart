import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AnimatedLogoCircle extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedLogoCircle({
    super.key,
    required this.animation,
  });

  static const double _circleSize = 145;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final startOffset = -screenHeight / 2 - _circleSize;
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, startOffset * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        width: _circleSize,
        height: _circleSize,
        decoration: const BoxDecoration(
          color: AppColors.brandRed,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
