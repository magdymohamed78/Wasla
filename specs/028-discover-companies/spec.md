# Feature Specification: Explore and Discover Companies for Leads

**Feature Branch**: `028-discover-companies`  
**Created**: 2026-04-11  
**Status**: Draft  
**Input**: User description: "Explore and Discover Companies for lead users in mobile app"

## Clarifications

### Session 2026-04-11

- Q: For Explore behavior, what does only one filter active at a time mean? → A: Only one service filter chip is active at once, while text search (name/city) can still be used simultaneously.
- Q: When Explore first opens or after clear filters, what should default results be? → A: Show first page from /api/customer-portal/companies using current service filter and empty text query.
- Q: If one Home section API fails while others succeed, what should be canonical? → A: Show inline error state only in failed section with Retry button and keep successful sections visible.
- Q: For company-details Request Service action, what is canonical gating behavior? → A: All lead users are blocked and always sent to onboarding/login, even if already authenticated.
- Q: For Explore city search, what should matching rule be? → A: Case-insensitive partial match (contains).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Discover Companies from Home (Priority: P1)

As a lead user with no company connection, I want to discover recommended, trending, and all companies from Home so I can quickly find a company worth contacting.

**Why this priority**: This is the first high-value interaction after app open and directly drives discovery and conversion to the next journey step.

**Independent Test**: Can be fully tested by opening Home as a lead user, validating section order and card content, and opening company details from each section.

**Acceptance Scenarios**:

1. **Given** the lead user opens Home, **When** the screen loads, **Then** the first visible element is the search bar with no greeting text and no settings or notification icons.
2. **Given** Home data is available, **When** the user scrolls, **Then** Recommended Companies, Trending Companies, and All Companies are displayed in that order with horizontal lists.
3. **Given** a company card is shown in any Home section, **When** the user taps the card, **Then** company details are opened for that selected company.
4. **Given** one Home section fails to load while others succeed, **When** Home renders, **Then** only the failed section shows an inline error with Retry and successful sections remain visible.

---

### User Story 2 - Search and Filter in Explore (Priority: P2)

As a lead user, I want fast search and a simple single-select service filter so I can narrow results without friction.

**Why this priority**: Search and filtering are core to findability and are required before a user decides to open a company profile.

**Independent Test**: Can be fully tested by opening Explore, typing search queries, changing service filters, clearing filters, and confirming result changes and empty states.

**Acceptance Scenarios**:

1. **Given** the user is on Explore, **When** they type in search input, **Then** results update dynamically after debounce and reflect matching company name or city, where city matching is case-insensitive partial contains.
2. **Given** a service filter is selected, **When** the filter changes, **Then** results refresh immediately, only one service filter remains active, and current text search criteria remain applied when present.
3. **Given** no companies match current criteria, **When** results are rendered, **Then** a centered empty-state card is shown with a clear-filters action that restores default results.

---

### User Story 3 - View Details and Handle Restricted Actions (Priority: P2)

As a lead user, I want complete company details and clear guidance when an action is restricted so I understand what to do next.

**Why this priority**: Company details and restriction handling are critical for trust and conversion into authentication/onboarding.

**Independent Test**: Can be fully tested by opening company details, verifying all sections, triggering restricted service-request action, and confirming redirection to onboarding flow.

**Acceptance Scenarios**:

1. **Given** the user opens company details, **When** details load successfully, **Then** header, contact info, services list, and reviews list are shown using available data.
2. **Given** the user is in lead state and attempts a service-request action, **When** the action is triggered, **Then** a restriction prompt card appears with continue action to onboarding/login regardless of current authentication state.
3. **Given** rating or services data is missing, **When** details are displayed, **Then** fallback content is shown without breaking layout.

---

### User Story 4 - Restrict Non-Eligible Bottom Tabs (Priority: P3)

As a lead user without company connection, I want protected tabs to explain why access is blocked and how to continue, instead of showing dead ends.

**Why this priority**: Prevents confusing failures and keeps users in the discovery journey.

**Independent Test**: Can be fully tested by tapping Requests, Offers, and Profile tabs in restricted state and validating full-screen restriction view and Browse Companies action.

**Acceptance Scenarios**:

1. **Given** a restricted lead user taps Requests, Offers, or Profile, **When** tab content opens, **Then** a full-screen restriction view is shown.
2. **Given** the restriction view is visible, **When** the user taps Browse Companies, **Then** navigation returns to Home discovery.

---

### Edge Cases

- No internet on Home or Explore shows connection message with retry and keeps the user on the same screen.
- One Home section fails while others succeed; only the failed section shows localized error with retry.
- Missing logo uses placeholder image and keeps card layout stable.
- Missing rating shows No reviews yet instead of numeric rating.
- Missing services hides service list/tags without empty visual clutter.
- User types quickly; debounce prevents excessive requests and only latest query result is rendered.
- Clearing search input and filter restores default Explore result set.
- Returning from onboarding should preserve or safely reset discovery state without crash.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Home MUST use a vertical scroll layout with the search bar as the first visible element.
- **FR-002**: Home MUST NOT display greeting text, settings icon, or notification icon.
- **FR-003**: Home search bar placeholder MUST be Search for services or companies and tapping it MUST navigate to Explore.
- **FR-004**: Home MUST display three company discovery sections in this order: Recommended Companies, Trending Companies, All Companies.
- **FR-005**: Each Home section MUST render as a horizontal list of company cards.
- **FR-006**: Recommended and Trending cards MUST include logo (with fallback), company name, city and country, average rating, review count, and service types.
- **FR-007**: All Companies cards MUST include logo (with fallback), company name, location, rating or fallback review text, and service types when available.
- **FR-008**: Tapping any company card on Home or Explore MUST open the corresponding company details view.
- **FR-009**: Explore search input placeholder MUST be Search companies.
- **FR-010**: Explore search MUST support company name and city manual text input.
- **FR-010a**: City search matching MUST use case-insensitive partial contains behavior.
- **FR-011**: Explore MUST provide a single-select service filter with options: All Services, Move, Cleaning, Disposal, Packing, Unpacking, Storage, Transport.
- **FR-011a**: Only one service filter option MAY be active at a time, and text search criteria MAY be applied simultaneously with the active service filter.
- **FR-012**: Search input changes MUST apply debounce of 300ms before requesting updated results.
- **FR-013**: Changing selected service filter MUST trigger immediate result refresh.
- **FR-014**: Clearing search input MUST reset results to default filtered-by-service state.
- **FR-014a**: On first open of Explore and after clear-filters action, results MUST load the first page from /api/customer-portal/companies using empty text query and the currently selected service filter.
- **FR-015**: Explore results MUST be shown as a vertical list of company cards.
- **FR-016**: Explore result cards MUST show logo fallback, name, rating value or No reviews yet, review count when available, and service tags when available.
- **FR-017**: Company details MUST include header (logo, name, rating), contact info, services list, and recent reviews list when data is present.
- **FR-018**: If a lead user attempts service-request action from discovery/details, UI MUST show restriction card with message Please login or register to continue and Continue button, regardless of current authentication state.
- **FR-019**: Continue action from restricted request card MUST navigate to onboarding/login flow.
- **FR-020**: Explore empty results MUST show centered card with No companies found, Try adjusting your search filters, and Clear filters action.
- **FR-021**: Clear filters action MUST reset search input and selected service filter to default and restore results.
- **FR-022**: Requests, Offers, and Profile tabs in restricted lead state MUST show full-screen restriction view with Browse Companies action.
- **FR-023**: Browse Companies action from restricted tab view MUST navigate to Home screen.
- **FR-024**: Discovery screens MUST follow existing design system tokens for colors, typography, spacing, and component behavior.
- **FR-025**: Discovery flow MUST preserve smooth scrolling and non-blocking transitions while data loads or updates.
- **FR-026**: Navigation to Company Details MUST use GoRouter with companyId as a route parameter.
- **FR-027**: Explore results MUST support paginated loading with infinite scroll.
- **FR-028**: Entire company card MUST be tappable as a single interaction surface.
- **FR-029**: Additional pages MUST be loaded automatically when the user scrolls near the end of the list (infinite scroll threshold).
- **FR-030**: Explore screen SHOULD show recent or default company results when no search input is provided.
### State Handling Requirements

- **SH-001**: Each Home section MUST manage its own loading, success, empty, and error states independently.
- **SH-001a**: If one Home section fails, only that section MUST display inline error with retry action, and other successful sections MUST remain visible and interactive.
- **SH-002**: Explore MUST manage independent state for search input, selected single service filter, and results list, MUST apply search text plus active service filter together when both are present, and MUST initialize to first-page default results using empty text query.
- **SH-003**: Search updates MUST render only the latest query response to avoid stale result flashes.
- **SH-004**: Retry actions in no-internet and section-level error states MUST re-request only the affected dataset.
- **SH-005**: Restriction-state rendering for bottom tabs and request-action prompts MUST be deterministic when user is in lead discovery context.
- **SH-006**: Home sections and Explore results MUST display skeleton loaders during initial and refresh loading states.
- **SH-007**: Previous in-flight search requests MUST be ignored or cancelled when a new search query is triggered.
- **SH-008**: Explore screen SHOULD preserve last search query and filter state when navigating back from company details.
- **SH-009**: Duplicate API requests for identical query and filter state MUST be avoided.
### API Integration Expectations

- **AI-001**: Recommended Companies data source MUST use /api/customer-portal/recommended-companies.
- **AI-002**: Trending Companies data source MUST use /api/customer-portal/trending-companies.
- **AI-003**: Explore and All Companies listing data source MUST use /api/customer-portal/companies with name, city, and service filter query support.
- **AI-004**: Company details data source MUST use /api/customer-portal/companies/{companyId}.
- **AI-005**: Company reviews shown in details MUST be sourced from company details payload and/or /api/customer-portal/companies/{companyId}/reviews when separate paging is needed.
- **AI-006**: Restricted request actions in lead context MUST route to onboarding that supports customer portal registration and login endpoints.
- **AI-007**: Service filter values MUST map exactly to backend serviceType values or use a defined mapping layer.

### Component Breakdown

- **CB-001**: Home discovery page containing search trigger and three horizontal section modules.
- **CB-002**: Reusable company summary card for Home and Explore contexts with configurable metadata visibility.
- **CB-003**: Explore search and single-select filter bar component.
- **CB-004**: Explore results list component with empty-state support.
- **CB-005**: Company details page sections: header, contact, services, reviews.
- **CB-006**: Restricted action prompt card component for request attempts.
- **CB-007**: Full-screen bottom-tab restriction view with Browse Companies action.
- **CB-008**: Section-level error and retry component reusable across Home sections.

### Key Entities *(include if feature involves data)*

- **Lead Discovery Context**: User state representing a lead with no active company connection, driving restricted behaviors and navigation.
- **Company Summary**: Lightweight company listing representation used for Home and Explore cards (logo, name, location, rating, review info, services).
- **Company Details View Model**: Full company profile representation for detail screen sections (identity, contact, services, reviews).
- **Explore Search Criteria**: Current search text plus active single service filter.
- **Section Load State**: Per-section loading, success, empty, and error status model.
- **Restriction State**: Access-control UI state for request actions and restricted bottom tabs.

### Assumptions

- Lead user for this feature includes unauthenticated app-open visitors and authenticated portal leads with no usable company-scoped customer context for restricted tabs.
- Request-action initiation from discovery/details is blocked in lead context and always routes to onboarding/login handoff.
- Trending indicator is shown when trend direction data is provided by backend; if unavailable, card remains valid without indicator.
- All textual labels in this feature will use current localization pipeline and existing language support.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 95% of lead users can reach Explore screen from Home search tap in a single interaction without navigation error.
- **SC-002**: At least 95% of typed Explore queries visibly refresh results within expected debounce behavior without duplicate stale renders.
- **SC-003**: 100% of restricted request attempts in lead context show the login/register prompt and Continue action.
- **SC-004**: 100% of restricted bottom-tab entries (Requests, Offers, Profile) show the full-screen restriction view and working Browse Companies action.
- **SC-005**: Section-level API failures do not block other Home sections in at least 99% of tested failure scenarios.
- **SC-006**: No layout overflow is observed across supported mobile screen sizes for Home, Explore, and Company Details discovery sections.
- **SC-007**: Home and Explore screens MUST render initial visible content within acceptable mobile performance thresholds (<2s on average network).
