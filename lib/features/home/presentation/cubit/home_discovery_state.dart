import '../../domain/entities/company_summary.dart';
import '../../domain/entities/discovery_types.dart';

class HomeSectionState {
  final LoadStatus status;
  final List<CompanySummary> items;
  final String? errorMessage;

  const HomeSectionState._({
    required this.status,
    required this.items,
    this.errorMessage,
  });

  const HomeSectionState.initial()
    : this._(status: LoadStatus.initial, items: const <CompanySummary>[]);

  const HomeSectionState.loading({
    List<CompanySummary> previousItems = const <CompanySummary>[],
  }) : this._(status: LoadStatus.loading, items: previousItems);

  HomeSectionState.success(List<CompanySummary> nextItems)
    : this._(
        status: LoadStatus.success,
        items: List<CompanySummary>.unmodifiable(nextItems),
      );

  const HomeSectionState.empty()
    : this._(status: LoadStatus.empty, items: const <CompanySummary>[]);

  const HomeSectionState.error({
    String? message,
    List<CompanySummary> previousItems = const <CompanySummary>[],
  }) : this._(
         status: LoadStatus.error,
         items: previousItems,
         errorMessage: message,
       );
}

class HomeDiscoveryState {
  final HomeSectionState recommendedSection;
  final HomeSectionState trendingSection;
  final HomeSectionState allCompaniesSection;

  const HomeDiscoveryState({
    this.recommendedSection = const HomeSectionState.initial(),
    this.trendingSection = const HomeSectionState.initial(),
    this.allCompaniesSection = const HomeSectionState.initial(),
  });

  HomeDiscoveryState copyWith({
    HomeSectionState? recommendedSection,
    HomeSectionState? trendingSection,
    HomeSectionState? allCompaniesSection,
  }) {
    return HomeDiscoveryState(
      recommendedSection: recommendedSection ?? this.recommendedSection,
      trendingSection: trendingSection ?? this.trendingSection,
      allCompaniesSection: allCompaniesSection ?? this.allCompaniesSection,
    );
  }
}
