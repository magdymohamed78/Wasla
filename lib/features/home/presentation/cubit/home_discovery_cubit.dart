import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/company_summary.dart';
import '../../domain/use_cases/discovery_use_cases.dart';
import 'home_discovery_state.dart';

class HomeDiscoveryCubit extends Cubit<HomeDiscoveryState> {
  static const int _homePreviewLimit = 3;

  final GetRecommendedCompaniesUseCase _getRecommendedCompaniesUseCase;
  final GetTrendingCompaniesUseCase _getTrendingCompaniesUseCase;
  final GetAllCompaniesUseCase _getAllCompaniesUseCase;

  HomeDiscoveryCubit({
    required GetRecommendedCompaniesUseCase getRecommendedCompaniesUseCase,
    required GetTrendingCompaniesUseCase getTrendingCompaniesUseCase,
    required GetAllCompaniesUseCase getAllCompaniesUseCase,
  }) : _getRecommendedCompaniesUseCase = getRecommendedCompaniesUseCase,
       _getTrendingCompaniesUseCase = getTrendingCompaniesUseCase,
       _getAllCompaniesUseCase = getAllCompaniesUseCase,
       super(const HomeDiscoveryState());

  Future<void> loadInitial() async {
    await Future.wait<void>([
      loadRecommendedCompanies(),
      loadTrendingCompanies(),
      loadAllCompanies(),
    ]);
  }

  Future<void> retryRecommended() => loadRecommendedCompanies();
  Future<void> retryTrending() => loadTrendingCompanies();
  Future<void> retryAllCompanies() => loadAllCompanies();

  Future<void> loadRecommendedCompanies() async {
    final previousItems = state.recommendedSection.items;
    emit(
      state.copyWith(
        recommendedSection: HomeSectionState.loading(
          previousItems: previousItems,
        ),
      ),
    );

    try {
      final page = await _getRecommendedCompaniesUseCase();
      emit(
        state.copyWith(
          recommendedSection: page.items.isEmpty
              ? const HomeSectionState.empty()
              : HomeSectionState.success(_limitedPreview(page.items)),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          recommendedSection: HomeSectionState.error(
            previousItems: previousItems,
          ),
        ),
      );
    }
  }

  Future<void> loadTrendingCompanies() async {
    final previousItems = state.trendingSection.items;
    emit(
      state.copyWith(
        trendingSection: HomeSectionState.loading(previousItems: previousItems),
      ),
    );

    try {
      final page = await _getTrendingCompaniesUseCase();
      emit(
        state.copyWith(
          trendingSection: page.items.isEmpty
              ? const HomeSectionState.empty()
              : HomeSectionState.success(_limitedPreview(page.items)),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          trendingSection: HomeSectionState.error(previousItems: previousItems),
        ),
      );
    }
  }

  Future<void> loadAllCompanies() async {
    final previousItems = state.allCompaniesSection.items;
    emit(
      state.copyWith(
        allCompaniesSection: HomeSectionState.loading(
          previousItems: previousItems,
        ),
      ),
    );

    try {
      final page = await _getAllCompaniesUseCase();
      emit(
        state.copyWith(
          allCompaniesSection: page.items.isEmpty
              ? const HomeSectionState.empty()
              : HomeSectionState.success(_limitedPreview(page.items)),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          allCompaniesSection: HomeSectionState.error(
            previousItems: previousItems,
          ),
        ),
      );
    }
  }

  List<CompanySummary> _limitedPreview(List<CompanySummary> items) {
    if (items.length <= _homePreviewLimit) {
      return items;
    }

    return items.take(_homePreviewLimit).toList(growable: false);
  }
}
