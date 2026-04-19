# Research: Customer Dashboard Home Section

## Decision 1: Use `flutter_rating_bar` for edit modal rating input
- Decision: Add and use `flutter_rating_bar` for the review edit modal rating selector.
- Rationale: Package-first search shows strong maturity and adoption (`pub points: 150/160`, `likes: 2526`, high download volume) and directly satisfies the feature requirement for a configurable star selector.
- Alternatives considered:
  - `custom_rating_bar`: technically strong but significantly lower adoption.
  - Custom star selector widget: rejected due to unnecessary maintenance and accessibility risk.

## Decision 2: Keep dashboard card animations with Flutter built-ins
- Decision: Implement fade/slide-in and tap-scale interactions using core Flutter animation widgets (`AnimatedOpacity`, `TweenAnimationBuilder`, `AnimatedScale`, `InkWell`) instead of adding an animation package.
- Rationale: Motion requirements are simple and already supported by framework primitives with excellent performance and no dependency overhead.
- Alternatives considered:
  - `flutter_staggered_animations`: high quality package, but rejected for this scope because built-ins are sufficient.
  - Custom animation controllers for each card: rejected as overengineering.

## Decision 3: Reuse existing offers aggregation logic as metrics source
- Decision: Derive Total/Accepted/Pending metrics from existing offers paging contract and status count mapping already used in `CustomerOffersCubit` (`OfferStatusCounts`, `OfferFilter`).
- Rationale: Prevents duplicate business logic and guarantees consistency between dashboard cards and offers screen tabs.
- Alternatives considered:
  - Separate dashboard-only offers endpoint: rejected because current endpoint already provides counts.
  - Manual counting from first-page list items: rejected because it is inaccurate at scale.

## Decision 4: Introduce customer-reviews API integration through existing customer-portal stack
- Decision: Add reviews methods to the existing `CustomerPortalRemoteDataSource` + `CustomerPortalRepositoryImpl` composition, plus a dedicated `CustomerReviewsRepository` interface for domain clarity.
- Rationale: This matches the current architecture where customer requests/offers/profile share one composite repository implementation while exposing focused interfaces to features.
- Alternatives considered:
  - Build a separate standalone repository implementation for reviews only: rejected due to duplicated auth and API plumbing.
  - Put My Reviews data access in widget/cubit directly: rejected by Clean Architecture constraints.

## Decision 5: Handle `/my/reviews` response defensively for contract drift
- Decision: Support both paginated-object and array response shapes when parsing `/api/customer-portal/my/reviews`, while standardizing to an internal paged result model.
- Rationale: Clarified requirement expects `totalCount`, while swagger currently describes array responses for 200 in some sections; tolerant parsing avoids runtime fragility.
- Alternatives considered:
  - Assume array-only schema: rejected because it cannot power dashboard count and pagination contract cleanly.
  - Assume paged-only schema: rejected due to potential backend/schema mismatch risk.

## Decision 6: Route-query contract for dashboard-to-offers filter navigation
- Decision: Encode filter intent in route query state (for example, `/my/offers?filter=accepted`) and initialize offers tab from query on screen load.
- Rationale: Preserves deep-linkability and deterministic navigation state across refreshes and back-stack transitions.
- Alternatives considered:
  - `go_router` extra payload only: rejected because state is not URL-addressable.
  - Shared mutable singleton/cubit handoff only: rejected due to fragility.

## Decision 7: Customer-only route guard for My Reviews
- Decision: Enforce route-level guard behavior for My Reviews: guest -> login, authenticated non-customer -> home, and no rendering for non-customer roles.
- Rationale: Aligns with clarified access policy and existing auth-routing style.
- Alternatives considered:
  - Allow entry then rely on backend 403: rejected due to poor UX.
  - Access denied placeholder page: rejected for unnecessary interaction step.

## Decision 8: Same-session dashboard count synchronization
- Decision: Keep dashboard and My Reviews count synchronized through shared state updates after successful mutations (delete: decrement by 1; edit: unchanged).
- Rationale: Prevents stale card metrics and avoids forcing manual refresh/navigation reload.
- Alternatives considered:
  - Refresh only on next Home visit: rejected due to stale in-session data.
  - No synchronization contract: rejected due to UX inconsistency.
