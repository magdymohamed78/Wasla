import 'discovery_types.dart';

class ExploreCriteria {
  final String searchText;
  final String cityQuery;
  final ServiceFilterOption selectedService;
  final int pageIndex;
  final int pageSize;

  const ExploreCriteria({
    this.searchText = '',
    this.cityQuery = '',
    this.selectedService = ServiceFilterOption.allServices,
    this.pageIndex = 1,
    this.pageSize = 12,
  });
}
