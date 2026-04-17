# Implementation Plan: Service Requests Page

**Branch**: `feature/031-service-requests-page` | **Date**: 2026-04-16 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/031-service-requests-page/spec.md`

## Summary

Implement a complete customer Service Requests experience with server-authoritative filtering, tab counts, preview cards capped to five items, filter-scoped full pages with incremental pagination, and compact request details. The plan reuses existing project dependencies (`infinite_scroll_pagination`, `shimmer`, `intl`) and applies explicit status normalization so UI tabs remain stable even when backend status values vary.

## Technical Context

**Language/Version**: Dart 3.11 (Flutter stable, null-safe)
**Primary Dependencies**: `flutter_bloc`, `go_router`, `dio`, `intl`, `infinite_scroll_pagination`, `shimmer`, `cached_network_image`
**Storage**: N/A (read-only requests data from backend; no new local persistence)
**Testing**: `flutter_test`, `bloc_test`, `mocktail` (widget and cubit tests for new states)
**Target Platform**: Flutter mobile app (Android/iOS)
**Project Type**: Single Flutter mobile application with feature modules
**Performance Goals**: First meaningful content under 2s on warm network, 60fps scrolling, next-page append without blocking UI thread
**Constraints**: Must use centralized theme tokens, support RTL/LTR, keep widgets pure, maintain Cubit-only state management, and avoid hard-coded style values
**Scale/Scope**: 3 user-facing screens (main requests, full filtered list, compact details), tabbed status filtering, and paginated history growth over time

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Gate 1 - Architecture Compliance: PASS. Plan separates presentation (pages/widgets/cubits), domain (entities/use cases/repository contracts), and data (DTO/data source/repository impl).
- Gate 2 - Folder Structure: PASS. Service requests work remains isolated under feature modules, with request-specific logic centered in `features/requests` and only integration touchpoints in shared core routing/DI.
- Gate 3 - State Management: PASS. Cubit-driven state for main list, pagination flow, and details loading.
- Gate 4 - Theme Usage: PASS. Contracts and quickstart enforce AppTheme token usage only.
- Gate 5 - Design Match: PASS. Planned layout adheres to provided spec constraints and card-based structure.
- Gate 6 - No Logic in Widgets: PASS. Mapping/filtering/pagination behavior is defined in domain/cubit layers.
- Gate 7 - Responsiveness: PASS. Main and full list views include responsive behavior expectations.
- Gate 8 - Code Quality: PASS. Dedicated states, explicit error handling, and targeted tests are planned.
- Gate 9 - Package Check: PASS. Package-first research completed and documented in `research.md`.

## Project Structure

### Documentation (this feature)

```text
specs/031-service-requests-page/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- customer-service-requests-contract.md
`-- checklists/
    `-- requirements.md
```

### Source Code (repository root)

```text
lib/
|-- core/
|   |-- routing/
|   |   `-- app_router.dart                         (update routes for full-list/details navigation)
|   |-- localization/
|   |   `-- l10n/
|   |       |-- app_en.arb                          (add requests strings)
|   |       `-- app_ar.arb                          (add requests strings)
|   `-- theme/                                      (reuse AppColors/AppTypography/AppDimensions)
|-- features/
|   |-- requests/
|   |   |-- presentation/
|   |   |   |-- cubit/
|   |   |   |   `-- customer_requests_cubit.dart   (extend for filtered preview + pagination states)
|   |   |   |-- pages/
|   |   |   |   |-- customer_requests_page.dart    (update main page UX)
|   |   |   |   `-- request_details_page.dart       (new compact details page)
|   |   |   `-- widgets/
|   |   |       `-- request_card.dart               (new reusable card/skeleton widget)
|   |   |-- domain/                                 (new request entities/use cases/contracts)
|   |   `-- data/                                   (new request DTO/repository wiring)
|   `-- home/
|       |-- data/data_sources/
|       |   `-- customer_requests_remote_data_source.dart   (reuse list/details endpoints)
|       |-- domain/use_cases/
|       |   `-- get_customer_service_requests_use_case.dart (reuse/adapt as needed)
|       `-- domain/repositories/
|           `-- customer_requests_repository.dart            (integration touchpoint)
`-- app.dart                                         (register any new request cubits/use cases)

test/
`-- features/
    `-- requests/
        |-- presentation/
        |   |-- customer_requests_cubit_test.dart
        |   `-- request_details_page_test.dart
        `-- domain/
            `-- status_normalization_test.dart
```

**Structure Decision**: Keep routing and shared integrations in `core`, but center service-request business behavior in `features/requests` (presentation/domain/data). Existing list/details HTTP methods in home data sources are reused as integration points to minimize regression risk while preserving feature-focused ownership for new behavior.

## Complexity Tracking

No constitutional violations identified.

## Phase 0 Research Output

- Completed: [research.md](./research.md)
- All technical unknowns resolved, including:
  - package choice and package-first compliance for pagination/loading/date formatting
  - backend-authoritative filtering and count synchronization strategy
  - explicit status normalization map and unknown-status handling
  - compact details scope and dual-CTA empty/error strategy

## Phase 1 Design Output

- Completed: [data-model.md](./data-model.md)
- Completed: [contracts/customer-service-requests-contract.md](./contracts/customer-service-requests-contract.md)
- Completed: [quickstart.md](./quickstart.md)
- Agent context update: completed via `.specify/scripts/powershell/update-agent-context.ps1 -AgentType copilot`

## Post-Design Constitution Check

- Gate 1 - Architecture Compliance: PASS. Data/domain/presentation boundaries are explicit in data model and contract outputs.
- Gate 2 - Folder Structure: PASS. Feature-scoped request artifacts are defined with clear module ownership.
- Gate 3 - State Management: PASS. Cubit state transitions documented for main, full-list, and details flows.
- Gate 4 - Theme Usage: PASS. Quickstart requires centralized theme tokens.
- Gate 5 - Design Match: PASS. Contract codifies required labels, tabs, CTA behavior, and compact details scope.
- Gate 6 - No Logic in Widgets: PASS. Normalization/filter/pagination rules are modeled outside widgets.
- Gate 7 - Responsiveness: PASS. Quickstart includes responsive validation checkpoints.
- Gate 8 - Code Quality: PASS. Validation rules, explicit transitions, and planned tests are documented.
- Gate 9 - Package Check: PASS. Research records package selection rationale and alternatives.
