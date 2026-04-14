import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/discovery_use_cases.dart';
import '../cubit/home_discovery_cubit.dart';
import '../cubit/home_discovery_state.dart';
import '../widgets/company_section_carousel.dart';
import '../widgets/home_section_skeleton.dart';
import '../widgets/view_all_search_entry.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeDiscoveryCubit>(
      create: (context) => HomeDiscoveryCubit(
        getRecommendedCompaniesUseCase: context
            .read<GetRecommendedCompaniesUseCase>(),
        getTrendingCompaniesUseCase: context
            .read<GetTrendingCompaniesUseCase>(),
        getAllCompaniesUseCase: context.read<GetAllCompaniesUseCase>(),
      )..loadInitial(),
      child: const _HomeDiscoveryView(),
    );
  }
}

class _HomeDiscoveryView extends StatelessWidget {
  const _HomeDiscoveryView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final cubit = context.read<HomeDiscoveryCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: cubit.loadInitial,
          child: BlocBuilder<HomeDiscoveryCubit, HomeDiscoveryState>(
            builder: (context, state) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                children: [
                  ViewAllSearchEntry(
                    hintText: localizations.homeSearchForServicesOrCompanies,
                    onTap: () => context.push(AppRouter.explore),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _buildSection(
                    localizations: localizations,
                    title: localizations.homeRecommendedCompanies,
                    section: state.recommendedSection,
                    onRetry: cubit.retryRecommended,
                    showTrendIndicator: false,
                    errorFallback: localizations.homeRecommendedLoadFailed,
                    onViewAll: () =>
                        context.push(AppRouter.recommendedCompanies),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _buildSection(
                    localizations: localizations,
                    title: localizations.homeTrendingCompanies,
                    section: state.trendingSection,
                    onRetry: cubit.retryTrending,
                    showTrendIndicator: true,
                    errorFallback: localizations.homeTrendingLoadFailed,
                    onViewAll: () => context.push(AppRouter.trendingCompanies),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _buildSection(
                    localizations: localizations,
                    title: localizations.homeAllCompanies,
                    section: state.allCompaniesSection,
                    onRetry: cubit.retryAllCompanies,
                    showTrendIndicator: false,
                    errorFallback: localizations.homeAllCompaniesLoadFailed,
                    onViewAll: () => context.push(AppRouter.allCompanies),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required AppLocalizations localizations,
    required String title,
    required HomeSectionState section,
    required Future<void> Function() onRetry,
    required bool showTrendIndicator,
    required String errorFallback,
    required VoidCallback onViewAll,
  }) {
    switch (section.status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return HomeSectionSkeleton(title: title);
      case LoadStatus.success:
        return CompanySectionCarousel(
          title: title,
          companies: section.items,
          showTrendIndicator: showTrendIndicator,
          viewAllLabel: localizations.homeViewAll,
          onViewAll: onViewAll,
        );
      case LoadStatus.empty:
        return HomeSectionEmpty(
          title: title,
          message: localizations.exploreNoCompaniesFound,
        );
      case LoadStatus.error:
        return HomeSectionInlineError(
          title: title,
          message: section.errorMessage ?? errorFallback,
          onRetry: () => onRetry(),
        );
    }
  }
}
