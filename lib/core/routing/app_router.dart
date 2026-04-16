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
import '../../features/companies/presentation/pages/all_companies_page.dart';
import '../../features/companies/presentation/pages/company_details_page.dart';
import '../../features/profile/presentation/pages/customer_connected_companies_page.dart';
import '../../features/profile/presentation/pages/customer_profile_edit_page.dart';
import '../../features/home/presentation/pages/discovery_shell_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/profile/presentation/pages/lead_profile_edit_page.dart';
import '../../features/requests/presentation/pages/new_service_request_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/companies/presentation/pages/recommended_companies_page.dart';
import '../../features/companies/presentation/pages/trending_companies_page.dart';
import '../../features/home/presentation/cubit/lead_access_state.dart';
import '../../features/home/domain/entities/customer_portal_content.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String support = '/support';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String changePassword = '/change-password';
  static const String registerSuccess = '/register-success';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String company = '/company';

  static const String requests = '/requests';
  static const String offers = '/offers';
  static const String profile = '/profile';
  static const String customerRequests = '/my/service-requests';
  static const String customerOffers = '/my/offers';
  static const String customerProfile = '/my/profile';
  static const String customerProfileEdit = '/my/profile/edit';
  static const String customerConnectedCompanies =
      '/my/profile/connected-companies';
  static const String leadProfile = '/my/lead-profile';
  static const String leadProfileEdit = '/my/lead-profile/edit';
  static const String requestActions = '/request-actions';
  static const String newServiceRequest = '/new-service-request';
  static const String leadSettings = '/my/lead-settings';
  static const String customerSettings = '/my/settings';
  static const String allCompanies = '/companies/all';
  static const String recommendedCompanies = '/companies/recommended';
  static const String trendingCompanies = '/companies/trending';
  static const String notifications = '/notifications';

  static const List<String> _protectedRoutePrefixes = <String>[requestActions];

  static const List<String> _browseRoutePrefixes = <String>[
    home,
    explore,
    company,
    allCompanies,
    recommendedCompanies,
    trendingCompanies,
    notifications,
    requests,
    offers,
    profile,
    customerRequests,
    customerOffers,
    customerProfile,
    leadProfile,
    leadSettings,
    customerSettings,
  ];

  static String companyLocation(int companyId) => '$company/$companyId';

  static String newServiceRequestLocation({required int companyId}) {
    return '$newServiceRequest?companyId=$companyId';
  }

  static GoRouter router(AuthRepository authRepository) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: splash,
      redirect: (context, state) async {
        final location = state.matchedLocation;
        if (_isBrowseLocation(location)) {
          return null;
        }

        if (!_isProtectedLocation(location)) {
          return null;
        }

        final session = await authRepository.getStoredSession();
        if (session == null) {
          return login;
        }

        return null;
      },
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
        GoRoute(path: signIn, redirect: (context, state) => onboarding),
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
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.home),
        ),
        GoRoute(
          path: requests,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.requests),
        ),
        GoRoute(
          path: customerRequests,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.requests),
        ),
        GoRoute(
          path: offers,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.offers),
        ),
        GoRoute(
          path: customerOffers,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.offers),
        ),
        GoRoute(
          path: profile,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.profile),
        ),
        GoRoute(
          path: customerProfile,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.profile),
        ),
        GoRoute(
          path: customerProfileEdit,
          builder: (context, state) => const CustomerProfileEditPage(),
        ),
        GoRoute(
          path: customerConnectedCompanies,
          builder: (context, state) {
            final extra = state.extra;
            final companies = extra is List<ConnectedCompany>
                ? extra
                : const <ConnectedCompany>[];

            return CustomerConnectedCompaniesPage(companies: companies);
          },
        ),
        GoRoute(
          path: leadProfile,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.profile),
        ),
        GoRoute(
          path: leadProfileEdit,
          builder: (context, state) => const LeadProfileEditPage(),
        ),
        GoRoute(
          path: newServiceRequest,
          builder: (context, state) {
            final companyIdRaw = state.uri.queryParameters['companyId'];
            final companyId = int.tryParse(companyIdRaw ?? '') ?? -1;
            return NewServiceRequestPage(companyId: companyId);
          },
        ),
        GoRoute(
          path: leadSettings,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.settings),
        ),
        GoRoute(
          path: customerSettings,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.settings),
        ),
        GoRoute(
          path: allCompanies,
          builder: (context, state) => const AllCompaniesPage(),
        ),
        GoRoute(
          path: recommendedCompanies,
          builder: (context, state) => const RecommendedCompaniesPage(),
        ),
        GoRoute(
          path: trendingCompanies,
          builder: (context, state) => const TrendingCompaniesPage(),
        ),
        GoRoute(
          path: explore,
          builder: (context, state) => const ExplorePage(),
        ),
        GoRoute(
          path: notifications,
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: '$company/:companyId',
          builder: (context, state) {
            final companyIdRaw = state.pathParameters['companyId'];
            final companyId = int.tryParse(companyIdRaw ?? '') ?? -1;
            return CompanyDetailsPage(companyId: companyId);
          },
        ),
      ],
    );
  }

  static bool _isProtectedLocation(String location) {
    return _protectedRoutePrefixes.any(
      (prefix) => location == prefix || location.startsWith('$prefix/'),
    );
  }

  static bool _isBrowseLocation(String location) {
    return _browseRoutePrefixes.any(
      (prefix) => location == prefix || location.startsWith('$prefix/'),
    );
  }
}
