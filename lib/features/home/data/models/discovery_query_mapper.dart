import '../../domain/entities/discovery_types.dart';

class DiscoveryQueryMapper {
  static String? mapServiceFilter(ServiceFilterOption option) {
    switch (option) {
      case ServiceFilterOption.allServices:
        return null;
      case ServiceFilterOption.move:
        return 'Moving';
      case ServiceFilterOption.cleaning:
        return 'Cleaning';
      case ServiceFilterOption.disposal:
        return 'Disposal';
      case ServiceFilterOption.packing:
        return 'Packing';
      case ServiceFilterOption.unpacking:
        return 'Unpacking';
      case ServiceFilterOption.storage:
        return 'Storage';
      case ServiceFilterOption.transport:
        return 'Transport';
    }
  }

  static Map<String, dynamic> companiesQuery({
    required int pageIndex,
    required int pageSize,
    String? search,
    String? city,
    ServiceFilterOption service = ServiceFilterOption.allServices,
    String sortBy = 'rating',
  }) {
    final query = <String, dynamic>{
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'sortBy': sortBy,
    };

    final normalizedSearch = _normalize(search);
    final normalizedCity = _normalize(city);
    final mappedService = mapServiceFilter(service);

    if (normalizedSearch != null) {
      query['search'] = normalizedSearch;
    }
    if (normalizedCity != null) {
      query['city'] = normalizedCity;
    }
    if (mappedService != null) {
      query['serviceType'] = mappedService;
    }

    return query;
  }

  static Map<String, dynamic> recommendedQuery({
    required int pageIndex,
    required int pageSize,
    ServiceFilterOption service = ServiceFilterOption.allServices,
  }) {
    final query = <String, dynamic>{
      'PageIndex': pageIndex,
      'PageSize': pageSize,
    };

    final mappedService = mapServiceFilter(service);
    if (mappedService != null) {
      query['ServiceType'] = mappedService;
    }

    return query;
  }

  static Map<String, dynamic> trendingQuery({
    required int pageIndex,
    required int pageSize,
    ServiceFilterOption service = ServiceFilterOption.allServices,
  }) {
    return recommendedQuery(
      pageIndex: pageIndex,
      pageSize: pageSize,
      service: service,
    );
  }

  static Map<String, dynamic> reviewsQuery({
    required int pageIndex,
    required int pageSize,
  }) {
    return <String, dynamic>{'pageIndex': pageIndex, 'pageSize': pageSize};
  }

  static String? _normalize(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
