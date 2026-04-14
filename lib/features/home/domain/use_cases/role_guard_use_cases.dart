import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_state.dart';
import '../entities/discovery_types.dart';

enum GuardReason { unauthenticated, leadRestricted, invalidCompanyContext }

class RestrictionModalModel {
  final String titleKey;
  final String messageKey;
  final String primaryLabelKey;
  final String secondaryLabelKey;
  final String primaryRoute;

  const RestrictionModalModel({
    required this.titleKey,
    required this.messageKey,
    required this.primaryLabelKey,
    required this.secondaryLabelKey,
    required this.primaryRoute,
  });
}

class GuardDecision {
  final bool allowed;
  final GuardReason? reason;
  final String? fallbackRoute;
  final RestrictionModalModel? modal;

  const GuardDecision._({
    required this.allowed,
    this.reason,
    this.fallbackRoute,
    this.modal,
  });

  const GuardDecision.allow() : this._(allowed: true);

  const GuardDecision.deny({
    required GuardReason reason,
    required String fallbackRoute,
    RestrictionModalModel? modal,
  }) : this._(
         allowed: false,
         reason: reason,
         fallbackRoute: fallbackRoute,
         modal: modal,
       );
}

class RoleGuardUseCases {
  const RoleGuardUseCases();

  GuardDecision guardGuestSignInEntry({required SessionRole role}) {
    if (role == SessionRole.guest) {
      return GuardDecision.deny(
        reason: GuardReason.unauthenticated,
        fallbackRoute: AppRouter.onboarding,
        modal: _guestSignInModal(),
      );
    }

    return const GuardDecision.allow();
  }

  GuardDecision guardTabAccess({
    required SessionRole role,
    required RestrictionScope scope,
  }) {
    switch (scope) {
      case RestrictionScope.requestsTab:
      case RestrictionScope.offersTab:
        if (role == SessionRole.customer) {
          return const GuardDecision.allow();
        }

        if (role == SessionRole.lead) {
          return const GuardDecision.deny(
            reason: GuardReason.leadRestricted,
            fallbackRoute: AppRouter.home,
          );
        }

        return GuardDecision.deny(
          reason: GuardReason.unauthenticated,
          fallbackRoute: AppRouter.home,
          modal: _guestSignInModal(),
        );
      case RestrictionScope.profileTab:
        if (role == SessionRole.guest) {
          return GuardDecision.deny(
            reason: GuardReason.unauthenticated,
            fallbackRoute: AppRouter.home,
            modal: _guestSignInModal(),
          );
        }

        return const GuardDecision.allow();
      case RestrictionScope.requestAction:
        return const GuardDecision.allow();
    }
  }

  GuardDecision guardRequestServiceAction({
    required SessionRole role,
    required int? companyId,
  }) {
    if (companyId == null || companyId <= 0) {
      return const GuardDecision.deny(
        reason: GuardReason.invalidCompanyContext,
        fallbackRoute: AppRouter.home,
      );
    }

    if (role == SessionRole.guest) {
      return GuardDecision.deny(
        reason: GuardReason.unauthenticated,
        fallbackRoute: AppRouter.onboarding,
        modal: _guestSignInModal(),
      );
    }

    return const GuardDecision.allow();
  }

  RestrictionModalModel _guestSignInModal() {
    return const RestrictionModalModel(
      titleKey: 'requestFlowContinuePromptTitle',
      messageKey: 'requestFlowContinuePromptMessage',
      primaryLabelKey: 'restrictionContinue',
      secondaryLabelKey: 'restrictionCancel',
      primaryRoute: AppRouter.onboarding,
    );
  }
}
