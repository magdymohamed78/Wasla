# Research: Explore and Discover Companies for Leads

## Decision 1: Use `infinite_scroll_pagination` for Explore paging
- Decision: Use `infinite_scroll_pagination` for vertical Explore list pagination and near-end loading behavior.
- Rationale: Package is mature and widely adopted (high pub points/likes/downloads), directly supports page-key driven loading, and reduces custom pagination bugs.
- Alternatives considered:
  - Custom `ScrollController` pagination logic: rejected due higher state complexity and duplicated paging error/loading handling.
  - Lesser-known paging packages with lower adoption: rejected for ecosystem risk.

## Decision 2: Use `easy_debounce` for 300ms search debounce
- Decision: Implement search debounce with `easy_debounce`.
- Rationale: Lightweight package with strong adoption; meets exact debounce requirement and keeps Cubit search orchestration simple.
- Alternatives considered:
  - Manual `Timer` debounce in Cubit: possible but repetitive and easier to leak/forget cancellation.
  - Broader throttle/debounce packages: rejected as unnecessary for this simple requirement.

## Decision 3: Use `cached_network_image` for logos and placeholders
- Decision: Render company logos with `cached_network_image` and fallback placeholders.
- Rationale: Highly adopted package with built-in error/placeholder widgets and network caching for smooth lists.
- Alternatives considered:
  - Plain `Image.network` with `errorBuilder`: rejected because it misses robust caching behavior for repeated company cards.

## Decision 4: Use `shimmer` for skeleton loading states
- Decision: Implement Home and Explore skeletons with `shimmer` package.
- Rationale: Industry-standard package with strong maintenance and broad usage; matches SH-006 requirement efficiently.
- Alternatives considered:
  - Static placeholder boxes without shimmer: rejected due weaker loading affordance.
  - Heavy skeleton abstraction packages: rejected to keep dependency footprint moderate.

## Decision 5: Home route must be accessible in lead discovery context
- Decision: Remove strict login redirect for Home discovery and gate restricted actions/tabs in feature logic.
- Rationale: Spec requires discovery for not-registered users and lead users, while request actions remain blocked and routed to onboarding/login.
- Alternatives considered:
  - Keep `/home` auth redirect and force login before discovery: rejected due direct conflict with feature goals.

## Decision 6: Normalize API parameter naming and service-type mapping in data layer
- Decision: Add an API query mapping layer because endpoint params differ by casing and naming:
  - Companies list: `search`, `city`, `serviceType`, `pageIndex`, `pageSize`
  - Recommended/Trending: `ServiceType`, `PageIndex`, `PageSize`
- Rationale: Central mapper isolates backend contract inconsistencies from UI domain models.
- Alternatives considered:
  - Hardcode query keys in widgets/Cubit: rejected due maintainability and testability concerns.

## Decision 7: Canonical service-type mapping from UI filter to backend values
- Decision: Use explicit mapping table in repository:
  - `All Services -> null`
  - `Move -> Moving`
  - `Cleaning -> Cleaning`
  - `Disposal -> Disposal`
  - `Packing -> Packing`
  - `Unpacking -> Unpacking`
  - `Storage -> Storage`
  - `Transport -> Transport`
- Rationale: Swagger examples indicate backend expects values like `Moving` while UX labels use `Move`.
- Alternatives considered:
  - Send UI labels directly: rejected because mismatch risk is high for `Move` vs `Moving`.

## Decision 8: Company details reviews strategy
- Decision: Use `PublicCompanyDetailsDto.recentReviews` for initial details render and optionally load full paged reviews from `/api/customer-portal/companies/{companyId}/reviews` when user expands/scrolls reviews.
- Rationale: Fast first paint with complete details and scalable review browsing when needed.
- Alternatives considered:
  - Always request full reviews immediately: rejected due unnecessary extra network cost on initial details open.

## Decision 9: Lead request gating follows clarification decisions
- Decision: In lead context, request action is always blocked and routes to onboarding/login regardless authentication status.
- Rationale: Directly matches final clarification and keeps behavior deterministic.
- Alternatives considered:
  - Allow authenticated leads to submit requests directly: rejected because it conflicts with clarified product rule for this feature.
