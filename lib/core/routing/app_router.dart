import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../features/companies/presentation/pages/company_reviews_page.dart';
import '../../features/home/presentation/pages/discovery_shell_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/requests/presentation/pages/new_service_request_page.dart';
import '../../features/requests/presentation/pages/request_details_page.dart';
import '../../features/companies/presentation/pages/recommended_companies_page.dart';
import '../../features/companies/presentation/pages/trending_companies_page.dart';
import '../../features/offers/presentation/pages/offer_details_page.dart';
import '../../features/reviews/presentation/pages/my_reviews_page.dart';
import '../../features/offers/domain/entities/offer_filter.dart';
import '../../features/home/presentation/cubit/lead_access_state.dart';
import '../../features/home/domain/use_cases/customer_portal_use_cases.dart';
import '../../features/profile/presentation/cubit/profile_edit_cubit.dart';
import '../../core/session/session_cubit.dart';
import '../../core/session/role_resolver.dart';

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
  static const String chatbot = '/chatbot';
  static const String explore = '/explore';
  static const String company = '/company';

  static const String requests = '/requests';
  static const String offers = '/offers';
  static const String profile = '/profile';
  static const String customerRequests = '/my/service-requests';
  static const String customerOffers = '/my/offers';
  static const String customerMyReviews = '/my/reviews';
  static const String customerProfile = '/my/profile';
  static const String customerProfileEdit = '/my/profile/edit';
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
  static const String requestDetails = '/my/service-requests/:requestId';
  static const String requestsFullList = '/my/service-requests/list';
  static const String offerDetailsPath = '/my/offers/:offerId';
  static const String offersFilterQueryKey = 'filter';
  static const String authReasonQueryKey = 'authReason';
  static const String authReasonSessionExpired = 'session_expired';
  static const String authReasonUpgradeRelogin = 'upgrade_reauth_required';

  static const List<String> _protectedRoutePrefixes = <String>[requestActions];

  static const List<String> _browseRoutePrefixes = <String>[
    home,
    chatbot,
    explore,
    company,
    allCompanies,
    recommendedCompanies,
    trendingCompanies,
    requests,
    offers,
    profile,
    customerRequests,
    customerOffers,
    customerMyReviews,
    customerProfile,
    leadProfile,
    leadSettings,
    customerSettings,
    requestDetails,
  ];

  static String companyLocation(int companyId) => '$company/$companyId';

  static String companyReviewsLocation(int companyId) =>
      '$company/$companyId/reviews';

  static String requestDetailsLocation(int serviceRequestId) =>
      '/my/service-requests/$serviceRequestId';

  static String customerRequestsLocation({
    int? ensureRequestId,
    String? refreshToken,
  }) {
    final query = <String, String>{};

    if (ensureRequestId != null && ensureRequestId > 0) {
      query['ensureRequestId'] = ensureRequestId.toString();
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      query['refresh'] = refreshToken;
    }

    if (query.isEmpty) {
      return customerRequests;
    }

    return Uri(path: customerRequests, queryParameters: query).toString();
  }

  static String requestsFullListLocation({String? filter}) {
    if (filter != null && filter.isNotEmpty) {
      return '$requestsFullList?filter=${Uri.encodeComponent(filter)}';
    }
    return requestsFullList;
  }

  static String customerOffersLocation({String? filter}) {
    if (filter != null && filter.trim().isNotEmpty) {
      return Uri(
        path: customerOffers,
        queryParameters: <String, String>{offersFilterQueryKey: filter.trim()},
      ).toString();
    }
    return customerOffers;
  }

  static String customerOffersFilteredLocation(OfferFilter filter) {
    if (filter == OfferFilter.all) {
      return customerOffersLocation();
    }
    return customerOffersLocation(filter: filter.name);
  }

  static String loginLocation({String? authReason}) {
    final normalized = authReason?.trim();
    if (normalized == null || normalized.isEmpty) {
      return login;
    }

    return Uri(
      path: login,
      queryParameters: <String, String>{authReasonQueryKey: normalized},
    ).toString();
  }

  static String customerMyReviewsLocation() => customerMyReviews;

  static String newServiceRequestLocation({required int companyId}) {
    return '$newServiceRequest?companyId=$companyId';
  }

  static String offerDetailsLocation(int offerId) => '/my/offers/$offerId';

  static GoRouter router(
    AuthRepository authRepository, {
    RoleResolver roleResolver = const RoleResolver(),
  }) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: splash,
      redirect: (context, state) async {
        final location = state.matchedLocation;

        if (_isMyReviewsLocation(location)) {
          final session = await authRepository.getStoredSession();
          if (session == null) {
            return login;
          }

          if (!roleResolver.hasCustomerAccess(session.token)) {
            return home;
          }

          return null;
        }

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
        GoRoute(
          path: login,
          builder: (context, state) {
            final authReason = state.uri.queryParameters[authReasonQueryKey];
            return LoginPage(authReason: authReason);
          },
        ),
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
          path: chatbot,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.chatbot),
        ),
        GoRoute(
          path: requests,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.requests),
        ),
        GoRoute(
          path: customerRequests,
          builder: (context, state) {
            final ensureRequestIdRaw =
                state.uri.queryParameters['ensureRequestId'];
            final ensureRequestId = int.tryParse(ensureRequestIdRaw ?? '');
            final refreshToken = state.uri.queryParameters['refresh'];

            return DiscoveryShellPage(
              currentTab: DiscoveryTab.requests,
              requestsEnsureRequestId: ensureRequestId,
              requestsRefreshToken: refreshToken,
            );
          },
        ),
        GoRoute(
          path: offers,
          builder: (context, state) {
            final rawFilter = state.uri.queryParameters[offersFilterQueryKey];
            final initialFilter = OfferFilter.fromQueryValue(rawFilter);
            return DiscoveryShellPage(
              currentTab: DiscoveryTab.offers,
              offersInitialFilter: initialFilter,
            );
          },
        ),
        GoRoute(
          path: customerOffers,
          builder: (context, state) {
            final rawFilter = state.uri.queryParameters[offersFilterQueryKey];
            final initialFilter = OfferFilter.fromQueryValue(rawFilter);
            return DiscoveryShellPage(
              currentTab: DiscoveryTab.offers,
              offersInitialFilter: initialFilter,
            );
          },
        ),
        GoRoute(
          path: customerMyReviews,
          builder: (context, state) => const MyReviewsPage(),
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
          builder: (context, state) {
            final cubit = ProfileEditCubit(
              loader: () async {
                final profile = await context
                    .read<GetCustomerProfileUseCase>()();
                return ProfileEditFields(
                  firstName: profile.firstName ?? '',
                  lastName: profile.lastName ?? '',
                  email: profile.email ?? '',
                  phoneNumber: profile.phoneNumber ?? '',
                  address: profile.address ?? '',
                  city: profile.city ?? '',
                  zipCode: profile.zipCode ?? '',
                  country: profile.country ?? '',
                  createdAt: profile.createdAt,
                );
              },
              saver: (input) async {
                final profile = await context
                    .read<UpdateCustomerProfileUseCase>()(input);
                return ProfileEditFields(
                  firstName: profile.firstName ?? '',
                  lastName: profile.lastName ?? '',
                  email: profile.email ?? '',
                  phoneNumber: profile.phoneNumber ?? '',
                  address: profile.address ?? '',
                  city: profile.city ?? '',
                  zipCode: profile.zipCode ?? '',
                  country: profile.country ?? '',
                  createdAt: profile.createdAt,
                );
              },
              sessionCubit: context.read<SessionCubit>(),
            )..load();
            return ProfileEditPage(cubit: cubit);
          },
        ),
        GoRoute(
          path: leadProfile,
          builder: (context, state) =>
              const DiscoveryShellPage(currentTab: DiscoveryTab.profile),
        ),
        GoRoute(
          path: leadProfileEdit,
          builder: (context, state) {
            final cubit = ProfileEditCubit(
              loader: () async {
                final profile = await context.read<GetLeadProfileUseCase>()();
                return ProfileEditFields(
                  firstName: profile.firstName ?? '',
                  lastName: profile.lastName ?? '',
                  email: profile.email ?? '',
                  phoneNumber: profile.phoneNumber ?? '',
                  address: profile.address ?? '',
                  city: profile.city ?? '',
                  zipCode: profile.zipCode ?? '',
                  country: profile.country ?? '',
                  createdAt: profile.createdAt,
                );
              },
              saver: (input) async {
                final profile = await context.read<UpdateLeadProfileUseCase>()(
                  input,
                );
                return ProfileEditFields(
                  firstName: profile.firstName ?? '',
                  lastName: profile.lastName ?? '',
                  email: profile.email ?? '',
                  phoneNumber: profile.phoneNumber ?? '',
                  address: profile.address ?? '',
                  city: profile.city ?? '',
                  zipCode: profile.zipCode ?? '',
                  country: profile.country ?? '',
                  createdAt: profile.createdAt,
                );
              },
              sessionCubit: context.read<SessionCubit>(),
            )..load();
            return ProfileEditPage(cubit: cubit);
          },
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
          path: '$company/:companyId',
          builder: (context, state) {
            final companyIdRaw = state.pathParameters['companyId'];
            final companyId = int.tryParse(companyIdRaw ?? '') ?? -1;
            return CompanyDetailsPage(companyId: companyId);
          },
          routes: [
            GoRoute(
              path: 'reviews',
              builder: (context, state) {
                final companyIdRaw = state.pathParameters['companyId'];
                final companyId = int.tryParse(companyIdRaw ?? '') ?? -1;
                return CompanyReviewsPage(companyId: companyId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/my/service-requests/:requestId',
          builder: (context, state) {
            final requestIdRaw = state.pathParameters['requestId'];
            final requestId = int.tryParse(requestIdRaw ?? '') ?? -1;
            return RequestDetailsPage(serviceRequestId: requestId);
          },
        ),
        GoRoute(
          path: '/my/offers/:offerId',
          builder: (context, state) {
            final offerIdRaw = state.pathParameters['offerId'];
            final offerId = int.tryParse(offerIdRaw ?? '') ?? -1;
            return OfferDetailsPage(offerId: offerId);
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

  static bool _isMyReviewsLocation(String location) {
    return location == customerMyReviews ||
        location.startsWith('$customerMyReviews/');
  }
}
