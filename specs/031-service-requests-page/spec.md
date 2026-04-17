# Feature Specification: Service Requests Page

**Feature Branch**: feature/031-service-requests-page  
**Created**: 2026-04-16  
**Status**: Draft  
**Input**: User description: "Implement a customer Service Requests Page with status filtering, preview cards, request-details navigation, and load-more navigation to full filtered pages, while matching existing theme and RTL behavior."

## Clarifications

### Session 2026-04-16

- Q: What should be the source of truth for filter results when users switch tabs and open full lists? → A: Use server-side filtering per selected tab for both preview and full pages; backend data is authoritative.
- Q: How should backend status values be normalized into filter tabs? → A: Use an explicit mapping: Pending = {Pending, New, Submitted}; In Progress = {InProgress, OfferSent, Assigned, Scheduled}; Closed = {Completed, Rejected, Cancelled, Accepted}; Expired = {Expired}; unknown statuses appear only in All with a neutral badge.
- Q: How much request details data should be shown in this feature? → A: Use a compact details view with only core fields (reference number, company, status, service type, preferred date, submission date).
- Q: How should full filtered pages load larger histories? → A: Use server pagination with incremental loading for full filtered pages.
- Q: What CTA behavior should empty/error states provide? → A: Show two CTAs: primary Browse Companies and secondary Retry.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse Requests by Status (Priority: P1)

As an authenticated customer, I can open a Requests page and quickly review my service requests by status using clear filter tabs and preview cards.

**Why this priority**: This is the core value of the feature and the main user entry point for request tracking.

**Independent Test**: Log in as a customer with existing requests, open the Requests page, switch between filters, and verify that each filter shows the correct preview list and counts.

**Acceptance Scenarios**:

1. **Given** an authenticated customer with request data, **When** the Requests page opens, **Then** the All filter is selected by default and request previews are shown.
2. **Given** a selected filter tab, **When** the user switches to another tab, **Then** the page shows a loading skeleton and then only requests matching that tab.
3. **Given** a filter contains more than five requests, **When** the preview list is rendered, **Then** only five cards are shown in the preview section.

---

### User Story 2 - Open Request Details (Priority: P1)

As an authenticated customer, I can open a specific request from the list and view a compact request details summary.

**Why this priority**: Users must be able to inspect one request deeply, not just see summary cards.

**Independent Test**: From any visible request card, tap View Request and confirm that the app opens the request details page for that exact request id.

**Acceptance Scenarios**:

1. **Given** a visible request card, **When** the user taps View Request, **Then** the app navigates to Request Details for that request id.
2. **Given** the Request Details page opens, **When** details are loading, **Then** a loading state is shown and replaced by request details or an error state.

---

### User Story 3 - View Full Filtered Lists (Priority: P2)

As an authenticated customer, I can move from the five-card preview to a full list page scoped to the currently selected filter.

**Why this priority**: Preview cards provide quick context, but full pages are needed for complete tracking and management at scale.

**Independent Test**: Select each filter tab and tap LOADING MORE REQUESTS..., then verify navigation to the corresponding full-list page with that filter applied.

**Acceptance Scenarios**:

1. **Given** any active filter, **When** the user taps LOADING MORE REQUESTS..., **Then** the app opens a full list page for that same filter.
2. **Given** a full filtered page, **When** there are no matching requests, **Then** a friendly empty state with primary Browse Companies and secondary Retry actions is shown.
3. **Given** a full filtered page with more results, **When** the user reaches the loading trigger, **Then** the next server page is fetched and appended until no more pages remain.

---

### Edge Cases

- What happens when the customer has zero requests in all statuses?
- How does the page behave when the selected filter has zero items but other filters have items?
- How does the list render when company logo is missing or invalid?
- How does the app present unknown or unexpected status values from backend data?
- What happens when preferred date is missing while submission date exists?
- How is behavior handled when status counts and list results are temporarily inconsistent due to backend timing?
- What happens when details retrieval fails after successful list retrieval?
- Unknown statuses are shown in All only and use a neutral status badge to avoid incorrect categorization.
- How should the full filtered page behave when the final page is reached with no more results to load?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow only authenticated customers to access the Requests page.
- **FR-002**: System MUST show an AppBar title of Requests.
- **FR-003**: System MUST show a header section with title Service Requests and the description line Track and manage your service requests.
- **FR-004**: System MUST retrieve service request summaries and status counts from the existing customer service-request listing contract.
- **FR-005**: System MUST provide horizontal filter tabs for All, Pending, In Progress, Closed, and Expired.
- **FR-006**: System MUST show each filter tab with a status label and its count.
- **FR-007**: System MUST select All by default on initial page load.
- **FR-008**: System MUST request status-scoped request data from backend whenever the selected filter tab changes and update the visible list from that response.
- **FR-009**: System MUST show a preview list containing at most five request cards for the active filter.
- **FR-010**: System MUST render each request card with company logo, company name, reference number, status badge, service type, preferred date, submission date, and a View Request action.
- **FR-011**: System MUST display visually distinct status badges for different request states.
- **FR-012**: System MUST format displayed dates according to the active locale, including Arabic.
- **FR-013**: System MUST navigate to Request Details when View Request is tapped and MUST pass the selected service request id.
- **FR-014**: System MUST retrieve request details using the existing customer request-details contract with the passed request id.
- **FR-015**: System MUST show a LOADING MORE REQUESTS... action below the preview list.
- **FR-016**: System MUST navigate from LOADING MORE REQUESTS... to a full list page scoped to the currently active filter.
- **FR-017**: System MUST support full filtered pages for each tab category (All, Pending, In Progress, Closed, Expired).
- **FR-018**: System MUST use card-shaped skeleton loading placeholders that match request-card layout during initial load and filter switching.
- **FR-019**: System MUST provide independent loading, success, empty, and error states for list and details experiences.
- **FR-020**: System MUST provide an empty state per filter with a friendly message and two actions: primary Browse Companies and secondary Retry.
- **FR-021**: System MUST maintain existing app visual language (theme tokens, spacing, typography, and RTL behavior) without redesigning the app theme.
- **FR-022**: System MUST treat backend-provided filter counts and filtered request datasets as the source of truth for both preview and full filtered pages.
- **FR-023**: System MUST normalize backend status values into tabs using this canonical mapping: Pending = {Pending, New, Submitted}; In Progress = {InProgress, OfferSent, Assigned, Scheduled}; Closed = {Completed, Rejected, Cancelled, Accepted}; Expired = {Expired}.
- **FR-024**: System MUST include unknown or unmapped statuses in All only and MUST display them with a neutral status badge style.
- **FR-025**: System MUST render a compact Request Details view using core fields only: reference number, company identity, status, service type, preferred date, and submission date.
- **FR-026**: Additional detail sections beyond core fields are out of scope for this feature iteration.
- **FR-027**: System MUST use server-side pagination for full filtered pages using backend paging parameters.
- **FR-028**: System MUST append newly loaded pages to existing full-page list data without duplicating previously shown requests.
- **FR-029**: System MUST stop requesting additional pages when backend indicates no remaining results.
- **FR-030**: System MUST show card-shaped loading placeholders during full-page initial load and during incremental page fetches.
- **FR-031**: System MUST provide the same two-action CTA pattern (primary Browse Companies, secondary Retry) for recoverable request-list error states.

### Key Entities *(include if feature involves data)*

- **Service Request Summary**: A request preview item containing id, reference number, company identity, service type, status, preferred date, submission date, and offer flags.
- **Service Request Details**: The details payload for a single request identified by service request id, from which compact core fields are rendered.
- **Status Count Summary**: Aggregated counts per status used to label filter tabs.
- **Request Filter**: A user-selected status scope (All, Pending, In Progress, Closed, Expired) that determines what subset is visible.
- **Request Preview Collection**: A limited set of up to five cards shown on the main Requests page for the active filter.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of authenticated customer sessions can open the Requests page without a crash.
- **SC-002**: In at least 95% of sessions with available data, first preview content is visible within 2 seconds after page entry on a standard mobile connection.
- **SC-003**: 100% of filter tab selections produce the correct filter context and render no more than five preview cards.
- **SC-004**: 100% of View Request actions open details for the exact selected service request id.
- **SC-005**: 100% of empty filter results show a non-blank friendly empty state with CTA guidance.
- **SC-006**: 100% of displayed request dates follow the active locale format, including Arabic locale behavior.
- **SC-007**: 100% of full filtered page pagination actions append new non-duplicate records and stop at end-of-results without errors.

## Assumptions

- The customer service-request contracts for list and details remain available and stable as documented in approved backend contract documentation.
- Request statuses returned by backend can be mapped into the required filter groups (All, Pending, In Progress, Closed, Expired).
- Only customer-role users are in scope for this feature release.
- Existing app navigation infrastructure supports route parameters for request id and filter-scoped full-list pages.
- Existing design tokens and RTL foundations are already present and can be reused directly for this feature.
- Non-core details sections are deferred to a future enhancement iteration.
- Backend paginated filtered-list responses provide stable ordering within a filter to support deterministic append behavior.
