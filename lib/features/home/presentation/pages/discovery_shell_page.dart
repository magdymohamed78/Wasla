import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../cubit/lead_access_cubit.dart';
import '../cubit/lead_access_state.dart';
import 'home_placeholder_page.dart';
import 'restricted_tab_page.dart';

class DiscoveryShellPage extends StatelessWidget {
  final DiscoveryTab currentTab;

  const DiscoveryShellPage({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocProvider<LeadAccessCubit>(
      create: (context) =>
          LeadAccessCubit(authRepository: context.read<AuthRepository>())
            ..resolveAccessContext(),
      child: BlocBuilder<LeadAccessCubit, LeadAccessState>(
        builder: (context, state) {
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
              selectedIndex: currentTab.index,
              onDestinationSelected: (index) {
                final selectedTab = DiscoveryTab.values[index];
                if (selectedTab == currentTab) {
                  return;
                }

                context.go(_routeForTab(selectedTab));
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.grid_view_rounded),
                  selectedIcon: const Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.brandRed,
                  ),
                  label: localizations.navigationHome,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.assignment_outlined),
                  selectedIcon: const Icon(
                    Icons.assignment_rounded,
                    color: AppColors.brandRed,
                  ),
                  label: localizations.navigationRequests,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.local_shipping_outlined),
                  selectedIcon: const Icon(
                    Icons.local_shipping_rounded,
                    color: AppColors.brandRed,
                  ),
                  label: localizations.navigationOffers,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(
                    Icons.person_rounded,
                    color: AppColors.brandRed,
                  ),
                  label: localizations.navigationProfile,
                ),
              ],
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
      return RestrictedTabPage(
        title: _restrictedTitle(localizations),
        message: localizations.restrictionLoginOrRegister,
        browseCompaniesLabel: localizations.restrictionBrowseCompanies,
        onBrowseCompanies: () => context.go(AppRouter.home),
      );
    }

    return _UnrestrictedTabPlaceholder(title: _tabLabel(localizations));
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
    }
  }

  String _tabLabel(AppLocalizations localizations) {
    switch (currentTab) {
      case DiscoveryTab.home:
        return localizations.navigationHome;
      case DiscoveryTab.requests:
        return localizations.navigationRequests;
      case DiscoveryTab.offers:
        return localizations.navigationOffers;
      case DiscoveryTab.profile:
        return localizations.navigationProfile;
    }
  }

  String _routeForTab(DiscoveryTab tab) {
    switch (tab) {
      case DiscoveryTab.home:
        return AppRouter.home;
      case DiscoveryTab.requests:
        return AppRouter.requests;
      case DiscoveryTab.offers:
        return AppRouter.offers;
      case DiscoveryTab.profile:
        return AppRouter.profile;
    }
  }
}

class _UnrestrictedTabPlaceholder extends StatelessWidget {
  final String title;

  const _UnrestrictedTabPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(child: Text(title, style: AppTypography.heading2)),
    );
  }
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
