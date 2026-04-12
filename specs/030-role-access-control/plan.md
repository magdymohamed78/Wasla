# Implementation Plan: User Roles & Access Control System

**Branch**: `feature/030-role-access-control` | **Date**: 2026-04-12 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/030-role-access-control/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Implement a role-aware customer-portal experience with dynamic bottom navigation, guarded actions, and deterministic transitions across Guest, Lead, and Customer states. The implementation will center on a global SessionCubit + role resolver, one-attempt refresh-token recovery, mandatory pending-intent resume for interrupted Request Service flow, and API integration aligned to Swagger customer-portal endpoints (login, refresh, companies, service-requests, profile/offers).

## Technical Context

**Language/Version**: Dart 3.11 (Flutter stable, null-safe)  
**Primary Dependencies**: `flutter_bloc`, `go_router`, `dio`, `flutter_secure_storage`, `shared_preferences`, `infinite_scroll_pagination`, `easy_debounce`, `cached_network_image`  
**Storage**: Secure token/session persistence in `flutter_secure_storage`; lightweight UI/session flags (including pending intent fallback metadata) in app-local persistence where needed  
**Testing**: `flutter_test`, `bloc_test`, `mocktail` with Cubit, guard, and widget navigation coverage  
**Target Platform**: Flutter mobile app (Android/iOS)
**Project Type**: Single Flutter mobile application with feature-based modules  
**Performance Goals**: Smooth role-driven shell transitions, no duplicate refresh races, and visible company listings within acceptable mobile latency on average networks (<2s target for first content)  
**Constraints**: No business logic in UI widgets, one refresh attempt on 401, mandatory pending-intent continuation for Request Service, role-specific settings routes, strict Swagger endpoint alignment for customer-portal APIs  
**Scale/Scope**: One cross-feature flow touching session/auth handling, home/discovery navigation, New Service Request entry/submit path, guarded destinations, and customer-portal data surfaces

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Gate 1 - Constitution enforceability: PASS (provisional). Current constitution file is a template with placeholders and no enforceable project-specific rules; planning proceeds under repository conventions.
- Gate 2 - Architecture boundaries: PASS. Plan keeps role resolution, guard logic, and refresh orchestration in Cubits/services/repositories rather than UI layer.
- Gate 3 - State management consistency: PASS. Global SessionCubit is the source of truth; feature Cubits consume resolved role and guard outputs.
- Gate 4 - API contract integrity: PASS. Endpoints and role capabilities are mapped to Swagger customer-portal contracts.
- Gate 5 - UX consistency: PASS. Restriction modal and empty-state components are reused across guarded destinations.
- Gate 6 - Testability: PASS. Plan includes deterministic tests for role transitions, refresh fallback, pending intent resume, and route-level guards.

## Project Structure

### Documentation (this feature)

```text
specs/030-role-access-control/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- customer-portal-role-access-contract.md
`-- tasks.md
```

### Source Code (repository root)

```text
lib/
|-- core/
|   |-- localization/
|   |-- networking/
|   |-- routing/
|   |-- theme/
|   |-- utils/
|   `-- widgets/
|-- features/
|   |-- auth/
|   |-- onboarding/
|   |-- splash/
|   |-- support/
|   `-- home/
|       |-- data/
|       |   |-- data_sources/
|       |   |-- models/
|       |   `-- repositories/
|       |-- domain/
|       |   |-- entities/
|       |   |-- repositories/
|       |   `-- use_cases/
|       `-- presentation/
|           |-- cubit/
|           |-- pages/
|           `-- widgets/
|-- app.dart
`-- main.dart

test/
`-- features/
```

**Structure Decision**: Keep implementation inside the existing Flutter feature architecture, expanding session/guard wiring and home flow behaviors without introducing a new project boundary.

## Complexity Tracking

No constitutional violations requiring justification.

## Phase 0 Research Output

- Completed: [research.md](./research.md)
- All technical unknowns resolved, including:
  - role resolution semantics from JWT/customerId claims and clarified product rules
  - single-attempt refresh strategy and deterministic fallback behavior
  - endpoint-level alignment to Swagger for service requests, profiles, offers, and request history
  - mandatory pending-intent persistence and resume rules

## Phase 1 Design Output

- Completed: [data-model.md](./data-model.md)
- Completed: [contracts/customer-portal-role-access-contract.md](./contracts/customer-portal-role-access-contract.md)
- Completed: [quickstart.md](./quickstart.md)
- Agent context updated via `.specify/scripts/powershell/update-agent-context.ps1 -AgentType copilot`

## Post-Design Constitution Check

- Gate 1 - Constitution enforceability: PASS (provisional). No enforceable constitution clauses introduced by design artifacts.
- Gate 2 - Architecture boundaries: PASS. Data model and contracts keep business rules in session/guard/domain layers.
- Gate 3 - State management consistency: PASS. Design keeps one source of truth with explicit transition states.
- Gate 4 - API contract integrity: PASS. Contracts reference concrete Swagger endpoints and DTO contracts.
- Gate 5 - UX consistency: PASS. Shared modal/empty-state models remain canonical.
- Gate 6 - Testability: PASS. Quickstart validation includes role transition, refresh, and continuation scenarios.
