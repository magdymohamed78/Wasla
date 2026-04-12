# Feature Specification: User Roles & Access Control System

**Feature Branch**: `feature/030-role-access-control`  
**Created**: 2026-04-12  
**Status**: Draft  
**Input**: User description: "Project: User Roles & Access Control System"

## Clarifications

### Session 2026-04-12

- Q: When token exists, how should customer vs lead be resolved from customerId? → A: Customer if customerId is any non-null value (including 0).
- Q: On 401 or expired token during protected actions, what should session behavior be? → A: Attempt one refresh-token retry; continue action if refresh succeeds, otherwise fallback to Guest and prompt login.
- Q: Should service-request submission behavior differ between Lead and Customer? → A: Lead and Customer both submit to `/api/customer-portal/service-requests` and navigate to Requests on success.
- Q: Should pendingAction/pendingCompanyId be optional or mandatory after auth interruption? → A: Mandatory; always store and resume Request Service after successful login when context is valid.
- Q: Should Settings destinations be role-specific endpoints for Lead and Customer? → A: Yes; Lead uses `/my/lead-settings` and Customer uses `/my/settings`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Guest Browsing with Guided Restrictions (Priority: P1)

As a guest user (not logged in), I want to browse companies while receiving clear guidance when I try restricted actions, so I can continue exploring without confusion and know how to unlock full access.

**Why this priority**: Guest behavior is the first-touch journey and must avoid hard blockers while guiding users toward onboarding and authentication.

**Independent Test**: Open the app with no stored token, browse companies/details/reviews, trigger Request Service, and attempt restricted destinations to verify guidance and CTAs.

**Acceptance Scenarios**:

1. **Given** no token is present in secure storage, **When** the app resolves session state, **Then** the user role is Guest.
2. **Given** the Guest user is on Company Details, **When** they tap Request Service, **Then** a centered restriction modal appears with message "Please login or register to continue", Continue, and Cancel actions.
3. **Given** the restriction modal is visible for a Guest user, **When** Continue is tapped, **Then** the app navigates to the onboarding screen.
4. **Given** the Guest role is active, **When** bottom navigation renders, **Then** only Companies and Sign In actions are shown.
5. **Given** the Guest user taps Sign In from bottom navigation, **When** navigation executes, **Then** the app routes to onboarding.

---

### User Story 2 - Lead Request Submission and Conversion Prompt (Priority: P1)

As a lead user (logged in with customerId equal to null), I want to submit a service request and then be prompted to re-login, so my account can transition to customer access.

**Why this priority**: The Lead to Customer transition is the core business conversion flow and directly impacts access to Requests and Offers.

**Independent Test**: Login with customerId equal to null, open Company Details, start New Service Request, submit request, verify re-login prompt and role transition after successful login.

**Acceptance Scenarios**:

1. **Given** token exists and customerId equals null, **When** session is resolved, **Then** role is Lead.
2. **Given** a Lead user taps Request Service from Company Details, **When** the action is triggered, **Then** navigation goes directly to New Service Request with companyId.
3. **Given** Lead is on New Service Request, **When** form fields are submitted successfully, **Then** the request is sent to `/api/customer-portal/service-requests` and a modal appears with message "Please login again to continue".
4. **Given** the re-login modal is shown after Lead submission, **When** Continue is tapped and login succeeds with any non-null customerId (including 0), **Then** the role updates to Customer and protected tabs become available.

---

### User Story 3 - Customer Full Access and Direct Service Requests (Priority: P1)

As a customer (logged in with any non-null customerId, including 0), I want unrestricted access to Requests and offers and a direct request flow, so I can manage ongoing service activity.

**Why this priority**: Customer role is the fully unlocked state and must provide complete value without friction.

**Independent Test**: Login with any non-null customerId (including 0), validate tab access, submit a request from Company Details, and verify post-submit navigation.

**Acceptance Scenarios**:

1. **Given** token exists and customerId is any non-null value (including 0), **When** session is resolved, **Then** role is Customer.
2. **Given** Customer opens Companies, Requests, Offers, Profile, and Settings destinations, **When** each destination loads, **Then** content is accessible without restriction empty states.
3. **Given** Customer taps Request Service from Company Details, **When** action is triggered, **Then** app navigates directly to New Service Request with companyId.
4. **Given** Customer submits New Service Request successfully, **When** submit action sends to `/api/customer-portal/service-requests`, **Then** app navigates to Requests (Services) page.

---

### User Story 4 - Dynamic Navigation and Company Discovery Entry Points (Priority: P2)

As any user role, I want bottom navigation, company discovery entry points, and listing search behavior to react to my role and selected context, so I can navigate clearly without dead ends.

**Why this priority**: Dynamic navigation and clear entry points reduce confusion and are central to role-aware UX.

**Independent Test**: Transition from Guest to Lead to Customer and verify bottom navigation composition, Companies dropdown behavior, Home section subset behavior, View All pages, and search-bar routing to Explore.

**Acceptance Scenarios**:

1. **Given** role changes during runtime, **When** session state updates, **Then** bottom navigation composition updates immediately without app restart.
2. **Given** user taps Companies in bottom navigation, **When** dropdown opens, **Then** options All Companies, Recommended, and Trending are available and selectable.
3. **Given** user taps Settings from bottom navigation, **When** role is Lead, **Then** app navigates to `/my/lead-settings`; and **When** role is Customer, **Then** app navigates to `/my/settings`.
4. **Given** Home screen sections are visible, **When** data is loaded, **Then** each section shows a limited subset and includes View All navigation for its full listing page.
5. **Given** user opens All Companies, Recommended, or Trending listing pages, **When** screen renders, **Then** each page includes a search bar at the top.
6. **Given** user taps the search bar on a company listing page, **When** navigation executes, **Then** app opens Explore where company and city search results are shown.
7. **Given** restriction modals are shown anywhere in flow, **When** they render, **Then** they use the reusable centered modal pattern with blurred background and primary/secondary actions.

### Edge Cases

- Secure storage token is missing, expired, or removed while app is running; app attempts one refresh when applicable, then reverts safely to Guest if refresh fails.
- Authentication response returns customerId as missing; default role remains Lead-equivalent (non-customer) until a non-null customerId is received.
- Lead submits request, receives re-login prompt, then taps Cancel; current screen remains stable and restricted destination behavior stays unchanged.
- Lead opens Requests or Offers before conversion through direct route access; empty state guidance is shown with CTA to Home.
- Guest repeatedly attempts restricted destinations via direct navigation; guidance remains deterministic and does not stack duplicate modals.
- Pending action is stored but pendingCompanyId is unavailable; app resumes safely without unintended navigation.
- Service request submission fails; user receives actionable feedback and remains on New Service Request page.
- Home section has fewer items than the limited subset threshold; screen shows available items and keeps View All behavior deterministic.
- Companies dropdown is opened repeatedly across roles; visible options always remain All Companies, Recommended, and Trending.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST resolve user role using the following logic: no token -> Guest, token with customerId null or missing -> Lead, token with any non-null customerId value (including 0) -> Customer.
- **FR-002**: The app MUST support exactly three role states in this phase: Guest, Lead, Customer.
- **FR-003**: Bottom navigation MUST be dynamic and role-based rather than fixed.
- **FR-004**: Guest bottom navigation MUST include Companies and Sign In only.
- **FR-005**: Guest Sign In action MUST navigate to onboarding.
- **FR-006**: Lead bottom navigation MUST include Companies, Profile, and Settings.
- **FR-007**: Lead Profile destination MUST route to `/my/lead-profile`.
- **FR-007a**: Lead Settings destination MUST route to `/my/lead-settings`.
- **FR-008**: Customer bottom navigation MUST include Companies, Requests, Offers, Profile, and Settings.
- **FR-009**: Customer Profile destination MUST route to `/my/profile`.
- **FR-009a**: Customer Settings destination MUST route to `/my/settings`.
- **FR-010**: Companies bottom-navigation item MUST open a dropdown menu.
- **FR-011**: Companies dropdown menu MUST include All Companies, Recommended, and Trending options.
- **FR-012**: Selecting a Companies dropdown option MUST navigate to its corresponding company listing page.
- **FR-013**: Home MUST display three company sections: All Companies, Recommended, and Trending.
- **FR-014**: Each Home section MUST display a limited subset of available items (for example, 3 of 5 when available).
- **FR-015**: Each Home section MUST provide a View All action that opens a dedicated full-list page for that section.
- **FR-016**: All company listing pages (All Companies, Recommended, Trending) MUST include a top search bar.
- **FR-017**: Tapping the search bar on any company listing page MUST navigate to Explore.
- **FR-018**: Explore MUST provide company-name search, city search, and results display.
- **FR-019**: Guest users MUST be able to browse companies, company details, and reviews.
- **FR-020**: The Company Details screen MUST expose a Request Service button as the primary action at the bottom.
- **FR-021**: Tapping Request Service as Guest MUST show a restriction modal with message "Please login or register to continue" and actions Continue and Cancel.
- **FR-022**: Continue from Guest restriction modal MUST route to onboarding.
- **FR-023**: Tapping Request Service as Lead MUST navigate directly to New Service Request and MUST pass companyId.
- **FR-024**: Tapping Request Service as Customer MUST navigate directly to New Service Request and MUST pass companyId.
- **FR-025**: New Service Request screen in this phase MUST act as a navigation-validation placeholder with title "New Service Request".
- **FR-026**: New Service Request screen MUST accept companyId as an input parameter.
- **FR-027**: New Service Request screen MUST display basic form UI fields consistent with provided design intent.
- **FR-028**: Advanced validation and full form implementation MUST remain out of scope for this phase.
- **FR-029**: Lead and Customer users MUST be able to submit New Service Request to `/api/customer-portal/service-requests` using the passed companyId context.
- **FR-030**: After successful Lead request submission, the app MUST show modal message "Please login again to continue" with actions Continue and Cancel.
- **FR-031**: Continue from Lead post-submit modal MUST route to Login.
- **FR-032**: After successful re-login, if customerId becomes non-null (including 0), role MUST transition to Customer immediately.
- **FR-033**: After transition to Customer, Requests and Offers MUST become accessible without additional manual refresh.
- **FR-034**: If Guest or Lead reaches a restricted destination through direct access, an empty state MUST show clear guidance and CTA.
- **FR-035**: Restricted empty states MUST include an illustration or icon, clear message, and a CTA button.
- **FR-036**: Same browsing APIs for companies and details MUST remain available across all roles; only restricted content and actions vary by role.
- **FR-037**: Role-based guard behavior MUST be consistent for entry points from Home and Explore to Company Details Request Service action.
- **FR-038**: UX transitions between Guest, Lead, and Customer MUST be smooth and free from contradictory tab states.
- **FR-039**: On protected-action authorization failure (401 or expired access token), the system MUST attempt exactly one refresh-token flow before deciding fallback behavior.
- **FR-040**: If refresh succeeds, the system MUST continue the in-progress protected action without forcing manual re-navigation.
- **FR-041**: If refresh fails, the system MUST clear authenticated session state, fallback to Guest permissions, and prompt the user to login.

### Session and State Requirements

- **SH-001**: A global SessionCubit MUST be the source of truth for current user and resolved role.
- **SH-002**: SessionCubit MUST load and persist user/session data through secure storage.
- **SH-003**: SessionCubit MUST expose operations for login, logout, and session refresh/update.
- **SH-004**: Session updates MUST trigger reactive UI updates across app shell, tabs, and guarded flows.
- **SH-005**: Role resolver helper MUST be centralized and reused consistently by guards and navigation decisions.
- **SH-006**: Request guard logic MUST evaluate role before navigating to restricted destinations.
- **SH-007**: Session state MUST store `pendingAction=requestService` and `pendingCompanyId` whenever authentication interrupts Request Service continuation.
- **SH-008**: After successful login, the app MUST resume the persisted Request Service intent when context is valid.
- **SH-009**: If pending intent context is invalid or stale, the app MUST fall back to a safe default destination without crash.
- **SH-010**: App shell navigation model MUST recompute immediately when role changes and show the correct role-specific menu entries.
- **SH-011**: Companies dropdown interaction state MUST remain deterministic and route to the selected listing destination without stale role leakage.
- **SH-012**: Session manager MUST coordinate a single in-flight refresh attempt for a failing protected action to avoid duplicate refresh races.
- **SH-013**: After refresh failure, pending protected actions MUST be cancelled safely while preserving pending intent for post-login continuation.

### Reusable UX Component Requirements

- **UX-001**: RestrictionModal component MUST support title, message, primary action, and secondary action.
- **UX-002**: RestrictionModal MUST render centered with blurred background overlay.
- **UX-003**: EmptyStateWidget MUST be reusable across restricted tab content.
- **UX-004**: EmptyStateWidget MUST support icon/illustration, message text, and CTA action.
- **UX-005**: Restricted tab screens MUST use the shared EmptyStateWidget rather than ad-hoc screen variants.

### Architecture Requirements

- **AR-001**: Role and permission decisions MUST be handled outside the UI layer.
- **AR-002**: UI layer MUST consume role/session state and render declaratively without embedding business rules.
- **AR-003**: Guarding logic for restricted tabs and request actions MUST be centralized and reusable.
- **AR-004**: Navigation outcomes for restricted actions MUST be deterministic for each role.
- **AR-005**: Session and role model MUST include fields from authentication response required for role resolution and UX flow continuity.

### API and Contract Expectations

- **API-001**: Authentication response contract MUST include token and a nullable customerId field needed for role resolution.
- **API-002**: Service request submission in this phase MUST use `/api/customer-portal/service-requests`.
- **API-003**: API behavior and request/response contracts for this feature MUST align with `swagger.json`.
- **API-004**: Both Lead and Customer role submissions MUST use the same service-request endpoint and success contract.

### Key Entities *(include if feature involves data)*

- **Session User**: Persisted authenticated user payload containing token, user identity, and customerId/leadId attributes used in role resolution.
- **Role State**: Computed access level (Guest, Lead, Customer) derived from session token presence and customerId value.
- **Role Navigation Model**: Role-dependent bottom navigation configuration that defines visible menu items, labels, and destinations for Guest, Lead, and Customer.
- **Guarded Destination**: A tab or action destination that is conditionally accessible depending on role.
- **Pending Intent**: Persisted continuation context (`pendingAction`, `pendingCompanyId`) that MUST be captured for interrupted Request Service flows and used to resume after login.
- **Restriction Modal Model**: UI model containing title, message, primary action, and secondary action for blocked actions.
- **Restricted Empty State Model**: UI model containing visual, explanatory message, and CTA destination for inaccessible tab content.

### Assumptions

- Requests and Services labels refer to the same destination area in this phase, and UX copy may use either term while mapping to one tab destination.
- Cancel action on restriction modals dismisses modal and keeps user on current screen unless explicit navigation is specified.
- Lead-to-Customer conversion occurs only after successful login response returns a non-null customerId.
- If login completes but customerId remains null, user remains Lead and restricted behavior stays active.
- Any non-null customerId value, including 0, is treated as Customer for role and permission decisions.
- Service-request submission behavior (endpoint and success navigation) is shared between Lead and Customer roles in this phase.
- Settings destination routes are role-specific: `/my/lead-settings` for Lead and `/my/settings` for Customer.
- Company listing pages for All Companies, Recommended, and Trending are distinct destinations that all delegate search intent to Explore.
- Service request placeholder form in this phase validates primary navigation and submission triggers, not full business validation rules.

### Out of Scope

- Deep-link handling for guarded destinations.
- Full advanced New Service Request form validation and complete production form behavior.
- Additional roles beyond Guest, Lead, and Customer.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of role resolution checks follow defined rules for Guest, Lead (customerId null/missing), and Customer (any non-null customerId including 0) across app launches and session refreshes.
- **SC-002**: 100% of bottom-navigation renders match the required role-specific menu configuration for Guest, Lead, and Customer.
- **SC-003**: 100% of Companies bottom-navigation taps expose the dropdown with All Companies, Recommended, and Trending options.
- **SC-004**: 100% of Home sections show limited subset behavior and provide a working View All destination.
- **SC-005**: 100% of All Companies, Recommended, and Trending screens show a top search bar that routes to Explore on tap.
- **SC-006**: 100% of Guest taps on Request Service show the login/register restriction modal with working Continue and Cancel actions.
- **SC-007**: At least 95% of Lead users can open New Service Request from Company Details with correct companyId context and submit the request flow.
- **SC-008**: At least 95% of Lead users who re-login with a non-null customerId (including 0) see immediate access to Customer navigation destinations in the same session.
- **SC-009**: 100% of protected-action 401 scenarios trigger no more than one refresh attempt and then follow deterministic outcomes: continue on success, Guest fallback with login prompt on failure.
- **SC-010**: At least 95% of Customer users can submit New Service Request through `/api/customer-portal/service-requests` and land on Requests on success.
- **SC-011**: 100% of auth-interrupted Request Service attempts persist pending intent and, after successful login with valid context, resume to the intended Request Service flow.
- **SC-012**: 100% of Settings navigations route to the correct role-specific destination (`/my/lead-settings` for Lead, `/my/settings` for Customer).
