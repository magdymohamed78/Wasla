import '../../domain/entities/discovery_types.dart';

enum DiscoveryTab { home, requests, offers, profile }

class LeadAccessState {
  static const Object _unset = Object();

  final bool isLoading;
  final bool isAuthenticated;
  final int? leadId;
  final int? customerId;

  const LeadAccessState({
    this.isLoading = true,
    this.isAuthenticated = false,
    this.leadId,
    this.customerId,
  });

  bool get isLeadContext => customerId == null;

  bool get requiresRestrictionView => isLeadContext;

  bool isTabRestricted(DiscoveryTab tab) {
    if (tab == DiscoveryTab.home) {
      return false;
    }
    return requiresRestrictionView;
  }

  RestrictionScope? restrictionScopeForTab(DiscoveryTab tab) {
    switch (tab) {
      case DiscoveryTab.home:
        return null;
      case DiscoveryTab.requests:
        return RestrictionScope.requestsTab;
      case DiscoveryTab.offers:
        return RestrictionScope.offersTab;
      case DiscoveryTab.profile:
        return RestrictionScope.profileTab;
    }
  }

  LeadAccessState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Object? leadId = _unset,
    Object? customerId = _unset,
  }) {
    return LeadAccessState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      leadId: identical(leadId, _unset) ? this.leadId : leadId as int?,
      customerId: identical(customerId, _unset)
          ? this.customerId
          : customerId as int?,
    );
  }
}
