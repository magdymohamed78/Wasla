---
description: "Task list for Customer Dashboard Home Section implementation"
---

# Tasks: Customer Dashboard Home Section

**Input**: Design documents from `/specs/032-customer-dashboard/`
**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/customer-dashboard-contract.md`, `quickstart.md`

**Tests**: No explicit TDD/testing-task requirement was requested in the feature specification, so this task list focuses on implementation and verification tasks.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on unfinished tasks)
- **[Story]**: Story mapping label (`[US1]`, `[US2]`, `[US3]`)
- Every task includes at least one concrete file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare shared dependencies, scaffolding, and localization/routing placeholders.

- [x] T001 Add rating dependency and lock package version in `pubspec.yaml`
- [x] T002 Create customer reviews repository contract scaffold in `lib/features/home/domain/repositories/customer_reviews_repository.dart`
- [x] T003 [P] Add dashboard and My Reviews English localization keys in `lib/core/localization/l10n/app_en.arb`
- [x] T004 [P] Add dashboard and My Reviews Arabic localization keys in `lib/core/localization/l10n/app_ar.arb`
- [x] T005 Create dashboard and reviews presentation scaffolding files in `lib/features/home/presentation/widgets/dashboard/customer_dashboard_section.dart`, `lib/features/home/presentation/cubit/dashboard_cubit.dart`, `lib/features/home/presentation/cubit/dashboard_state.dart`, `lib/features/reviews/presentation/pages/my_reviews_page.dart`, `lib/features/reviews/presentation/cubit/my_reviews_cubit.dart`, and `lib/features/reviews/presentation/cubit/my_reviews_state.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement shared data/domain/routing contracts that all stories depend on.

**⚠️ CRITICAL**: Complete this phase before starting user stories.

- [x] T006 Implement reviews DTO mapping for API fields in `lib/features/home/data/models/customer_review_dto.dart`
- [x] T007 [P] Export new reviews DTO model in `lib/features/home/data/models/customer_portal_models.dart`
- [x] T008 Implement customer reviews remote data source with list/update/delete methods in `lib/features/home/data/data_sources/customer_reviews_remote_data_source.dart`
- [x] T009 Extend customer portal remote contract and composition to include reviews methods in `lib/features/home/data/data_sources/customer_portal_remote_data_source.dart`
- [x] T010 Extend customer portal repository composition to include reviews interface in `lib/features/home/domain/repositories/customer_portal_repository.dart`
- [x] T011 Implement reviews retrieval/update/delete mapping (including paged/array normalization) in `lib/features/home/data/repositories/customer_portal_repository_impl.dart`
- [x] T012 Wire new repository interfaces/providers for reviews access in `lib/app.dart`
- [x] T013 Add My Reviews route constant and location helper in `lib/core/routing/app_router.dart`
- [x] T014 Add role-based route guard redirects for `/my/reviews` in `lib/core/routing/app_router.dart`
- [x] T015 Add offers filter query parsing and route helper support in `lib/core/routing/app_router.dart`
- [x] T016 Thread offers query filter from router into shell/page constructors in `lib/features/home/presentation/pages/discovery_shell_page.dart` and `lib/features/offers/presentation/pages/customer_offers_page.dart`
- [x] T017 Add initial-filter initialization support to offers cubit in `lib/features/offers/presentation/cubit/customer_offers_cubit.dart`

**Checkpoint**: Shared API contracts, routing contracts, and repository plumbing are ready for story implementation.

---

## Phase 3: User Story 1 - Customer Sees Dashboard Metrics (Priority: P1) 🎯 MVP

**Goal**: Render a customer-only dashboard section on Home with Total Offers, Accepted Offers, Pending Offers, and My Reviews metrics.

**Independent Test**: Sign in as a customer and verify dashboard placement below search/above company sections with card metrics, skeleton loading, and retry handling; verify non-customer users do not see dashboard.

### Implementation for User Story 1

- [x] T018 [US1] Implement dashboard state model with section-level statuses and metric values in `lib/features/home/presentation/cubit/dashboard_state.dart`
- [x] T019 [US1] Implement dashboard cubit loading offers counts and reviews count in `lib/features/home/presentation/cubit/dashboard_cubit.dart`
- [x] T020 [P] [US1] Build reusable dashboard metric card widget with icon container styling in `lib/features/home/presentation/widgets/dashboard/dashboard_metric_card.dart`
- [x] T021 [P] [US1] Build dashboard skeleton and inline retry/error widgets in `lib/features/home/presentation/widgets/dashboard/dashboard_section_states.dart`
- [x] T022 [US1] Build 2x2 dashboard grid section with role-gated rendering in `lib/features/home/presentation/widgets/dashboard/customer_dashboard_section.dart`
- [x] T023 [US1] Insert dashboard section below search and above company sections in `lib/features/home/presentation/pages/home_page.dart`
- [x] T024 [US1] Implement entry and tap animation behavior for dashboard cards in `lib/features/home/presentation/widgets/dashboard/customer_dashboard_section.dart`
- [x] T025 [US1] Ensure dashboard retries are isolated and do not block other home sections in `lib/features/home/presentation/pages/home_page.dart` and `lib/features/home/presentation/cubit/dashboard_cubit.dart`

**Checkpoint**: Customer dashboard metrics are visible and resilient as a standalone MVP increment.

---

## Phase 4: User Story 2 - Customer Navigates by Metric Cards (Priority: P1)

**Goal**: Enable correct card-driven navigation to offers (default/accepted/pending) and My Reviews destination.

**Independent Test**: Tap each card and verify destination and filter context are correct, including route-query initialization of offers tabs.

### Implementation for User Story 2

- [x] T026 [US2] Add My Reviews route definition and page builder wiring in `lib/core/routing/app_router.dart`
- [x] T027 [US2] Support default and query-based offers filter startup in `lib/features/offers/presentation/pages/customer_offers_page.dart` and `lib/features/offers/presentation/cubit/customer_offers_cubit.dart`
- [x] T028 [US2] Wire dashboard card tap actions to offers and My Reviews routes in `lib/features/home/presentation/widgets/dashboard/customer_dashboard_section.dart`
- [x] T029 [US2] Add router helper for filtered offers location generation in `lib/core/routing/app_router.dart`
- [x] T030 [US2] Prevent rapid multi-tap double navigation from dashboard cards in `lib/features/home/presentation/widgets/dashboard/customer_dashboard_section.dart`
- [x] T031 [US2] Validate and adjust shell route forwarding so offers query state survives shell rendering in `lib/features/home/presentation/pages/discovery_shell_page.dart`

**Checkpoint**: Card interactions navigate correctly with deterministic filter context.

---

## Phase 5: User Story 3 - Customer Manages My Reviews (Priority: P2)

**Goal**: Deliver paginated My Reviews page with edit/delete actions, modal workflows, and same-session dashboard count synchronization.

**Independent Test**: Open My Reviews, load paginated items, edit and delete a review, verify toasts/UI updates, and verify Home My Reviews count sync rules in same session.

### Implementation for User Story 3

- [x] T032 [US3] Implement My Reviews state model for load/pagination/mutation transitions in `lib/features/reviews/presentation/cubit/my_reviews_state.dart`
- [x] T033 [US3] Implement My Reviews cubit for list, refresh, load-more, edit, and delete workflows in `lib/features/reviews/presentation/cubit/my_reviews_cubit.dart`
- [x] T034 [P] [US3] Build My Reviews list item card widget (logo/name/rating/text/date/actions) in `lib/features/reviews/presentation/widgets/my_review_card.dart`
- [x] T035 [P] [US3] Build edit review modal using rating bar with validation and trimmed optional text in `lib/features/reviews/presentation/widgets/edit_review_modal.dart`
- [x] T036 [P] [US3] Build delete confirmation modal with Yes/No actions in `lib/features/reviews/presentation/widgets/delete_review_confirmation_modal.dart`
- [x] T037 [US3] Implement My Reviews page UI with skeleton, retry, pull-to-refresh, and infinite scroll in `lib/features/reviews/presentation/pages/my_reviews_page.dart`
- [x] T038 [US3] Integrate success/error feedback using existing toast patterns for edit/delete results in `lib/features/reviews/presentation/pages/my_reviews_page.dart`
- [x] T039 [US3] Implement same-session dashboard count synchronization contract after review mutations in `lib/features/reviews/presentation/cubit/my_reviews_cubit.dart` and `lib/features/home/presentation/cubit/dashboard_cubit.dart`
- [x] T040 [US3] Add customer-role safety fallback in My Reviews page initialization path in `lib/features/reviews/presentation/pages/my_reviews_page.dart`

**Checkpoint**: My Reviews management flow is fully functional and independently testable.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final integration, consistency, and verification across all stories.

- [x] T041 [P] Finalize localization usage and generated string references in `lib/core/localization/l10n/app_en.arb`, `lib/core/localization/l10n/app_ar.arb`, and dashboard/reviews pages
- [x] T042 [P] Final pass for RTL, responsive spacing, and theme-token compliance in `lib/features/home/presentation/widgets/dashboard/customer_dashboard_section.dart` and `lib/features/reviews/presentation/pages/my_reviews_page.dart`
- [x] T043 [P] Add/adjust DI providers for new reviews/dashboard dependencies in `lib/app.dart`
- [x] T044 Run analyzer and test verification for feature changes and capture outcomes in `specs/032-customer-dashboard/quickstart.md`
- [x] T045 Execute quickstart end-to-end validation scenarios and update implementation notes in `specs/032-customer-dashboard/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Can start immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Starts after foundational completion.
- **Phase 4 (US2)**: Starts after foundational completion; integrates with US1 dashboard widgets.
- **Phase 5 (US3)**: Starts after foundational completion; depends on US2 route availability for navigation entry.
- **Phase 6 (Polish)**: Starts after all targeted stories are complete.

### User Story Dependencies

- **US1 (P1)**: First MVP slice, independent after foundational tasks.
- **US2 (P1)**: Independent after foundational tasks, but validates against US1 dashboard card callbacks.
- **US3 (P2)**: Depends on US2 route contract (`/my/reviews`) and foundational reviews data plumbing.

### Recommended Completion Order

1. Phase 1 -> Phase 2
2. US1 (MVP)
3. US2
4. US3
5. Phase 6 polish

---

## Parallel Execution Examples

### User Story 1

- Run T020 and T021 in parallel (independent dashboard widget/state files).
- Run T022 after T019 and T020/T021 complete.

### User Story 2

- Run T029 and T030 in parallel (router helper vs widget interaction lock).
- Run T027 after T017, then T028 and T031.

### User Story 3

- Run T034, T035, and T036 in parallel (separate widget files).
- Run T037 after T032 and T033 are complete.
- Run T039 after T033 and T019 are stable.

---

## Implementation Strategy

### MVP First (Recommended)

1. Complete Setup and Foundational phases.
2. Deliver US1 dashboard metrics and placement.
3. Validate US1 independently before adding navigation and review management.

### Incremental Delivery

1. Add US2 navigation/filter behaviors and validate destination correctness.
2. Add US3 My Reviews management flow.
3. Complete polish and regression verification.

### Parallel Team Strategy

1. Developer A: Foundational reviews data/repository tasks (T006-T012).
2. Developer B: Dashboard UI/cubit tasks (T018-T025).
3. Developer C: Routing and offers filter plumbing (T013-T017, T026-T031).
4. After merge, split My Reviews widgets/cubit/page tasks (T032-T040).

---

## Notes

- Tasks marked `[P]` are scoped to different files and suitable for parallel execution.
- Story labels map directly to spec priorities for traceability.
- Testing-task creation was intentionally omitted because the specification did not explicitly request TDD-first test tasks.
