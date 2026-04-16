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
import '../../../companies/presentation/widgets/companies_nav_dropdown.dart';
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

  const DiscoveryShellPage({super.key, required this.currentTab});

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
                      icon: Icon(item.icon),
                      selectedIcon: Icon(
                        item.selectedIcon,
                        color: AppColors.brandRed,
                      ),
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
        return const CustomerRequestsPage();
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
      return currentTab == DiscoveryTab.home ? 0 : 1;
    }

    if (state.isLead) {
      switch (currentTab) {
        case DiscoveryTab.home:
          return 0;
        case DiscoveryTab.profile:
          return 1;
        case DiscoveryTab.settings:
          return 2;
        case DiscoveryTab.requests:
        case DiscoveryTab.offers:
          return 0;
      }
    }

    switch (currentTab) {
      case DiscoveryTab.home:
        return 0;
      case DiscoveryTab.requests:
        return 1;
      case DiscoveryTab.offers:
        return 2;
      case DiscoveryTab.profile:
        return 3;
      case DiscoveryTab.settings:
        return 4;
    }
  }

  List<_ShellNavItem> _navigationItems({
    required BuildContext context,
    required AppLocalizations localizations,
    required LeadAccessState state,
  }) {
    if (state.isGuest) {
      return <_ShellNavItem>[
        _ShellNavItem(
          label: localizations.navigationCompanies,
          icon: Icons.grid_view_rounded,
          selectedIcon: Icons.grid_view_rounded,
          onTap: () {
            _openCompaniesDropdown(
              context: context,
              localizations: localizations,
              navigationItemCount: 2,
            );
          },
        ),
        _ShellNavItem(
          label: localizations.navigationSignIn,
          icon: Icons.login_rounded,
          selectedIcon: Icons.login_rounded,
          onTap: () => context.push(AppRouter.signIn),
        ),
      ];
    }

    if (state.isLead) {
      return <_ShellNavItem>[
        _ShellNavItem(
          label: localizations.navigationCompanies,
          icon: Icons.grid_view_rounded,
          selectedIcon: Icons.grid_view_rounded,
          onTap: () {
            _openCompaniesDropdown(
              context: context,
              localizations: localizations,
              navigationItemCount: 3,
            );
          },
        ),
        _ShellNavItem(
          label: localizations.navigationProfile,
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
          onTap: () {
            if (currentTab != DiscoveryTab.profile) {
              context.go(_routeForTab(DiscoveryTab.profile, state));
            }
          },
        ),
        _ShellNavItem(
          label: localizations.navigationSettings,
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
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

    return <_ShellNavItem>[
      _ShellNavItem(
        label: localizations.navigationCompanies,
        icon: Icons.grid_view_rounded,
        selectedIcon: Icons.grid_view_rounded,
        onTap: () {
          _openCompaniesDropdown(
            context: context,
            localizations: localizations,
            navigationItemCount: 5,
          );
        },
      ),
      _ShellNavItem(
        label: localizations.navigationRequests,
        icon: Icons.assignment_outlined,
        selectedIcon: Icons.assignment_rounded,
        onTap: () {
          if (currentTab != DiscoveryTab.requests) {
            context.go(_routeForTab(DiscoveryTab.requests, state));
          }
        },
      ),
      _ShellNavItem(
        label: localizations.navigationOffers,
        icon: Icons.local_offer_outlined,
        selectedIcon: Icons.local_offer,
        onTap: () {
          if (currentTab != DiscoveryTab.offers) {
            context.go(_routeForTab(DiscoveryTab.offers, state));
          }
        },
      ),
      _ShellNavItem(
        label: localizations.navigationProfile,
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        onTap: () {
          if (currentTab != DiscoveryTab.profile) {
            context.go(_routeForTab(DiscoveryTab.profile, state));
          }
        },
      ),
      _ShellNavItem(
        label: localizations.navigationSettings,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
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

  Future<void> _openCompaniesDropdown({
    required BuildContext context,
    required AppLocalizations localizations,
    required int navigationItemCount,
  }) async {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    if (currentTab != DiscoveryTab.home) {
      context.go(AppRouter.home);
      await WidgetsBinding.instance.endOfFrame;
    }

    final selectedRoute = await CompaniesNavDropdown.show(
      // ignore: use_build_context_synchronously
      context: rootContext,
      localizations: localizations,
      navigationItemCount: navigationItemCount,
    );

    if (selectedRoute == null) {
      return;
    }

    // ignore: use_build_context_synchronously
    GoRouter.of(rootContext).go(selectedRoute);
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
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onTap;

  const _ShellNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
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
