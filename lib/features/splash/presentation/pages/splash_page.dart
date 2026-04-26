import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../widgets/animated_logo_circle.dart';
import '../widgets/animated_w_letter.dart';
import '../widgets/animated_asla_text.dart';

/// Premium WASLA splash screen.
///
/// Sequence (≈ 2.5 s total):
///   1. 0.00 – 0.30  Brand-red circle drops from above and settles (ease-out
///                   + subtle elasticOut).
///   2. 0.30 – 0.55  The letter "W" is drawn inside the circle as a single
///                   continuous signature stroke.
///   3. 0.55 – 0.80  "ASLA" slides in from the right and fades up.
///   4. 0.80 – 1.00  The whole logo eases into its final scale (0.97 → 1.00)
///                   and holds briefly before navigation.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const Duration _totalDuration = Duration(milliseconds: 2500);

  late final AnimationController _controller;
  late final Animation<double> _circleAnimation;
  late final Animation<double> _wDrawAnimation;
  late final Animation<double> _aslaAnimation;
  late final Animation<double> _stabilizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _totalDuration, vsync: this);

    _circleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.30, curve: Curves.linear),
    );
    _wDrawAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.55, curve: Curves.easeInOut),
    );
    _aslaAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.80, curve: Curves.easeInOut),
    );
    _stabilizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.80, 1.00, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SplashCubit>()
        ..checkAuthStatus()
        ..startAnimation();
    });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        context.read<SplashCubit>().onAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    // Responsive sizing — tuned for phones and tablets without overflowing.
    final circleSize = shortest * 0.36 < 120
        ? 120.0
        : (shortest * 0.36 > 168 ? 168.0 : shortest * 0.36);
    final wSize = circleSize * 0.62;
    final aslaFontSize = circleSize * 0.42;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) => current.readyToNavigate,
        listener: (context, state) => context.go(state.destination),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final scale = 0.97 + 0.03 * _stabilizeAnimation.value;
              return Transform.scale(
                scale: scale,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedLogoCircle(
                              animation: _circleAnimation,
                              size: circleSize,
                            ),
                            AnimatedWLetter(
                              animation: _wDrawAnimation,
                              size: wSize,
                            ),
                          ],
                        ),
                        SizedBox(width: circleSize * 0.06),
                        AnimatedAslaText(
                          animation: _aslaAnimation,
                          fontSize: aslaFontSize,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
