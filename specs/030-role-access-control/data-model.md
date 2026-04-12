# Data Model: User Roles and Access Control System

## Entity: SessionUser
- Purpose: Canonical authenticated identity payload persisted after login/refresh.
- Source contract: `AuthResultDto` from Swagger.
- Fields:
  - `token: String`
  - `refreshToken: String`
  - `refreshTokenExpiry: DateTime`
  - `userId: int`
  - `leadId: int?`
  - `customerId: int?`
  - `firstName: String?`
  - `lastName: String?`
  - `email: String?`
  - `digitalSignature: String?`

## Entity: SessionRole
- Purpose: Derived access role used by guards and navigation.
- Allowed values:
  - `guest`
  - `lead`
  - `customer`
- Resolution rules:
  - `guest` when token absent
  - `lead` when token present and `customerId == null`
  - `customer` when token present and `customerId != null` (including 0)

## Entity: SessionState
- Purpose: Global session source of truth owned by SessionCubit.
- Fields:
  - `user: SessionUser?`
  - `role: SessionRole`
  - `isRefreshingToken: bool`
  - `refreshAttemptCount: int` (per failing protected action; max 1)
  - `lastAuthError: String?`
  - `pendingIntent: PendingIntent?`

## Entity: PendingIntent
- Purpose: Persist continuation of interrupted Request Service flow.
- Fields:
  - `action: PendingActionType` (must be `requestService` in this phase)
  - `companyId: int`
  - `createdAt: DateTime`
  - `sourceRoute: String?`
- Persistence: mandatory when auth interruption occurs during Request Service continuation.

## Entity: RoleNavigationModel
- Purpose: Deterministic menu composition and routing per role.
- Fields:
  - `role: SessionRole`
  - `items: List<NavigationItem>`
- NavigationItem fields:
  - `id: String`
  - `label: String`
  - `route: String`
  - `kind: NavigationItemKind` (`direct`, `dropdown`)
  - `dropdownOptions: List<NavigationOption>` (for Companies)

## Entity: NavigationOption
- Purpose: Dropdown destinations for Companies navigation.
- Fields:
  - `id: String` (`all`, `recommended`, `trending`)
  - `label: String`
  - `route: String`

## Entity: GuardDecision
- Purpose: Encapsulates result of access check before navigation/action.
- Fields:
  - `allowed: bool`
  - `reason: GuardReason?`
  - `fallbackRoute: String?`
  - `modal: RestrictionModalModel?`

## Entity: RestrictionModalModel
- Purpose: Reusable modal payload for blocked actions.
- Fields:
  - `title: String`
  - `message: String`
  - `primaryLabel: String`
  - `secondaryLabel: String`
  - `primaryRoute: String`

## Entity: RestrictedEmptyStateModel
- Purpose: Shared restricted-content representation.
- Fields:
  - `iconAsset: String?`
  - `message: String`
  - `ctaLabel: String`
  - `ctaRoute: String`

## Entity: ServiceRequestIntent
- Purpose: Navigation and submission context for New Service Request.
- Fields:
  - `companyId: int`
  - `initiatorRole: SessionRole`
  - `resumedFromPendingIntent: bool`

## Entity: ServiceRequestDraft
- Purpose: Placeholder form state for this phase while staying API-contract compatible.
- Fields:
  - `companyId: int`
  - `payload: Map<String, dynamic>` (must conform to Swagger `CreateServiceRequestDto`)
  - `isSubmitting: bool`
  - `submitError: String?`

## Entity: RefreshRecoveryState
- Purpose: Tracks one-attempt refresh policy for protected action failures.
- Fields:
  - `originalActionId: String`
  - `attempted: bool`
  - `succeeded: bool?`
  - `failureReason: String?`

## Relationships
- `SessionState.user` derives `SessionState.role` through role resolver.
- `SessionRole` drives `RoleNavigationModel` selection.
- Guard checks produce `GuardDecision` for both tab navigation and Request Service action.
- Auth interruption creates/updates `PendingIntent`; post-login continuation materializes `ServiceRequestIntent`.
- Request form uses `ServiceRequestDraft`, then submits to `/api/customer-portal/service-requests`.

## State Transitions
- `guest -> lead`: successful login with token and null/missing customerId.
- `guest -> customer`: successful login with token and non-null customerId.
- `lead -> customer`: re-login or refresh returns non-null customerId.
- `lead|customer -> guest`: logout or refresh failure after single retry.

## Validation Rules
- `companyId` is required and must be a positive integer before opening/submitting Request Service.
- `PendingIntent.action` must be `requestService` for this feature scope.
- `PendingIntent.companyId` must be present to resume flow; otherwise route to safe default (Home).
- `refreshAttemptCount` must never exceed 1 for a single failing protected action.
- `RoleNavigationModel` must match role exactly and not expose forbidden destinations.
