---
description: "Task list for Service Requests Page implementation"
---

# Tasks: Service Requests Page

**Input**: Design documents from `/specs/031-service-requests-page/`
**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/customer-service-requests-contract.md`, `quickstart.md`

**Tests**: No explicit TDD/testing-task request was specified in the feature spec, so this task list focuses on implementation and verification tasks only.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on unfinished tasks)
- **[Story]**: Story mapping label (`[US1]`, `[US2]`, `[US3]`)
- Every task includes at least one concrete file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare feature scaffolding, shared copy, and routing placeholders.

- [x] T001 Create requests domain/data scaffolding files in lib/features/requests/domain/entities/request_filter.dart, lib/features/requests/domain/use_cases/request_status_normalization_use_case.dart, lib/features/requests/data/models/request_page_result_dto.dart, lib/features/requests/data/models/request_details_compact_dto.dart, and lib/features/requests/data/repositories/requests_repository_impl.dart
- [x] T002 Add English localization keys for requests headers, filters, statuses, details labels, and CTA text in lib/core/localization/l10n/app_en.arb
- [x] T003 [P] Add Arabic localization keys matching new requests UI copy in lib/core/localization/l10n/app_ar.arb
- [x] T004 [P] Add route constants and location helpers for request details and full filtered list flows in lib/core/routing/app_router.dart
- [x] T005 Create reusable requests widget stubs in lib/features/requests/presentation/widgets/request_filter_tabs.dart, lib/features/requests/presentation/widgets/request_card.dart, and lib/features/requests/presentation/widgets/request_card_skeleton.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement data/domain contracts and shared logic required by all stories.

**⚠️ CRITICAL**: Complete this phase before starting user stories.

- [x] T006 Create request domain models for status counts, paged results, and compact details in lib/features/requests/domain/entities/request_status_counts.dart, lib/features/requests/domain/entities/request_page_result.dart, and lib/features/requests/domain/entities/request_details_compact.dart
- [x] T007 [P] Extend summary DTO/entity mapping to include logo and normalized status-ready fields in lib/features/home/data/models/customer_service_request_summary_dto.dart and lib/features/home/domain/entities/customer_service_request_summary.dart
- [x] T008 Update paged list parsing (items + statusCounts + pagination metadata) in lib/features/home/data/data_sources/customer_requests_remote_data_source.dart
- [x] T009 Add request-details fetch method using /api/customer-portal/my/service-requests/{id} in lib/features/home/data/data_sources/customer_requests_remote_data_source.dart
- [x] T010 Update customer portal remote contract/implementation to expose paged requests and request-details retrieval in lib/features/home/data/data_sources/customer_portal_remote_data_source.dart
- [x] T011 Update requests repository interface to support paged responses and details retrieval in lib/features/home/domain/repositories/customer_requests_repository.dart
- [x] T012 Implement repository mapping for paged results and compact details in lib/features/home/data/repositories/customer_portal_repository_impl.dart
- [x] T013 Add/extend requests use cases for filtered paged retrieval and details retrieval in lib/features/home/domain/use_cases/get_customer_service_requests_use_case.dart and lib/features/home/domain/use_cases/get_customer_service_request_details_use_case.dart
- [x] T014 Export and inject the new details use case in lib/features/home/domain/use_cases/customer_portal_use_cases.dart and lib/app.dart
- [x] T015 Implement canonical status normalization utility for Pending/In Progress/Closed/Expired plus unknown fallback in lib/features/requests/domain/use_cases/request_status_normalization_use_case.dart

**Checkpoint**: Data layer, repository contracts, and shared status logic are ready for UI story work.

---

## Phase 3: User Story 1 - Browse Requests by Status (Priority: P1) 🎯 MVP

**Goal**: Customer can browse request previews by status tabs with server-authoritative filtering and count badges.

**Independent Test**: Open Requests page, switch filters, verify count badges and preview list (max 5 cards) update from backend data.

### Implementation for User Story 1

- [x] T016 [US1] Create dedicated requests state model with active filter, counts, preview list, and view-status flags in lib/features/requests/presentation/cubit/customer_requests_state.dart
- [x] T017 [US1] Refactor list logic for initial load, tab switching, retry, and preview cap (5) in lib/features/requests/presentation/cubit/customer_requests_cubit.dart
- [x] T018 [P] [US1] Implement horizontal filter tab widget with count badges in lib/features/requests/presentation/widgets/request_filter_tabs.dart
- [x] T019 [P] [US1] Implement request preview card widget with logo, reference, status badge, service type, and dates in lib/features/requests/presentation/widgets/request_card.dart
- [x] T020 [P] [US1] Implement card-shaped skeleton loading widget for initial/filter-switch loading in lib/features/requests/presentation/widgets/request_card_skeleton.dart
- [x] T021 [US1] Rebuild main requests page UI with AppBar/header/tabs/preview list and localized state handling in lib/features/requests/presentation/pages/customer_requests_page.dart
- [x] T022 [US1] Wire empty/error dual-CTA actions (Browse Companies + Retry) on main requests page in lib/features/requests/presentation/pages/customer_requests_page.dart

**Checkpoint**: Requests page is functional as an MVP with status tabs, preview cards, and resilient states.

---

## Phase 4: User Story 2 - Open Request Details (Priority: P1)

**Goal**: Customer can open a request from preview/full list and view compact request details.

**Independent Test**: Tap View Request on any card and confirm details page loads compact fields for the selected id.

### Implementation for User Story 2

- [x] T023 [US2] Add request-details route constant, location helper, and GoRoute argument parsing in lib/core/routing/app_router.dart
- [x] T024 [P] [US2] Create details cubit/state with loading/success/error transitions in lib/features/requests/presentation/cubit/request_details_cubit.dart and lib/features/requests/presentation/cubit/request_details_state.dart
- [x] T025 [US2] Build compact details page UI (reference, company, status, service type, preferred/submission dates) in lib/features/requests/presentation/pages/request_details_page.dart
- [x] T026 [US2] Connect View Request action from preview cards to details route with serviceRequestId in lib/features/requests/presentation/pages/customer_requests_page.dart
- [x] T027 [US2] Expose details use case to page-level construction via providers in lib/app.dart

**Checkpoint**: Request details navigation and compact detail rendering are complete.

---

## Phase 5: User Story 3 - View Full Filtered Lists (Priority: P2)

**Goal**: Customer can open a full-page list for the active filter and load more via server pagination.

**Independent Test**: Tap LOADING MORE REQUESTS... for each filter and verify filter-scoped page appends data until end without duplicates.

### Implementation for User Story 3

- [x] T028 [US3] Add full filtered list route constant/helper and GoRoute filter parsing in lib/core/routing/app_router.dart
- [x] T029 [P] [US3] Implement full-list cubit/state for initial load, load-more, and recoverable errors in lib/features/requests/presentation/cubit/full_request_list_cubit.dart and lib/features/requests/presentation/cubit/full_request_list_state.dart
- [x] T030 [US3] Build full filtered list page with paginated card rendering and filter-scoped context in lib/features/requests/presentation/pages/customer_requests_full_page.dart
- [x] T031 [US3] Wire LOADING MORE REQUESTS... action to full-list route carrying active filter in lib/features/requests/presentation/pages/customer_requests_page.dart
- [x] T032 [US3] Add duplicate-by-id append guard, end-of-list stop logic, and incremental skeleton states in lib/features/requests/presentation/cubit/full_request_list_cubit.dart
- [x] T033 [US3] Implement full-list empty/error states with Browse Companies and Retry actions in lib/features/requests/presentation/pages/customer_requests_full_page.dart

**Checkpoint**: Full filtered list flow supports incremental pagination and dual-CTA state handling.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency, integration, and verification passes across all stories.

- [x] T034 [P] Finalize localized copy and requests labels for all new states/routes in lib/core/localization/l10n/app_en.arb and lib/core/localization/l10n/app_ar.arb
- [x] T035 [P] Align RTL and theme-token usage in lib/features/requests/presentation/pages/customer_requests_page.dart, lib/features/requests/presentation/pages/customer_requests_full_page.dart, and lib/features/requests/presentation/widgets/request_card.dart
- [x] T036 Update requests tab integration and route handoff behavior in lib/features/home/presentation/pages/discovery_shell_page.dart and lib/core/routing/app_router.dart
- [x] T037 Run analyzer-driven cleanup for changed requests/home files and record outcomes in specs/031-service-requests-page/quickstart.md
- [x] T038 Execute quickstart verification scenarios and capture implementation notes in specs/031-service-requests-page/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Start immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all story phases.
- **Phase 3 (US1)**: Starts after Phase 2.
- **Phase 4 (US2)**: Starts after Phase 2; final card-action integration depends on US1 page updates.
- **Phase 5 (US3)**: Starts after Phase 2; load-more entrypoint depends on US1 page updates.
- **Phase 6 (Polish)**: Starts after desired story phases are complete.

### User Story Dependencies

- **US1 (P1)**: Primary MVP slice; no dependency on other stories after foundational work.
- **US2 (P1)**: Can begin after foundational work, then integrates with US1 card actions.
- **US3 (P2)**: Depends on US1 preview/filter interaction surfaces for load-more entry.

### Recommended Completion Order

1. Phase 1 → Phase 2
2. US1 (MVP)
3. US2
4. US3
5. Phase 6 polish

---

## Parallel Execution Examples

### User Story 1

- Run T018 and T019 in parallel after T017 (different widget files).
- Run T020 in parallel with T018/T019 (independent skeleton component).

### User Story 2

- Run T023 and T024 in parallel (routing constants vs cubit/state implementation).
- Start T025 once T024 shape is stable.

### User Story 3

- Run T028 and T029 in parallel (route wiring vs paginated cubit/state files).
- Start T030 after T029 contracts are defined.

---

## Implementation Strategy

### MVP First (Recommended)

1. Complete Phase 1 and Phase 2.
2. Deliver US1 (Phase 3) as the first deployable increment.
3. Validate independent test for US1 before expanding scope.

### Incremental Delivery

1. Add US2 for request-level inspection.
2. Add US3 for full-list pagination.
3. Finish with Phase 6 quality and integration pass.

### Team Parallelization

1. One developer handles data/domain foundational tasks (T006-T015).
2. One developer builds US1 UI/cubit widgets (T016-T022).
3. Another developer can start US2 route/details work (T023-T025) once foundational contracts settle.
4. US3 pagination can proceed once US1 preview surface is merged.

---

## Notes

- Tasks marked `[P]` target separate files and can be executed concurrently.
- Story labels `[US1]`, `[US2]`, `[US3]` provide traceability to spec priorities.
- This plan intentionally omits dedicated test-writing tasks because tests were not explicitly requested in the specification.
