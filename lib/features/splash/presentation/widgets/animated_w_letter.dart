import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AnimatedWLetter extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedWLetter({
    super.key,
    required this.animation,
  });

  static const double _fontSize = 105.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
      child: const Text(
        'W',
        style: TextStyle(
          fontFamily: 'Nunito Sans',
          fontSize: _fontSize,
          fontWeight: FontWeight.w800,
          color: AppColors.background,
        ),
      ),
    );
  }
}
