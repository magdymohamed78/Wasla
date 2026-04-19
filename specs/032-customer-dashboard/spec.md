# Feature Specification: Customer Dashboard Home Section

**Feature Branch**: `032-add-customer-dashboard`  
**Created**: 2026-04-19  
**Status**: Draft  
**Input**: User description: "Build a customer-only dashboard on the home page with four metric cards (offers and reviews), role-based visibility, card navigation, and a My Reviews management page with edit/delete actions, while reusing existing app patterns and preserving theme, spacing, typography, RTL, loading/error, and performance expectations."

## Clarifications

### Session 2026-04-19

- Q: Which navigation contract should set the offers filter when dashboard cards are tapped? → A: Pass filter via route query parameter and initialize offers state from that route value.
- Q: For My Reviews, what loading strategy should be required? → A: Use server pagination with incremental loading (infinite scroll) plus pull-to-refresh.
- Q: How should access to My Reviews be handled when the user is not a customer (guest, lead, or role changed mid-session)? → A: Enforce route guard with guest redirect to login and authenticated non-customer redirect to home; My Reviews does not render.
- Q: After a successful action in My Reviews, how should the Home My Reviews card count be synchronized in the same session? → A: Update count immediately in shared state (delete decrements by 1, edit keeps same count).
- Q: What client-side validation should the My Reviews edit modal enforce before submit? → A: Require rating selection (1-5), allow optional comment, trim whitespace, and block submit only when rating is missing.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Customer Sees Dashboard Metrics (Priority: P1)

As a customer, I can see a compact dashboard section on the home page that summarizes my offers and reviews, so I can quickly understand my activity without leaving home.

**Why this priority**: This is the primary value of the feature and must be visible immediately in the customer home experience.

**Independent Test**: Sign in as a customer, open Home, and verify a four-card dashboard appears directly below search and above company sections, with counts for Total Offers, Accepted Offers, Pending Offers, and My Reviews.

**Acceptance Scenarios**:

1. **Given** a signed-in customer on Home, **When** page content is rendered, **Then** the dashboard is displayed below the search entry and above company discovery sections.
2. **Given** a signed-in user who is not a customer, **When** Home is rendered, **Then** the dashboard section is not shown.
3. **Given** dashboard data is loading, **When** Home opens, **Then** a non-blocking card skeleton state is shown for the dashboard section.
4. **Given** dashboard data retrieval fails, **When** Home remains visible, **Then** the dashboard section shows a localized inline error with retry action and does not block other Home sections.

---

### User Story 2 - Customer Navigates by Metric Cards (Priority: P1)

As a customer, I can tap any dashboard card to navigate directly to the related destination, so I can move from summary metrics to detailed workflows in one step.

**Why this priority**: Navigation from summary metrics to actionable pages is required for dashboard usefulness.

**Independent Test**: Tap each dashboard card and verify navigation behavior: Total Offers -> offers list (default filter), Accepted Offers -> offers list filtered to accepted, Pending Offers -> offers list filtered to pending, My Reviews -> dedicated My Reviews page.

**Acceptance Scenarios**:

1. **Given** dashboard cards are visible, **When** Total Offers is tapped, **Then** the offers experience opens in default filter context.
2. **Given** dashboard cards are visible, **When** Accepted Offers is tapped, **Then** the offers experience opens in accepted filter context.
3. **Given** dashboard cards are visible, **When** Pending Offers is tapped, **Then** the offers experience opens in pending filter context.
4. **Given** dashboard cards are visible, **When** My Reviews is tapped, **Then** the My Reviews page opens.

---

### User Story 3 - Customer Manages My Reviews (Priority: P2)

As a customer, I can view, edit, and delete my own reviews from one page, so I can keep my feedback accurate and up to date.

**Why this priority**: Review management is a key post-service capability, but depends on the dashboard navigation and data summary entry points.

**Independent Test**: Open My Reviews from dashboard, confirm list items render company logo/name, rating, text, and date; edit one item and verify immediate update and success feedback; delete one item and verify confirmation, removal, and success feedback.

**Acceptance Scenarios**:

1. **Given** a customer with one or more reviews, **When** My Reviews opens, **Then** the page lists review cards with company identity, rating, text, date, and edit/delete actions.
2. **Given** a review item, **When** Edit is submitted with valid changes, **Then** the review is updated, success feedback is shown, and the list reflects the updated review without a full-page blocking loader.
3. **Given** a review item, **When** Delete is confirmed, **Then** the review is removed from the list and success feedback is shown.
4. **Given** My Reviews retrieval fails, **When** the page remains open, **Then** an inline retry experience is shown and the user can retry without leaving the page.

---

### Edge Cases

- What happens when the customer has zero offers and zero reviews (all dashboard cards show zero values)?
- What happens when offers metrics load successfully but reviews count fails (partial dashboard failure handling)?
- How does the dashboard behave when the user role changes during session refresh (customer to non-customer or vice versa)?
- What happens when the customer taps cards repeatedly during in-progress navigation transitions?
- How does My Reviews render when company image is missing or invalid for some items?
- What happens when a review update or delete request fails because the review no longer exists?
- How are empty, loading, and error states handled for dashboard and My Reviews independently without blocking the full screen?
- How is card grid layout preserved for right-to-left languages and smaller mobile widths?
- What happens when the user tries to submit review edits without selecting a rating?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST render the dashboard section only for users in customer role.
- **FR-002**: System MUST NOT render the dashboard section for non-customer roles.
- **FR-003**: System MUST place the dashboard section on Home directly below the search entry and above company discovery sections.
- **FR-004**: System MUST render the dashboard as a two-column grid with exactly four cards.
- **FR-005**: System MUST include cards for Total Offers, Accepted Offers, Pending Offers, and My Reviews.
- **FR-006**: System MUST display each card with a prominent numeric value and a secondary title label.
- **FR-007**: System MUST use existing visual design tokens for color, spacing, typography, corners, and shadows.
- **FR-008**: System MUST present each card icon inside a rounded light-background container that follows current design system rules.
- **FR-009**: System MUST preserve correct right-to-left behavior for card alignment, icon placement, text direction, and grid ordering.
- **FR-010**: System MUST include lightweight entry animation for dashboard cards that combines fade-in and upward motion.
- **FR-011**: System MUST include lightweight tap feedback on cards using scale-down interaction and ripple.
- **FR-012**: System MUST keep dashboard animations smooth and non-blocking on standard mobile devices.
- **FR-013**: System MUST source Total Offers, Accepted Offers, and Pending Offers from the existing customer offers data logic and status mapping already used by the offers experience.
- **FR-014**: System MUST NOT duplicate existing offers business logic when producing dashboard offer metrics.
- **FR-015**: System MUST source My Reviews metric from the existing customer reviews listing contract using returned total count.
- **FR-016**: System MUST navigate Total Offers card taps to the offers destination in default filter context.
- **FR-017**: System MUST navigate Accepted Offers card taps to the offers destination with accepted filter context applied.
- **FR-018**: System MUST navigate Pending Offers card taps to the offers destination with pending filter context applied.
- **FR-019**: System MUST navigate My Reviews card taps to a dedicated My Reviews page.
- **FR-020**: System MUST provide a My Reviews page that lists the current customer's reviews with company logo, company name, rating, review text, and review date.
- **FR-021**: System MUST provide edit and delete actions on each My Reviews list item.
- **FR-022**: System MUST open an edit modal prefilled with existing review rating and text.
- **FR-023**: System MUST allow submitting review edits and reflect successful changes immediately in the visible list.
- **FR-024**: System MUST show success feedback after review edit completion.
- **FR-025**: System MUST request delete confirmation before removing a review and include explicit affirmative and cancel actions.
- **FR-026**: System MUST remove the review from the visible list immediately after successful delete and show success feedback.
- **FR-027**: System MUST use section-level loading placeholders (skeletons) for dashboard and My Reviews, with no full-screen blocking loader.
- **FR-028**: System MUST provide section-level retry actions for recoverable dashboard and My Reviews failures.
- **FR-029**: System MUST keep dashboard and My Reviews state handling isolated so failure in one section does not block unrelated sections.
- **FR-030**: System MUST reuse existing app error handling, user feedback patterns, routing conventions, and shared components where equivalent behavior already exists.
- **FR-031**: System MUST avoid unnecessary redraw behavior and maintain responsive scrolling performance on the My Reviews list.
- **FR-032**: System MUST keep all new behavior backward compatible with existing Home, Offers, and company discovery experiences.
- **FR-033**: System MUST encode dashboard-to-offers filter intent in route query state and initialize offers filter selection from that query on destination load.
- **FR-034**: System MUST load My Reviews using server pagination with incremental loading as the user scrolls.
- **FR-035**: System MUST provide pull-to-refresh on My Reviews to reload from the first page and refresh visible list data.
- **FR-036**: System MUST enforce customer-only access to My Reviews using route-level guard behavior: guest users are redirected to login, authenticated non-customer users are redirected to home, and My Reviews UI is not rendered for non-customer roles.
- **FR-037**: System MUST synchronize the Home My Reviews dashboard metric within the same authenticated session after successful My Reviews actions using shared state updates.
- **FR-038**: System MUST decrement the My Reviews dashboard count by one after successful delete and MUST keep the count unchanged after successful edit.
- **FR-039**: System MUST enforce client-side validation in the review edit modal requiring a rating in the inclusive range 1 to 5 before submit.
- **FR-040**: System MUST treat review comment as optional, trim surrounding whitespace before submit, and block submit only when required rating validation fails.

### Key Entities *(include if feature involves data)*

- **Dashboard Metric Card**: A summary item containing label, value, icon treatment, and tap destination.
- **Offer Metrics Summary**: Aggregated offer counts for total, accepted, and pending states derived from existing customer offers data.
- **Customer Review Summary**: Review list item containing company identity, rating, text, and display date for the authenticated customer.
- **Review Edit Payload**: Updated rating and comment values submitted for a selected customer review.
- **Review Deletion Decision**: Explicit user confirmation result used before performing review removal.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of customer sessions on Home display the dashboard section in the required location.
- **SC-002**: 100% of non-customer sessions on Home do not display the dashboard section.
- **SC-003**: In at least 95% of customer sessions with available data, dashboard card values appear within 2 seconds of Home opening on a standard mobile connection.
- **SC-004**: 100% of dashboard card taps navigate to the correct destination and filter context.
- **SC-005**: 100% of successful review edits update visible list content during the same session without requiring user logout/login.
- **SC-006**: 100% of successful review deletions remove the deleted item from the visible list during the same session.
- **SC-007**: 100% of dashboard and My Reviews loading/error states are displayed as section-level states without full-screen blocking overlays.
- **SC-008**: 100% of tested RTL scenarios show correct card ordering, spacing, and text alignment for dashboard and My Reviews.

## Assumptions

- Existing authenticated session state reliably exposes the current user role and supports role-based conditional rendering.
- Existing customer offers flow already provides reliable status categorization and counts for default, accepted, and pending views.
- Existing customer reviews contract provides total count and list records needed for summary and My Reviews experiences.
- Existing app localization and RTL foundations are already in place and can be reused for new texts and layouts.
- Existing shared components for inline loading, retry handling, and success/error user feedback are available for reuse.
- Dashboard metrics and My Reviews actions are in scope only for customer role in this release.
- Bulk actions, advanced sorting, and cross-company review analytics are out of scope for this feature iteration.
