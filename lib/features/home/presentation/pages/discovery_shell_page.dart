import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/use_cases/role_guard_use_cases.dart';
import '../cubit/lead_access_cubit.dart';
import '../cubit/lead_access_state.dart';
import '../widgets/discovery_floating_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../offers/presentation/pages/customer_offers_page.dart';
import '../../../profile/presentation/pages/customer_profile_page.dart';
import '../../../requests/presentation/pages/customer_requests_page.dart';
import '../../../settings/presentation/pages/customer_settings_page.dart';
import 'home_page.dart';
import '../../../profile/presentation/pages/lead_profile_page.dart';
import '../../../settings/presentation/pages/lead_settings_page.dart';
import 'restricted_tab_page.dart';

class DiscoveryShellPage extends StatelessWidget {
  final DiscoveryTab currentTab;
  final int? requestsEnsureRequestId;
  final String? requestsRefreshToken;

  const DiscoveryShellPage({
    super.key,
    required this.currentTab,
    this.requestsEnsureRequestId,
    this.requestsRefreshToken,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocProvider<LeadAccessCubit>(
      create: (context) => LeadAccessCubit(
        sessionCubit: context.read<SessionCubit>(),
        roleGuardUseCases: context.read<RoleGuardUseCases>(),
      )..resolveAccessContext(),
      child: BlocBuilder<LeadAccessCubit, LeadAccessState>(
        builder: (context, state) {
          final navItems = _navigationItems(
            context: context,
            localizations: localizations,
            state: state,
          );

          return Scaffold(
            backgroundColor: AppColors.background,
            body: _tabBody(
              context: context,
              localizations: localizations,
              state: state,
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: AppColors.surface,
              indicatorColor: AppColors.brandRed.withValues(alpha: 0.1),
              elevation: 8,
              shadowColor: AppColors.cardShadow.withValues(alpha: 0.1),
              selectedIndex: _selectedIndex(state),
              onDestinationSelected: (index) {
                navItems[index].onTap();
              },
              destinations: navItems
                  .map(
                    (item) => NavigationDestination(
                      icon: item.icon,
                      selectedIcon: item.selectedIcon ?? item.icon,
                      label: item.label,
                    ),
                  )
                  .toList(growable: false),
            ),
          );
        },
      ),
    );
  }

  Widget _tabBody({
    required BuildContext context,
    required AppLocalizations localizations,
    required LeadAccessState state,
  }) {
    if (currentTab == DiscoveryTab.home) {
      return const HomePlaceholderPage();
    }

    if (state.isLoading) {
      return const _AccessContextLoadingView();
    }

    if (state.isTabRestricted(currentTab)) {
      final isGuestRestriction = state.shouldShowGuestOnboardingCta(currentTab);

      return RestrictedTabPage(
        title: _restrictedTitle(localizations),
        message: _restrictedMessage(localizations),
        primaryActionLabel: isGuestRestriction
            ? localizations.navigationSignIn
            : localizations.restrictionBrowseCompanies,
        onPrimaryAction: isGuestRestriction
            ? () => context.push(AppRouter.signIn)
            : () => context.go(AppRouter.home),
        secondaryActionLabel: state.shouldShowBrowseSecondaryAction(currentTab)
            ? localizations.restrictionBrowseCompanies
            : null,
        onSecondaryAction: state.shouldShowBrowseSecondaryAction(currentTab)
            ? () => context.go(AppRouter.home)
            : null,
      );
    }

    switch (currentTab) {
      case DiscoveryTab.home:
        return const HomePlaceholderPage();
      case DiscoveryTab.requests:
        return CustomerRequestsPage(
          ensureRequestId: requestsEnsureRequestId,
          refreshToken: requestsRefreshToken,
        );
      case DiscoveryTab.offers:
        return const CustomerOffersPage();
      case DiscoveryTab.profile:
        if (state.isLead) {
          return const LeadProfilePage();
        }
        return const CustomerProfilePage();
      case DiscoveryTab.settings:
        switch (state.settingsDestination) {
          case SettingsDestination.lead:
            return const LeadSettingsPage();
          case SettingsDestination.customer:
            return const CustomerSettingsPage();
          case SettingsDestination.unavailable:
            return RestrictedTabPage(
              title: localizations.navigationSettings,
              message: localizations.restrictionProfileMessage,
              primaryActionLabel: localizations.navigationSignIn,
              onPrimaryAction: () => context.push(AppRouter.signIn),
            );
        }
    }
  }

  String _restrictedTitle(AppLocalizations localizations) {
    switch (currentTab) {
      case DiscoveryTab.home:
        return localizations.homeAllCompanies;
      case DiscoveryTab.requests:
        return localizations.restrictionRequestsTitle;
      case DiscoveryTab.offers:
        return localizations.restrictionOffersTitle;
      case DiscoveryTab.profile:
        return localizations.restrictionProfileTitle;
      case DiscoveryTab.settings:
        return localizations.navigationSettings;
    }
  }

  String _restrictedMessage(AppLocalizations localizations) {
    switch (currentTab) {
      case DiscoveryTab.home:
        return localizations.restrictionLoginOrRegister;
      case DiscoveryTab.requests:
        return localizations.restrictionRequestsMessage;
      case DiscoveryTab.offers:
        return localizations.restrictionOffersMessage;
      case DiscoveryTab.profile:
        return localizations.restrictionProfileMessage;
      case DiscoveryTab.settings:
        return localizations.restrictionProfileMessage;
    }
  }

  String _routeForTab(DiscoveryTab tab, LeadAccessState state) {
    switch (tab) {
      case DiscoveryTab.home:
        return AppRouter.home;
      case DiscoveryTab.requests:
        return state.isCustomer
            ? AppRouter.customerRequests
            : AppRouter.requests;
      case DiscoveryTab.offers:
        return state.isCustomer ? AppRouter.customerOffers : AppRouter.offers;
      case DiscoveryTab.profile:
        if (state.isLead) {
          return AppRouter.leadProfile;
        }
        return state.isCustomer ? AppRouter.customerProfile : AppRouter.profile;
      case DiscoveryTab.settings:
        return _settingsRoute(state) ?? AppRouter.home;
    }
  }

  int _selectedIndex(LeadAccessState state) {
    if (state.isGuest) {
      switch (currentTab) {
        case DiscoveryTab.home:
          return 0;
        case DiscoveryTab.requests:
        case DiscoveryTab.offers:
          return 1;
        case DiscoveryTab.profile:
        case DiscoveryTab.settings:
          return 2;
      }
    }

    switch (currentTab) {
      case DiscoveryTab.home:
        return 0;
      case DiscoveryTab.requests:
      case DiscoveryTab.offers:
        return 1;
      case DiscoveryTab.profile:
        return 2;
      case DiscoveryTab.settings:
        return 3;
    }
  }

  List<_ShellNavItem> _navigationItems({
    required BuildContext context,
    required AppLocalizations localizations,
    required LeadAccessState state,
  }) {
    final wIcon = Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.brandRed,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'W',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );

    final modalItem = _ShellNavItem(
      label: localizations.moreLabell,
      icon: wIcon,
      selectedIcon: wIcon,
      onTap: () {
        showBarModalBottomSheet(
          context: context,
          builder: (_) => DiscoveryFloatingModal(
            role: state.role,
            onAllCompaniesTap: () => context.push(AppRouter.allCompanies),
            onRecommendedCompaniesTap: () =>
                context.push(AppRouter.recommendedCompanies),
            onTrendingCompaniesTap: () =>
                context.push(AppRouter.trendingCompanies),
            onRequestsTap: () => context.go(AppRouter.customerRequests),
            onOffersTap: () => context.go(AppRouter.customerOffers),
          ),
        );
      },
    );

    if (state.isGuest) {
      return [
        _ShellNavItem(
          label: localizations.navigationCompanies,
          icon: const Icon(Icons.grid_view_rounded),
          selectedIcon: const Icon(
            Icons.grid_view_rounded,
            color: AppColors.brandRed,
          ),
          onTap: () => context.go(AppRouter.home),
        ),
        modalItem,
        _ShellNavItem(
          label: localizations.navigationSignIn,
          icon: const Icon(Icons.login_rounded),
          selectedIcon: const Icon(
            Icons.login_rounded,
            color: AppColors.brandRed,
          ),
          onTap: () => context.push(AppRouter.signIn),
        ),
      ];
    }

    return [
      _ShellNavItem(
        label: localizations.navigationHome,
        icon: const Icon(Icons.grid_view_rounded),
        selectedIcon: const Icon(
          Icons.grid_view_rounded,
          color: AppColors.brandRed,
        ),
        onTap: () => context.go(AppRouter.home),
      ),
      modalItem,
      _ShellNavItem(
        label: localizations.navigationProfile,
        icon: const Icon(Icons.person_outline_rounded),
        selectedIcon: const Icon(
          Icons.person_rounded,
          color: AppColors.brandRed,
        ),
        onTap: () {
          if (currentTab != DiscoveryTab.profile) {
            context.go(_routeForTab(DiscoveryTab.profile, state));
          }
        },
      ),
      _ShellNavItem(
        label: localizations.navigationSettings,
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings, color: AppColors.brandRed),
        onTap: () {
          if (currentTab != DiscoveryTab.settings) {
            final route = _settingsRoute(state);
            if (route != null) {
              context.go(route);
            }
          }
        },
      ),
    ];
  }

  String? _settingsRoute(LeadAccessState state) {
    switch (state.settingsDestination) {
      case SettingsDestination.lead:
        return AppRouter.leadSettings;
      case SettingsDestination.customer:
        return AppRouter.customerSettings;
      case SettingsDestination.unavailable:
        return null;
    }
  }
}

class _ShellNavItem {
  final String label;
  final Widget icon;
  final Widget? selectedIcon;
  final VoidCallback onTap;

  const _ShellNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    required this.onTap,
  });
}

class _AccessContextLoadingView extends StatelessWidget {
  const _AccessContextLoadingView();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.background,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
