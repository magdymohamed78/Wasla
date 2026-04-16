export '../../../../core/types/load_status.dart';

enum TrendDirection { improving, declining, neutral }

enum ServiceFilterOption {
  allServices,
  move,
  cleaning,
  disposal,
  packing,
  unpacking,
  storage,
  transport,
}

enum RestrictionScope { requestAction, requestsTab, offersTab, profileTab }
