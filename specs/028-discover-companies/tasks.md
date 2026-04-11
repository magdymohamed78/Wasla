# Tasks: Explore and Discover Companies for Leads

**Input**: Design documents from `/specs/028-discover-companies/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/discovery-api-contract.md, quickstart.md

**Tests**: Test tasks are intentionally omitted because the specification does not explicitly request TDD or test-first implementation tasks.

**Organization**: Tasks are grouped by user story to keep each story independently implementable and independently verifiable.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add required dependencies and baseline scaffolding for discovery feature work.

- [x] T001 Add `infinite_scroll_pagination`, `easy_debounce`, `cached_network_image`, and `shimmer` dependencies in `pubspec.yaml`
- [x] T002 Resolve packages and update lockfile in `pubspec.lock`
- [x] T003 [P] Create discovery feature folder skeleton under `lib/features/home/` (data/domain/presentation subfolders)
- [x] T004 [P] Add discovery and restriction localization keys in `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`
- [x] T005 Regenerate localization classes in `lib/core/localization/l10n/AppLocalizations.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build core discovery architecture and API integration foundations that block all stories.

**⚠️ CRITICAL**: No user story work should start until this phase is complete.

- [x] T006 Define shared discovery enums/value objects in `lib/features/home/domain/entities/discovery_types.dart`
- [x] T007 [P] Define core entities for company summary and details in `lib/features/home/domain/entities/company_summary.dart` and `lib/features/home/domain/entities/company_details.dart`
- [x] T008 [P] Define explore criteria and pagination entities in `lib/features/home/domain/entities/explore_criteria.dart` and `lib/features/home/domain/entities/explore_pagination.dart`
- [x] T009 [P] Implement discovery API DTO models for list/recommended/trending/details/reviews in `lib/features/home/data/models/discovery_api_models.dart`
- [x] T010 [P] Implement service-type and query-parameter mapping helpers in `lib/features/home/data/models/discovery_query_mapper.dart`
- [x] T011 Implement discovery remote data source for companies/recommended/trending/details/reviews endpoints in `lib/features/home/data/data_sources/discovery_remote_data_source.dart`
- [x] T012 Implement discovery repository contract and implementation in `lib/features/home/domain/repositories/discovery_repository.dart` and `lib/features/home/data/repositories/discovery_repository_impl.dart`
- [x] T013 [P] Add discovery use cases for recommended/trending/all companies/details/reviews in `lib/features/home/domain/use_cases/discovery_use_cases.dart`
- [x] T014 Wire discovery repository and use cases into providers in `lib/app.dart`

**Checkpoint**: Foundation complete. User stories can now proceed.

---

## Phase 3: User Story 1 - Discover Companies from Home (Priority: P1) 🎯 MVP

**Goal**: Deliver a lead-first Home discovery screen with search entry and three independently loaded horizontal sections.

**Independent Test**: Open Home as a lead user and verify section order, card content, section-level retry isolation, and card navigation to details.

- [x] T015 [US1] Replace placeholder UI with Home discovery layout (search bar first, no greeting/settings/notification) in `lib/features/home/presentation/pages/home_placeholder_page.dart`
- [x] T016 [P] [US1] Create reusable company summary card for Home sections in `lib/features/home/presentation/widgets/company_summary_card.dart`
- [x] T017 [P] [US1] Create reusable horizontal section carousel widget in `lib/features/home/presentation/widgets/company_section_carousel.dart`
- [x] T018 [P] [US1] Create Home section skeleton and inline section-error widgets in `lib/features/home/presentation/widgets/home_section_skeleton.dart`
- [x] T019 [US1] Implement Home discovery state with independent section statuses in `lib/features/home/presentation/cubit/home_discovery_state.dart`
- [x] T020 [US1] Implement Home discovery Cubit with section-level load/retry orchestration in `lib/features/home/presentation/cubit/home_discovery_cubit.dart`
- [x] T021 [US1] Bind Home page to Cubit and render section loading/success/empty/error states in `lib/features/home/presentation/pages/home_placeholder_page.dart`
- [x] T022 [US1] Wire search-bar tap to Explore navigation in `lib/features/home/presentation/pages/home_placeholder_page.dart`
- [x] T023 [US1] Wire company-card tap to details navigation with `companyId` in `lib/features/home/presentation/widgets/company_summary_card.dart`

**Checkpoint**: User Story 1 is fully functional and independently testable.

---

## Phase 4: User Story 2 - Search and Filter in Explore (Priority: P2)

**Goal**: Deliver Explore with dynamic search, single-select service filters, debounce, and infinite scroll pagination.

**Independent Test**: Open Explore, type queries, switch filters, clear filters, and verify debounced updates, empty state, and paginated loading.

- [x] T024 [US2] Create Explore page scaffold with search field and filter region in `lib/features/home/presentation/pages/explore_page.dart`
- [x] T025 [P] [US2] Implement Explore state model (query/filter/pagination/stale guards) in `lib/features/home/presentation/cubit/explore_state.dart`
- [x] T026 [US2] Implement Explore Cubit with 300ms debounce and latest-response-only behavior in `lib/features/home/presentation/cubit/explore_cubit.dart`
- [x] T027 [P] [US2] Create single-select service filter chip widget in `lib/features/home/presentation/widgets/service_filter_chips.dart`
- [x] T028 [P] [US2] Create paginated Explore results list and empty-state card in `lib/features/home/presentation/widgets/explore_results_list.dart`
- [x] T029 [US2] Integrate `infinite_scroll_pagination` with Explore Cubit paging in `lib/features/home/presentation/pages/explore_page.dart`
- [x] T030 [US2] Apply search/city/service query mapping and duplicate-request suppression in `lib/features/home/data/repositories/discovery_repository_impl.dart`
- [x] T031 [US2] Register Explore route and route constant in `lib/core/routing/app_router.dart`

**Checkpoint**: User Story 2 is fully functional and independently testable.

---

## Phase 5: User Story 3 - View Details and Handle Restricted Actions (Priority: P2)

**Goal**: Deliver company details with robust fallback rendering and restricted request-action guidance to onboarding/login.

**Independent Test**: Open company details from Home/Explore, validate all sections and fallbacks, then trigger request action and verify restriction prompt flow.

- [x] T032 [US3] Create Company Details page scaffold in `lib/features/home/presentation/pages/company_details_page.dart`
- [x] T033 [P] [US3] Create details section widgets (header/contact/services/reviews) in `lib/features/home/presentation/widgets/company_details_sections.dart`
- [x] T034 [P] [US3] Implement CompanyDetails state model with fallback-ready view fields in `lib/features/home/presentation/cubit/company_details_state.dart`
- [x] T035 [US3] Implement CompanyDetails Cubit for details load and optional reviews paging in `lib/features/home/presentation/cubit/company_details_cubit.dart`
- [x] T036 [US3] Implement details/reviews repository mapping with normalization fallbacks in `lib/features/home/data/repositories/discovery_repository_impl.dart`
- [x] T037 [P] [US3] Create restricted request-action prompt card with Continue CTA in `lib/features/home/presentation/widgets/restricted_request_prompt_card.dart`
- [x] T038 [US3] Wire lead-only request-action blocking and onboarding/login navigation in `lib/features/home/presentation/pages/company_details_page.dart`
- [x] T039 [US3] Register company-details route with `companyId` path parameter in `lib/core/routing/app_router.dart`

**Checkpoint**: User Story 3 is fully functional and independently testable.

---

## Phase 6: User Story 4 - Restrict Non-Eligible Bottom Tabs (Priority: P3)

**Goal**: Deliver restricted tab experiences (Requests/Offers/Profile) with clear explanation and Browse Companies recovery.

**Independent Test**: Tap Requests, Offers, and Profile in lead context and verify full-screen restriction view plus Browse Companies return to Home.

- [x] T040 [P] [US4] Create reusable full-screen restricted-tab page with Browse Companies action in `lib/features/home/presentation/pages/restricted_tab_page.dart`
- [x] T041 [P] [US4] Implement lead access state resolver model in `lib/features/home/presentation/cubit/lead_access_state.dart`
- [x] T042 [US4] Implement lead access Cubit for deterministic restricted-tab rendering in `lib/features/home/presentation/cubit/lead_access_cubit.dart`
- [x] T043 [US4] Create discovery shell page with Home/Requests/Offers/Profile tab navigation in `lib/features/home/presentation/pages/discovery_shell_page.dart`
- [x] T044 [US4] Register Requests/Offers/Profile routes to restricted-tab experience in `lib/core/routing/app_router.dart`
- [x] T045 [US4] Wire Browse Companies action to return users to Home discovery tab in `lib/features/home/presentation/pages/restricted_tab_page.dart`

**Checkpoint**: User Story 4 is fully functional and independently testable.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final quality, consistency, and readiness checks across stories.

- [x] T046 [P] Finalize discovery/restriction localization copy in `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`
- [x] T047 Regenerate localization output after final copy updates in `lib/core/localization/l10n/AppLocalizations.dart`
- [x] T048 [P] Apply shimmer/image-fallback/accessibility polish in `lib/features/home/presentation/widgets/company_summary_card.dart`
- [x] T049 Validate quickstart scenarios and log results in `specs/028-discover-companies/quickstart.md`
- [x] T050 Run analyzer for discovery feature changes and resolve issues in `lib/features/home/`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Starts immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2.
- **Phase 4 (US2)**: Depends on Phase 2; can run in parallel with US3 if staffed.
- **Phase 5 (US3)**: Depends on Phase 2; can run in parallel with US2 if staffed.
- **Phase 6 (US4)**: Depends on Phase 2 and integrates with Home discovery routes.
- **Phase 7 (Polish)**: Depends on completion of targeted user stories.

### User Story Dependencies

- **US1 (P1)**: No dependency on other stories after Foundational.
- **US2 (P2)**: No strict dependency on US1 logic, but integrates with shared routing and discovery models.
- **US3 (P2)**: No strict dependency on US2 logic, but consumes shared discovery models/repository.
- **US4 (P3)**: Integrates with Home discovery entry and shared lead-access state.

### Within Each User Story

- Build state and reusable widgets before final page integration.
- Connect Cubit/repository orchestration before route wiring and final navigation behavior.
- Validate story acceptance behavior before moving to lower-priority stories.

---

## Parallel Opportunities

- **Setup**: T003 and T004 can run in parallel.
- **Foundational**: T007, T008, T009, T010, and T013 can run in parallel after T006 starts.
- **US1**: T016, T017, and T018 can run in parallel.
- **US2**: T025, T027, and T028 can run in parallel.
- **US3**: T033, T034, and T037 can run in parallel.
- **US4**: T040 and T041 can run in parallel.
- **Polish**: T046 and T048 can run in parallel.

---

## Parallel Example: User Story 1

```bash
Task: "T016 [US1] Create reusable company summary card in lib/features/home/presentation/widgets/company_summary_card.dart"
Task: "T017 [US1] Create horizontal section carousel in lib/features/home/presentation/widgets/company_section_carousel.dart"
Task: "T018 [US1] Create section skeleton/error widgets in lib/features/home/presentation/widgets/home_section_skeleton.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T025 [US2] Implement Explore state model in lib/features/home/presentation/cubit/explore_state.dart"
Task: "T027 [US2] Create service filter chips in lib/features/home/presentation/widgets/service_filter_chips.dart"
Task: "T028 [US2] Create paginated results list in lib/features/home/presentation/widgets/explore_results_list.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T033 [US3] Create company details section widgets in lib/features/home/presentation/widgets/company_details_sections.dart"
Task: "T034 [US3] Implement CompanyDetailsState in lib/features/home/presentation/cubit/company_details_state.dart"
Task: "T037 [US3] Create restricted request prompt card in lib/features/home/presentation/widgets/restricted_request_prompt_card.dart"
```

## Parallel Example: User Story 4

```bash
Task: "T040 [US4] Create restricted tab page in lib/features/home/presentation/pages/restricted_tab_page.dart"
Task: "T041 [US4] Implement lead access state resolver in lib/features/home/presentation/cubit/lead_access_state.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. Validate Home discovery behavior end-to-end.
4. Demo/deploy MVP increment.

### Incremental Delivery

1. Deliver US1 for discovery entry experience.
2. Deliver US2 for search/filter and infinite Explore results.
3. Deliver US3 for details and restricted request flow.
4. Deliver US4 for restricted tabs and recovery navigation.
5. Finish with Phase 7 polish.

### Parallel Team Strategy

1. Team completes Setup + Foundational together.
2. After Foundation:
   - Dev A: US1
   - Dev B: US2
   - Dev C: US3
3. Integrate US4 after shared routing decisions stabilize.
4. Run final polish and acceptance sweep.

---

## Notes

- Every task includes an explicit file path for direct execution.
- `[P]` tasks are scoped to separate files to reduce merge conflicts.
- Story labels map every implementation task to a specific user story.
- Tasks are ordered to preserve independent story validation and incremental release readiness.
