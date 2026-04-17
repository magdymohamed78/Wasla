# Research: Service Requests Page

## Decision 1: Reuse proven pagination package already in workspace
- Decision: Keep `infinite_scroll_pagination` for full filtered pages instead of introducing a new pagination dependency.
- Rationale: Package-first review shows very high adoption/maintenance (`likes: 4012`, `pub points: 160/160`) and it already exists in `pubspec.yaml`, reducing integration risk.
- Alternatives considered:
  - `paging_view`: lower adoption and would require new patterns.
  - Custom pagination controller: rejected due to unnecessary maintenance overhead.

## Decision 2: Keep shimmer loading with existing package
- Decision: Use existing `shimmer` package for card-shaped skeleton placeholders.
- Rationale: Package-first review shows mature package quality (`likes: 5417`, `pub points: 160/160`) and it is already installed in the project.
- Alternatives considered:
  - `skeletonizer`: strong package but not required because shimmer dependency already matches current code style.
  - Manual animated placeholders: more boilerplate and less consistency.

## Decision 3: Use server-side filtering as source of truth
- Decision: On tab changes and full-page loads, call backend with status filter and use returned dataset/counts as authoritative.
- Rationale: Avoids local cache divergence, aligns with clarified requirement, and keeps count badges synchronized with backend reality.
- Alternatives considered:
  - Local-only filtering from one large fetch: rejected for stale/inconsistent counts and scalability issues.
  - Hybrid preview-local/full-server: rejected to avoid split behavior complexity.

## Decision 4: Canonical status normalization map
- Decision: Normalize backend statuses into tabs using explicit mapping:
  - Pending = {Pending, New, Submitted}
  - In Progress = {InProgress, OfferSent, Assigned, Scheduled}
  - Closed = {Completed, Rejected, Cancelled, Accepted}
  - Expired = {Expired}
  - Unknown statuses appear in All only with neutral badge.
- Rationale: Handles backend naming variance (including spelling/legacy variants) while maintaining deterministic UX.
- Alternatives considered:
  - Exact string matching only: rejected due to backend variation risk.
  - Time-based auto-close heuristics: rejected (business semantics should come from backend status).

## Decision 5: Compact details scope for this iteration
- Decision: Request details page renders only core fields (reference, company, status, service type, preferred date, submission date).
- Rationale: Matches clarified scope and reduces UI complexity while preserving navigational value.
- Alternatives considered:
  - Full details rendering from full DTO: deferred to future enhancement.
  - Stub details screen: rejected because it under-delivers on user story value.

## Decision 6: Full filtered pages use incremental server pagination
- Decision: Full pages request paginated data (`pageIndex`, `pageSize`, `status`) and append pages until `totalPages` is reached.
- Rationale: Supports large histories smoothly and aligns with existing pagination utilities.
- Alternatives considered:
  - Load all at once: rejected for performance and memory concerns.
  - Fixed non-expandable batch: rejected for poor usability.

## Decision 7: Empty and error state CTA policy
- Decision: Use two actions in empty/recoverable error states:
  - Primary: Browse Companies
  - Secondary: Retry
- Rationale: Supports both recovery from transient failures and next-step discovery flow.
- Alternatives considered:
  - Retry-only: weak action when dataset is truly empty.
  - Browse-only: weak action for transient network/backend errors.

## Decision 8: Routing strategy for filter-specific full pages
- Decision: Use a dedicated full-list page route parameterized by filter context (one reusable page implementation, filter-scoped navigation state).
- Rationale: Satisfies “dedicated page per filter” behavior without duplicating page implementations.
- Alternatives considered:
  - Separate page class per filter: higher maintenance with duplicated logic.
  - Modal overlay details/full list: rejected for navigation consistency and deep-link clarity.

## Decision 9: Locale-aware date formatting
- Decision: Use existing `intl` and active app locale for date rendering in cards and details.
- Rationale: `intl` is already present and highly maintained (`likes: 6064`), and this aligns with Arabic support requirement.
- Alternatives considered:
  - Custom manual formatter: rejected due to i18n edge cases and maintenance burden.
