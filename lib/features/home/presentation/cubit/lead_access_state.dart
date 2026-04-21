import '../../../../core/session/session_state.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/use_cases/role_guard_use_cases.dart';

enum DiscoveryTab { home, chatbot, requests, offers, profile, settings }

enum SettingsDestination { unavailable, lead, customer }

class LeadAccessState {
  static const Object _unset = Object();

  final bool isLoading;
  final SessionRole role;
  final GuardDecision chatbotTabDecision;
  final GuardDecision requestsTabDecision;
  final GuardDecision offersTabDecision;
  final GuardDecision profileTabDecision;
  final GuardDecision requestActionDecision;

  const LeadAccessState({
    this.isLoading = true,
    this.role = SessionRole.guest,
    this.chatbotTabDecision = const GuardDecision.allow(),
    this.requestsTabDecision = const GuardDecision.allow(),
    this.offersTabDecision = const GuardDecision.allow(),
    this.profileTabDecision = const GuardDecision.allow(),
    this.requestActionDecision = const GuardDecision.allow(),
  });

  bool get isGuest => role == SessionRole.guest;

  bool get isLead => role == SessionRole.lead;

  bool get isCustomer => role == SessionRole.customer;

  bool get isAuthenticated => role != SessionRole.guest;

  SettingsDestination get settingsDestination {
    if (isLead) {
      return SettingsDestination.lead;
    }

    if (isCustomer) {
      return SettingsDestination.customer;
    }

    return SettingsDestination.unavailable;
  }

  bool get canAccessSettings =>
      settingsDestination != SettingsDestination.unavailable;

  bool shouldShowGuestOnboardingCta(DiscoveryTab tab) {
    return isGuest && isTabRestricted(tab);
  }

  bool shouldShowBrowseSecondaryAction(DiscoveryTab tab) {
    return isGuest && isTabRestricted(tab);
  }

  bool isTabRestricted(DiscoveryTab tab) {
    switch (tab) {
      case DiscoveryTab.home:
        return false;
      case DiscoveryTab.chatbot:
        return !chatbotTabDecision.allowed;
      case DiscoveryTab.requests:
        return !requestsTabDecision.allowed;
      case DiscoveryTab.offers:
        return !offersTabDecision.allowed;
      case DiscoveryTab.profile:
        return !profileTabDecision.allowed;
      case DiscoveryTab.settings:
        return !canAccessSettings;
    }
  }

  GuardDecision? guardDecisionForTab(DiscoveryTab tab) {
    switch (tab) {
      case DiscoveryTab.home:
        return null;
      case DiscoveryTab.chatbot:
        return chatbotTabDecision;
      case DiscoveryTab.requests:
        return requestsTabDecision;
      case DiscoveryTab.offers:
        return offersTabDecision;
      case DiscoveryTab.profile:
        return profileTabDecision;
      case DiscoveryTab.settings:
        return profileTabDecision;
    }
  }

  RestrictionScope? restrictionScopeForTab(DiscoveryTab tab) {
    switch (tab) {
      case DiscoveryTab.home:
        return null;
      case DiscoveryTab.chatbot:
        return RestrictionScope.chatbotTab;
      case DiscoveryTab.requests:
        return RestrictionScope.requestsTab;
      case DiscoveryTab.offers:
        return RestrictionScope.offersTab;
      case DiscoveryTab.profile:
        return RestrictionScope.profileTab;
      case DiscoveryTab.settings:
        return RestrictionScope.profileTab;
    }
  }

  LeadAccessState copyWith({
    bool? isLoading,
    SessionRole? role,
    Object? chatbotTabDecision = _unset,
    Object? requestsTabDecision = _unset,
    Object? offersTabDecision = _unset,
    Object? profileTabDecision = _unset,
    Object? requestActionDecision = _unset,
  }) {
    return LeadAccessState(
      isLoading: isLoading ?? this.isLoading,
      role: role ?? this.role,
      chatbotTabDecision: identical(chatbotTabDecision, _unset)
          ? this.chatbotTabDecision
          : chatbotTabDecision as GuardDecision,
      requestsTabDecision: identical(requestsTabDecision, _unset)
          ? this.requestsTabDecision
          : requestsTabDecision as GuardDecision,
      offersTabDecision: identical(offersTabDecision, _unset)
          ? this.offersTabDecision
          : offersTabDecision as GuardDecision,
      profileTabDecision: identical(profileTabDecision, _unset)
          ? this.profileTabDecision
          : profileTabDecision as GuardDecision,
      requestActionDecision: identical(requestActionDecision, _unset)
          ? this.requestActionDecision
          : requestActionDecision as GuardDecision,
    );
  }
}
