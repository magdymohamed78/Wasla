import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/sign_up_success_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/home/presentation/pages/home_placeholder_page.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String support = '/support';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String changePassword = '/change-password';
  static const String registerSuccess = '/register-success';
  static const String home = '/home';

  static GoRouter router(AuthRepository authRepository) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: splash,
      routes: [
        GoRoute(path: splash, builder: (context, state) => const SplashPage()),
        GoRoute(
          path: onboarding,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardingPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
        GoRoute(
          path: support,
          builder: (context, state) => const SupportPage(),
        ),
        GoRoute(path: login, builder: (context, state) => const LoginPage()),
        GoRoute(
          path: register,
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: forgotPassword,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: otpVerification,
          // Redirects to /change-password so the old deep-link still works.
          redirect: (context, state) {
            final email = state.extra as String? ?? '';
            return '$changePassword?email=${Uri.encodeComponent(email)}';
          },
        ),
        GoRoute(
          path: changePassword,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final email = extra['email'] as String? ?? '';
            return ChangePasswordPage(email: email);
          },
        ),
        GoRoute(
          path: registerSuccess,
          builder: (context, state) => const SignUpSuccessPage(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => const HomePlaceholderPage(),
          redirect: (context, state) async {
            final session = await authRepository.getStoredSession();
            if (session == null) {
              return login;
            }
            return null;
          },
        ),
      ],
    );
  }
}
