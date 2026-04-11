import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/discovery_use_cases.dart';
import '../cubit/home_discovery_cubit.dart';
import '../cubit/home_discovery_state.dart';
import '../widgets/company_section_carousel.dart';
import '../widgets/home_section_skeleton.dart';

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
                  _ExploreSearchEntry(
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
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _buildSection(
                    localizations: localizations,
                    title: localizations.homeTrendingCompanies,
                    section: state.trendingSection,
                    onRetry: cubit.retryTrending,
                    showTrendIndicator: true,
                    errorFallback: localizations.homeTrendingLoadFailed,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _buildSection(
                    localizations: localizations,
                    title: localizations.homeAllCompanies,
                    section: state.allCompaniesSection,
                    onRetry: cubit.retryAllCompanies,
                    showTrendIndicator: false,
                    errorFallback: localizations.homeAllCompaniesLoadFailed,
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

class _ExploreSearchEntry extends StatelessWidget {
  final String hintText;
  final VoidCallback onTap;

  const _ExploreSearchEntry({required this.hintText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusRound,
            ), // Makes it pill shaped
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  hintText,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Icon(Icons.tune_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
