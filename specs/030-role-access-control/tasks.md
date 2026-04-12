# Tasks: User Roles & Access Control System

**Input**: Design documents from `/specs/030-role-access-control/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/customer-portal-role-access-contract.md, quickstart.md

**Tests**: Dedicated test-first tasks are intentionally omitted because the specification does not explicitly request TDD/test-first task generation.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare project scaffolding and shared configuration needed before core role-access work.

- [ ] T001 Add role-access localization keys for navigation, restrictions, and request-flow prompts in `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`
- [ ] T002 Regenerate localization output after key additions in `lib/core/localization/l10n/AppLocalizations.dart`
- [ ] T003 [P] Create session-core scaffolding files in `lib/core/session/session_cubit.dart`, `lib/core/session/session_state.dart`, `lib/core/session/role_resolver.dart`, and `lib/core/session/pending_intent_store.dart`
- [ ] T004 [P] Add route placeholders for new request/settings/view-all destinations in `lib/core/routing/app_router.dart`
- [ ] T005 Wire initial dependency registration placeholders for session and role-access services in `lib/app.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build shared session, guard, and auth-recovery infrastructure that blocks all stories.

**⚠️ CRITICAL**: No user story implementation should begin until this phase is complete.

- [ ] T006 Implement canonical session role and user state models in `lib/core/session/session_state.dart`
- [ ] T007 [P] Implement role resolution rules (Guest/Lead/Customer with nullable customerId semantics) in `lib/core/session/role_resolver.dart`
- [ ] T008 [P] Implement mandatory pending-intent persistence store for request continuation in `lib/core/session/pending_intent_store.dart`
- [ ] T009 Implement global SessionCubit lifecycle (load, persist, login, logout, refresh-sync, intent resume) in `lib/core/session/session_cubit.dart`
- [ ] T010 [P] Integrate SessionCubit provisioning and lifecycle bootstrap in `lib/app.dart`
- [ ] T011 Refactor 401 handling to a single refresh attempt with deterministic guest fallback in `lib/core/networking/auth_interceptor.dart`
- [ ] T012 [P] Extend auth repository interfaces for session refresh/update hooks used by SessionCubit in `lib/features/auth/domain/repositories/auth_repository.dart` and `lib/features/auth/data/repositories/auth_repository_impl.dart`
- [ ] T013 Implement centralized role-guard use cases for tab/action restrictions in `lib/features/home/domain/use_cases/role_guard_use_cases.dart`
- [ ] T014 Wire SessionCubit and role guard into access control cubits in `lib/features/home/presentation/cubit/lead_access_cubit.dart` and `lib/features/home/presentation/cubit/lead_access_state.dart`

**Checkpoint**: Foundational infrastructure complete. User stories can now proceed.

---

## Phase 3: User Story 1 - Guest Browsing with Guided Restrictions (Priority: P1) 🎯 MVP

**Goal**: Allow guests to browse companies while providing deterministic restrictions and onboarding guidance.

**Independent Test**: Start with no token, browse companies/details/reviews, tap Request Service, and verify guest-only navigation and restriction guidance.

- [ ] T015 [US1] Implement guest-aware access-state transitions and restricted-destination decisions in `lib/features/home/presentation/cubit/lead_access_state.dart`
- [ ] T016 [US1] Refactor access cubit to consume SessionCubit role state for guest decisions in `lib/features/home/presentation/cubit/lead_access_cubit.dart`
- [ ] T017 [P] [US1] Add guest-specific restricted empty-state messaging and onboarding CTA behavior in `lib/features/home/presentation/pages/restricted_tab_page.dart`
- [ ] T018 [US1] Implement Guest bottom navigation composition (Companies + Sign In only) in `lib/features/home/presentation/pages/discovery_shell_page.dart`
- [ ] T019 [US1] Wire guest Sign In navigation to onboarding destination in `lib/features/home/presentation/pages/discovery_shell_page.dart` and `lib/core/routing/app_router.dart`
- [ ] T020 [US1] Ensure browse routes remain accessible without auth blocking in `lib/core/routing/app_router.dart`
- [ ] T021 [US1] Enforce guest Request Service restriction modal flow (Continue -> onboarding, Cancel -> dismiss) in `lib/features/home/presentation/pages/company_details_page.dart` and `lib/features/home/presentation/cubit/company_details_cubit.dart`
- [ ] T022 [US1] Finalize guest restriction copy and labels in `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`

**Checkpoint**: User Story 1 is independently functional and verifiable.

---

## Phase 4: User Story 2 - Lead Request Submission and Conversion Prompt (Priority: P1)

**Goal**: Enable lead users to open New Service Request, submit to service-requests endpoint, and trigger re-login conversion flow.

**Independent Test**: Login as Lead (customerId null), open company details, navigate to New Service Request with companyId, submit, and verify re-login modal flow.

- [ ] T023 [P] [US2] Create service request request/response DTO models for customer-portal submit contract in `lib/features/home/data/models/service_request_models.dart`
- [ ] T024 [P] [US2] Implement service request remote datasource for `POST /api/customer-portal/service-requests` in `lib/features/home/data/data_sources/service_request_remote_data_source.dart`
- [ ] T025 [US2] Implement service request repository contract and implementation in `lib/features/home/domain/repositories/service_request_repository.dart` and `lib/features/home/data/repositories/service_request_repository_impl.dart`
- [ ] T026 [US2] Add submit-request use case orchestration in `lib/features/home/domain/use_cases/service_request_use_cases.dart`
- [ ] T027 [P] [US2] Create New Service Request Cubit and state models in `lib/features/home/presentation/cubit/new_service_request_cubit.dart` and `lib/features/home/presentation/cubit/new_service_request_state.dart`
- [ ] T028 [P] [US2] Build placeholder New Service Request page and form accepting companyId in `lib/features/home/presentation/pages/new_service_request_page.dart` and `lib/features/home/presentation/widgets/new_service_request_form.dart`
- [ ] T029 [US2] Register New Service Request route with companyId handling in `lib/core/routing/app_router.dart`
- [ ] T030 [US2] Route Lead Request Service action from company details to New Service Request with companyId in `lib/features/home/presentation/pages/company_details_page.dart`
- [ ] T031 [US2] Implement post-submit lead re-login modal flow (Continue -> login, Cancel -> stay) in `lib/features/home/presentation/pages/new_service_request_page.dart`
- [ ] T032 [US2] Persist and resume pending request intent across login boundary in `lib/core/session/session_cubit.dart` and `lib/features/auth/presentation/cubit/login_cubit.dart`

**Checkpoint**: User Story 2 is independently functional and verifiable.

---

## Phase 5: User Story 3 - Customer Full Access and Direct Service Requests (Priority: P1)

**Goal**: Provide customer-access destinations and direct request flow completion through shared service-request endpoint.

**Independent Test**: Login as Customer, access Companies/Requests/Offers/Profile/Settings, submit Request Service with companyId, and confirm success navigation to Requests.

- [ ] T033 [US3] Implement customer navigation composition and destination switching in `lib/features/home/presentation/pages/discovery_shell_page.dart`
- [ ] T034 [P] [US3] Create customer requests page with cubit and API wiring to `GET /api/customer-portal/my/service-requests` in `lib/features/home/presentation/pages/customer_requests_page.dart` and `lib/features/home/presentation/cubit/customer_requests_cubit.dart`
- [ ] T035 [P] [US3] Create customer offers page with cubit and API wiring to `GET /api/customer-portal/my/offers` in `lib/features/home/presentation/pages/customer_offers_page.dart` and `lib/features/home/presentation/cubit/customer_offers_cubit.dart`
- [ ] T036 [P] [US3] Create customer profile page with cubit and API wiring to `GET /api/customer-portal/my/profile` in `lib/features/home/presentation/pages/customer_profile_page.dart` and `lib/features/home/presentation/cubit/customer_profile_cubit.dart`
- [ ] T037 [US3] Register customer content routes for Requests/Offers/Profile in `lib/core/routing/app_router.dart`
- [ ] T038 [US3] Ensure customer Request Service action passes companyId to New Service Request in `lib/features/home/presentation/pages/company_details_page.dart` and `lib/features/home/presentation/cubit/company_details_cubit.dart`
- [ ] T039 [US3] Route successful customer request submissions to Requests destination in `lib/features/home/presentation/cubit/new_service_request_cubit.dart` and `lib/features/home/presentation/pages/new_service_request_page.dart`
- [ ] T040 [US3] Integrate lead profile endpoint usage for lead-access profile destination in `lib/features/home/presentation/pages/lead_profile_page.dart` and `lib/core/routing/app_router.dart`
- [ ] T041 [US3] Replace unrestricted placeholders with real customer destination screens in `lib/features/home/presentation/pages/discovery_shell_page.dart`

**Checkpoint**: User Story 3 is independently functional and verifiable.

---

## Phase 6: User Story 4 - Dynamic Navigation and Company Discovery Entry Points (Priority: P2)

**Goal**: Deliver role-reactive shell navigation, Companies dropdown destinations, view-all pages, and search-bar routing to Explore.

**Independent Test**: Transition roles in one session, verify Companies dropdown entries, view-all pages, search-bar tap to Explore, and role-specific settings routing.

- [ ] T042 [US4] Implement Companies dropdown navigation widget with All/Recommended/Trending options in `lib/features/home/presentation/widgets/companies_nav_dropdown.dart` and `lib/features/home/presentation/pages/discovery_shell_page.dart`
- [ ] T043 [US4] Create All Companies view-all page with top search-bar to Explore behavior in `lib/features/home/presentation/pages/all_companies_page.dart`
- [ ] T044 [P] [US4] Create Recommended view-all page with top search-bar to Explore behavior in `lib/features/home/presentation/pages/recommended_companies_page.dart`
- [ ] T045 [P] [US4] Create Trending view-all page with top search-bar to Explore behavior in `lib/features/home/presentation/pages/trending_companies_page.dart`
- [ ] T046 [US4] Register companies dropdown destination routes in `lib/core/routing/app_router.dart`
- [ ] T047 [US4] Enforce home section limited-subset rendering and View All CTA wiring in `lib/features/home/presentation/pages/home_placeholder_page.dart` and `lib/features/home/presentation/cubit/home_discovery_cubit.dart`
- [ ] T048 [US4] Add role-specific settings routes and page scaffolds (`/my/lead-settings`, `/my/settings`) in `lib/core/routing/app_router.dart`, `lib/features/home/presentation/pages/lead_settings_page.dart`, and `lib/features/home/presentation/pages/customer_settings_page.dart`
- [ ] T049 [US4] Wire role-based settings destination selection in `lib/features/home/presentation/pages/discovery_shell_page.dart` and `lib/features/home/presentation/cubit/lead_access_state.dart`
- [ ] T050 [US4] Reuse shared search-bar tap contract to Explore across view-all pages in `lib/features/home/presentation/pages/all_companies_page.dart`, `lib/features/home/presentation/pages/recommended_companies_page.dart`, and `lib/features/home/presentation/pages/trending_companies_page.dart`

**Checkpoint**: User Story 4 is independently functional and verifiable.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency, hardening, and readiness checks across all stories.

- [ ] T051 [P] Finalize role-aware localization copy and accessibility labels in `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`
- [ ] T052 Regenerate localization outputs after final copy updates in `lib/core/localization/l10n/AppLocalizations.dart`
- [ ] T053 [P] Run analyzer and resolve issues in `lib/core/`, `lib/features/auth/`, and `lib/features/home/`
- [ ] T054 Validate end-to-end role transition and continuation scenarios in `specs/030-role-access-control/quickstart.md`
- [ ] T055 [P] Update implementation notes for delivered scope and residual risks in `specs/030-role-access-control/plan.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Starts immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2.
- **Phase 4 (US2)**: Depends on Phase 2.
- **Phase 5 (US3)**: Depends on Phase 2 and shares New Service Request flow from US2.
- **Phase 6 (US4)**: Depends on Phase 2 and integrates with discovery shell/navigation.
- **Phase 7 (Polish)**: Depends on completion of desired user stories.

### User Story Dependencies

- **US1 (P1)**: Independent after foundational completion.
- **US2 (P1)**: Independent after foundational completion.
- **US3 (P1)**: Depends on shared request submission foundation from US2 route/cubit artifacts.
- **US4 (P2)**: Depends on foundational role/session/navigation wiring and integrates with US1 shell behavior.

### Within Each User Story

- State and domain/repository wiring before page integration.
- Page integration before route wiring and final navigation behavior.
- Completion check against story independent-test criteria before moving on.

---

## Parallel Opportunities

- **Setup**: T003 and T004 can run in parallel.
- **Foundational**: T007, T008, T010, and T012 can run in parallel after T006 starts.
- **US1**: T017 and T018 can run in parallel.
- **US2**: T023, T024, T027, and T028 can run in parallel.
- **US3**: T034, T035, and T036 can run in parallel.
- **US4**: T044 and T045 can run in parallel.
- **Polish**: T051 and T053 can run in parallel.

---

## Parallel Example: User Story 1

```bash
Task: "T017 [US1] Add guest restricted empty-state messaging in lib/features/home/presentation/pages/restricted_tab_page.dart"
Task: "T018 [US1] Implement Guest bottom navigation composition in lib/features/home/presentation/pages/discovery_shell_page.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T023 [US2] Create service request DTO models in lib/features/home/data/models/service_request_models.dart"
Task: "T024 [US2] Implement service request remote datasource in lib/features/home/data/data_sources/service_request_remote_data_source.dart"
Task: "T027 [US2] Create NewServiceRequestCubit/state in lib/features/home/presentation/cubit/"
Task: "T028 [US2] Build new service request page/form in lib/features/home/presentation/pages/new_service_request_page.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T034 [US3] Create customer requests page + cubit in lib/features/home/presentation/pages/customer_requests_page.dart"
Task: "T035 [US3] Create customer offers page + cubit in lib/features/home/presentation/pages/customer_offers_page.dart"
Task: "T036 [US3] Create customer profile page + cubit in lib/features/home/presentation/pages/customer_profile_page.dart"
```

## Parallel Example: User Story 4

```bash
Task: "T044 [US4] Create recommended companies view-all page in lib/features/home/presentation/pages/recommended_companies_page.dart"
Task: "T045 [US4] Create trending companies view-all page in lib/features/home/presentation/pages/trending_companies_page.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. Validate guest browsing and guided restrictions independently.
4. Demo/deploy MVP increment.

### Incremental Delivery

1. Deliver US1 for guest-safe discovery and restriction guidance.
2. Deliver US2 for lead request submission and conversion trigger.
3. Deliver US3 for customer full-access surfaces and shared request submit path.
4. Deliver US4 for dynamic navigation, companies dropdown, and view-all entry points.
5. Finish with cross-cutting polish and validation.

### Parallel Team Strategy

1. Team completes Setup + Foundational together.
2. After Foundational:
   - Developer A: US1
   - Developer B: US2
   - Developer C: US3
3. Developer D can begin US4 once shared shell contracts stabilize.
4. Complete polish with shared validation pass.

---

## Notes

- All tasks use explicit file paths to keep execution unambiguous.
- `[P]` tasks are scoped to independent files to reduce merge conflicts.
- Story labels map implementation work to spec user stories.
- Checkpoints are included to preserve independently testable increments.
