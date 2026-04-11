import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/company_summary.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/entities/explore_pagination.dart';
import '../../domain/use_cases/discovery_use_cases.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  static const int defaultPageSize = 12;
  static const Duration _searchDebounceDuration = Duration(milliseconds: 300);
  static const String _searchDebounceTag = 'explore-search-debounce';

  final GetAllCompaniesUseCase _getAllCompaniesUseCase;
  int _latestRequestId = 0;

  ExploreCubit({required GetAllCompaniesUseCase getAllCompaniesUseCase})
    : _getAllCompaniesUseCase = getAllCompaniesUseCase,
      super(const ExploreState());

  void onCompanyQueryChanged(String value) {
    if (value == state.companyQuery) {
      return;
    }

    emit(state.copyWith(companyQuery: value));
    _debounceCriteriaUpdate();
  }

  void onCityQueryChanged(String value) {
    if (value == state.cityQuery) {
      return;
    }

    emit(state.copyWith(cityQuery: value));
    _debounceCriteriaUpdate();
  }

  void onServiceSelected(ServiceFilterOption option) {
    if (option == state.selectedService) {
      return;
    }

    EasyDebounce.cancel(_searchDebounceTag);
    _applyCriteria(selectedService: option);
  }

  void clearFilters() {
    EasyDebounce.cancel(_searchDebounceTag);
    _applyCriteria(
      companyQuery: '',
      cityQuery: '',
      selectedService: ServiceFilterOption.allServices,
    );
  }

  Future<DiscoveryPage<CompanySummary>?> fetchPage({
    required int pageIndex,
    required int criteriaVersion,
  }) async {
    final requestId = ++_latestRequestId;
    final normalizedCompanyQuery = _normalizeQuery(state.companyQuery);
    final normalizedCityQuery = _normalizeQuery(state.cityQuery);

    final page = await _getAllCompaniesUseCase(
      pageIndex: pageIndex,
      pageSize: defaultPageSize,
      search: normalizedCompanyQuery,
      city: normalizedCityQuery,
      service: state.selectedService,
      sortBy: 'rating',
    );

    if (criteriaVersion != state.criteriaVersion) {
      return null;
    }

    if (requestId != _latestRequestId) {
      return null;
    }

    return page;
  }

  void _debounceCriteriaUpdate() {
    EasyDebounce.debounce(_searchDebounceTag, _searchDebounceDuration, () {
      if (isClosed) {
        return;
      }
      _applyCriteria();
    });
  }

  void _applyCriteria({
    String? companyQuery,
    String? cityQuery,
    ServiceFilterOption? selectedService,
  }) {
    final nextCompanyQuery = companyQuery ?? state.companyQuery;
    final nextCityQuery = cityQuery ?? state.cityQuery;
    final nextService = selectedService ?? state.selectedService;

    emit(
      state.copyWith(
        companyQuery: nextCompanyQuery,
        cityQuery: nextCityQuery,
        selectedService: nextService,
        criteriaVersion: state.criteriaVersion + 1,
      ),
    );
  }

  String? _normalizeQuery(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  @override
  Future<void> close() {
    EasyDebounce.cancel(_searchDebounceTag);
    return super.close();
  }
}
