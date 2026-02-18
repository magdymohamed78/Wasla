import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/auth/presentation/pages/login_placeholder_page.dart';
import '../../features/auth/presentation/pages/register_placeholder_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String support = '/support';
  static const String login = '/login';
  static const String register = '/register';

  static GoRouter router() {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: onboarding,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardingPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: support,
          builder: (context, state) => const SupportPage(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginPlaceholderPage(),
        ),
        GoRoute(
          path: register,
          builder: (context, state) => const RegisterPlaceholderPage(),
        ),
      ],
    );
  }
}