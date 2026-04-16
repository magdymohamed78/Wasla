import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/company_summary.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';
import '../cubit/explore_cubit.dart';
import '../cubit/explore_state.dart';
import '../widgets/explore_results_list.dart';
import '../widgets/service_filter_chips.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExploreCubit>(
      create: (context) => ExploreCubit(
        getAllCompaniesUseCase: context.read<GetAllCompaniesUseCase>(),
      ),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  late final PagingController<int, CompanySummary> _pagingController;
  late final TextEditingController _companyController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, CompanySummary>(firstPageKey: 1);
    _companyController = TextEditingController();
    _cityController = TextEditingController();

    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    final cubit = context.read<ExploreCubit>();
    final criteriaVersion = cubit.state.criteriaVersion;

    try {
      final page = await cubit.fetchPage(
        pageIndex: pageKey,
        criteriaVersion: criteriaVersion,
      );

      if (!mounted || page == null) {
        return;
      }

      final isLastPage = page.hasReachedEnd || page.items.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(page.items);
      } else {
        _pagingController.appendPage(page.items, page.pageIndex + 1);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _companyController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(localizations.explorePageTitle),
      ),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<ExploreCubit, ExploreState>(
              listenWhen: (previous, current) =>
                  previous.companyQuery != current.companyQuery,
              listener: (context, state) {
                if (_companyController.text == state.companyQuery) {
                  return;
                }

                _companyController.value = TextEditingValue(
                  text: state.companyQuery,
                  selection: TextSelection.collapsed(
                    offset: state.companyQuery.length,
                  ),
                );
              },
            ),
            BlocListener<ExploreCubit, ExploreState>(
              listenWhen: (previous, current) =>
                  previous.cityQuery != current.cityQuery,
              listener: (context, state) {
                if (_cityController.text == state.cityQuery) {
                  return;
                }

                _cityController.value = TextEditingValue(
                  text: state.cityQuery,
                  selection: TextSelection.collapsed(
                    offset: state.cityQuery.length,
                  ),
                );
              },
            ),
            BlocListener<ExploreCubit, ExploreState>(
              listenWhen: (previous, current) =>
                  previous.criteriaVersion != current.criteriaVersion,
              listener: (context, state) {
                _pagingController.refresh();
              },
            ),
          ],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingMd,
                  AppDimensions.paddingSm,
                  AppDimensions.paddingMd,
                  AppDimensions.paddingSm,
                ),
                child: _SearchInputsContainer(
                  companyController: _companyController,
                  cityController: _cityController,
                  companyHintText: localizations.exploreSearchCompanies,
                  cityHintText: localizations.exploreSearchCity,
                  onCompanyChanged: context
                      .read<ExploreCubit>()
                      .onCompanyQueryChanged,
                  onCityChanged: context
                      .read<ExploreCubit>()
                      .onCityQueryChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                child: BlocBuilder<ExploreCubit, ExploreState>(
                  buildWhen: (previous, current) =>
                      previous.selectedService != current.selectedService,
                  builder: (context, state) {
                    return ServiceFilterChips(
                      selectedOption: state.selectedService,
                      onSelected: context
                          .read<ExploreCubit>()
                          .onServiceSelected,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Expanded(
                child: ExploreResultsList(
                  pagingController: _pagingController,
                  onClearFilters: context.read<ExploreCubit>().clearFilters,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInputsContainer extends StatelessWidget {
  final TextEditingController companyController;
  final TextEditingController cityController;
  final String companyHintText;
  final String cityHintText;
  final ValueChanged<String> onCompanyChanged;
  final ValueChanged<String> onCityChanged;

  const _SearchInputsContainer({
    required this.companyController,
    required this.cityController,
    required this.companyHintText,
    required this.cityHintText,
    required this.onCompanyChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
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
          Expanded(
            flex: 3,
            child: _InlineSearchField(
              controller: companyController,
              hintText: companyHintText,
              icon: Icons.search_rounded,
              onChanged: onCompanyChanged,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Container(
            width: 1,
            height: AppDimensions.iconSizeLg,
            color: AppColors.divider,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            flex: 2,
            child: _InlineSearchField(
              controller: cityController,
              hintText: cityHintText,
              icon: Icons.location_on_rounded,
              onChanged: onCityChanged,
              textInputAction: TextInputAction.search,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;

  const _InlineSearchField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.bodyMedium,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXs,
          vertical: AppDimensions.paddingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
