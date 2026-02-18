import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';

class LoadingDots extends StatefulWidget {
  final Animation<double> animation;

  const LoadingDots({
    super.key,
    required this.animation,
  });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final start = index * 0.15;
            final end = start + 0.6;
            final value = _controller.value;
            final opacity = _calculateOpacity(value, start, end);
            final scale = _calculateScale(value, start, end);
            return Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: AppDimensions.spacingSm),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: AppDimensions.iconSizeSm,
                    height: AppDimensions.iconSizeSm,
                    decoration: const BoxDecoration(
                      color: AppColors.brandRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _calculateOpacity(double value, double start, double end) {
    if (value < start) return 0.0;
    if (value > end) return 0.0;
    return ((value - start) / (end - start)).clamp(0.0, 1.0);
  }

  double _calculateScale(double value, double start, double end) {
    if (value < start) return 0.5;
    if (value > end) return 0.5;
    return 0.5 + (((value - start) / (end - start)) * 0.5).clamp(0.0, 0.5);
  }
}
