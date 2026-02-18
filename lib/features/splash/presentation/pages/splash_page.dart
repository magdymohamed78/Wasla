import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../cubit/splash_cubit.dart';
import '../widgets/animated_logo_circle.dart';
import '../widgets/animated_w_letter.dart';
import '../widgets/animated_asla_text.dart';
import '../widgets/loading_dots.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleDropAnimation;
  late Animation<double> _wFadeAnimation;
  late Animation<double> _logoSlideAnimation;
  late Animation<double> _aslaSlideAnimation;
  late Animation<double> _dotsVisibilityAnimation;
  late Animation<double> _dotsAnimation;

  static const double _logoSlideDistance = 50.0;
  static const double _aslaSpacing = 50.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5200),
      vsync: this,
    );

    _circleDropAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.154, curve: Curves.bounceOut),
      ),
    );

    _wFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.154, 0.231, curve: Curves.easeIn),
      ),
    );

    _logoSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.231, 0.327, curve: Curves.easeOutCubic),
      ),
    );

    _aslaSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.327, 0.423, curve: Curves.easeOutCubic),
      ),
    );

    _dotsVisibilityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.423, 0.442, curve: Curves.easeIn),
      ),
    );

    _dotsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.442, 1.0, curve: Curves.linear),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          context.go('/onboarding');
        }
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
    return BlocProvider(
      create: (_) => SplashCubit()..startAnimation(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(-10* _logoSlideAnimation.value, 0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedLogoCircle(animation: _circleDropAnimation),
                              AnimatedWLetter(animation: _wFadeAnimation),
                            ],
                          ),
                        ),
                        SizedBox(width:  _aslaSlideAnimation.value),
                        AnimatedAslaText(animation: _aslaSlideAnimation),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),
                  Opacity(
                    opacity: _dotsVisibilityAnimation.value,
                    child: LoadingDots(animation: _dotsAnimation),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
