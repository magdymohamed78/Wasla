import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AnimatedAslaText extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedAslaText({
    super.key,
    required this.animation,
  });

  static const double _fontSize = 58.0;
  static const double _slideOffset = 100.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideOffset * (1 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: const Text(
        'ASLA',
        style: TextStyle(
          fontFamily: 'Nunito Sans',
          fontSize: _fontSize,
          fontWeight: FontWeight.w800,
          color: AppColors.brandRed,
        ),
      ),
    );
  }
}
