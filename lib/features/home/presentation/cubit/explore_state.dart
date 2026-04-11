import '../../domain/entities/discovery_types.dart';

class ExploreState {
  final String companyQuery;
  final String cityQuery;
  final ServiceFilterOption selectedService;
  final int criteriaVersion;

  const ExploreState({
    this.companyQuery = '',
    this.cityQuery = '',
    this.selectedService = ServiceFilterOption.allServices,
    this.criteriaVersion = 0,
  });

  bool get hasActiveCriteria {
    return companyQuery.trim().isNotEmpty ||
        cityQuery.trim().isNotEmpty ||
        selectedService != ServiceFilterOption.allServices;
  }

  ExploreState copyWith({
    String? companyQuery,
    String? cityQuery,
    ServiceFilterOption? selectedService,
    int? criteriaVersion,
  }) {
    return ExploreState(
      companyQuery: companyQuery ?? this.companyQuery,
      cityQuery: cityQuery ?? this.cityQuery,
      selectedService: selectedService ?? this.selectedService,
      criteriaVersion: criteriaVersion ?? this.criteriaVersion,
    );
  }
}
