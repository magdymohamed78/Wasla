import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Brand-red circle that drops from the top of the screen with an ease-out
/// fall and a subtle elastic settle. A soft red glow gives the disc depth.
class AnimatedLogoCircle extends StatelessWidget {
  final Animation<double> animation;
  final double size;

  const AnimatedLogoCircle({
    super.key,
    required this.animation,
    this.size = 148,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Start safely above the viewport so the disc is invisible at t=0.
    final dropDistance = (screenHeight / 2) + size;

    // Two-phase drop:
    //   1) Fall from above to a tiny overshoot below center (ease-out).
    //   2) Settle to center with a subtle elastic recoil.
    final dropProgress = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -1.0, end: 0.06)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.06, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(animation);

    final fade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, dropDistance * dropProgress.value),
          child: Opacity(
            opacity: fade.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.brandRed,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.brandRed.withValues(alpha: 0.28),
              blurRadius: 32,
              spreadRadius: 2,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: AppColors.brandRed.withValues(alpha: 0.18),
              blurRadius: 64,
              spreadRadius: 0,
              offset: Offset.zero,
            ),
          ],
        ),
      ),
    );
  }
}
