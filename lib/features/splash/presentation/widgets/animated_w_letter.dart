import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Draws the letter "W" inside the brand circle as a single continuous
/// signature stroke. The path is revealed progressively (0..1) using
/// `PathMetric.extractPath`, giving a premium "hand-drawn" feel.
class AnimatedWLetter extends StatelessWidget {
  final Animation<double> animation;
  final double size;

  const AnimatedWLetter({
    super.key,
    required this.animation,
    this.size = 92,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return CustomPaint(
          size: Size(size, size),
          painter: _WStrokePainter(
            progress: animation.value.clamp(0.0, 1.0),
            color: AppColors.surface,
            strokeWidth: size * 0.14,
          ),
        );
      },
    );
  }
}

class _WStrokePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _WStrokePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final w = size.width;
    final h = size.height;

    // Single continuous path that traces a W:
    //   top-left → bottom-left → top-middle → bottom-right → top-right
    final path = Path()
      ..moveTo(w * 0.16, h * 0.22)
      ..lineTo(w * 0.34, h * 0.78)
      ..lineTo(w * 0.50, h * 0.42)
      ..lineTo(w * 0.66, h * 0.78)
      ..lineTo(w * 0.84, h * 0.22);

    final metrics = path.computeMetrics().toList();
    final totalLength = metrics.fold<double>(0, (sum, m) => sum + m.length);
    final targetLength = totalLength * progress;

    final extracted = Path();
    var covered = 0.0;
    for (final metric in metrics) {
      if (covered >= targetLength) break;
      final remaining = targetLength - covered;
      final segLength = remaining < metric.length ? remaining : metric.length;
      extracted.addPath(metric.extractPath(0, segLength), Offset.zero);
      covered += segLength;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(extracted, paint);
  }

  @override
  bool shouldRepaint(covariant _WStrokePainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
