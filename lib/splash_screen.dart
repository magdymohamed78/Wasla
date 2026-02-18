import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _slashController;
  late AnimationController _wController;
  late AnimationController _textController;
  late AnimationController _dotController;

  late Animation<double> _circleAnimation;
  late Animation<double> _slashAnimation;
  late Animation<double> _wAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _dotAnimation;

  @override
  void initState() {
    super.initState();

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _circleAnimation = CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeOutBack,
    );

    _slashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _slashAnimation = CurvedAnimation(
      parent: _slashController,
      curve: Curves.easeOut,
    );

    _wController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _wAnimation = CurvedAnimation(parent: _wController, curve: Curves.easeOut);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _dotAnimation = CurvedAnimation(
      parent: _dotController,
      curve: Curves.easeOut,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _circleController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _slashController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _wController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _dotController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _circleController.dispose();
    _slashController.dispose();
    _wController.dispose();
    _textController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _circleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _circleAnimation.value,
                  child: Container(
                    width: 400,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE63946),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _slashAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _slashAnimation.value,
                              child: Transform.scale(
                                scale: _slashAnimation.value,
                                child: Transform.rotate(
                                  angle: -0.3,
                                  child: Container(
                                    width: 12,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        AnimatedBuilder(
                          animation: _wAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _wAnimation.value,
                              child: Transform.scale(
                                scale: _wAnimation.value,
                                child: const Text(
                                  'W',
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 10),

            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Transform.translate(
                    offset: Offset((1 - _textAnimation.value) * 50, 0),
                    child: const Text(
                      'ASLA',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE63946),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

            AnimatedBuilder(
              animation: _dotAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: const Offset(-90, 30),
                  child: Opacity(
                    opacity: _dotAnimation.value,
                    child: Transform.scale(
                      scale: _dotAnimation.value,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE63946),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
