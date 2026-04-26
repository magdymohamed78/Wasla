import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// "ASLA" wordmark that slides in from the right while fading in.
class AnimatedAslaText extends StatelessWidget {
  final Animation<double> animation;
  final double fontSize;

  const AnimatedAslaText({
    super.key,
    required this.animation,
    this.fontSize = 60,
  });

  static const double _slideOffset = 64.0;

  @override
  Widget build(BuildContext context) {
    final slide = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );
    final fade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.10, 1.0, curve: Curves.easeIn),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideOffset * (1 - slide.value), 0),
          child: Opacity(
            opacity: fade.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Text(
        'ASLA',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: AppColors.brandRed,
          letterSpacing: -1.5,
          height: 1.0,
        ),
      ),
    );
  }
}
