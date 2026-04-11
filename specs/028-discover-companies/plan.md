# Implementation Plan: Explore and Discover Companies for Leads

**Branch**: `028-discover-companies` | **Date**: 2026-04-11 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/028-discover-companies/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Replace the current Home placeholder flow with a lead-first discovery experience that exposes Recommended, Trending, and All Companies sections; adds Explore search/filter with debounce and infinite pagination; adds Company Details; and enforces lead restriction gates for request actions and bottom tabs. Implementation will follow feature-based Clean Architecture in the Home feature, use existing Dio + Cubit stack, and integrate package-first choices for pagination, debouncing, and network image caching.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart 3.11 (Flutter stable, null-safe)  
**Primary Dependencies**: `flutter_bloc`, `go_router`, `dio`, `flutter_localizations`, `infinite_scroll_pagination` (planned), `easy_debounce` (planned), `cached_network_image` (planned)  
**Storage**: Session and lightweight local state via existing secure/local auth storage; no new persistent domain storage for discovery  
**Testing**: `flutter_test`, `bloc_test`, `mocktail` with widget tests for Home/Explore/details and Cubit tests for state transitions  
**Target Platform**: Flutter mobile app (Android/iOS)
**Project Type**: Single Flutter mobile application with feature modules  
**Performance Goals**: Initial visible discovery content within <2s on average network, smooth 60fps scrolling, debounce-driven search updates without stale flashes  
**Constraints**: Follow existing design tokens, single-select service filter, 300ms debounce, lead-context restricted actions, section-level error isolation, no backend contract changes  
**Scale/Scope**: One feature flow across Home discovery, Explore, Company Details, and restricted tabs using 4 customer-portal read endpoints + onboarding handoff

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

- Gate 1 - Architecture Compliance: PASS. Plan keeps networking/data mapping in data layer, orchestration in use-cases/repository, and rendering/state in presentation Cubits/widgets.
- Gate 2 - Folder Structure: PASS. Work is scoped to feature-based module expansion under `lib/features/home/` and shared core layers.
- Gate 3 - State Management: PASS. Uses Cubit and immutable state models; no `setState` app-state orchestration.
- Gate 4 - Theme Usage: PASS. UI follows `AppColors`, `AppTypography`, and `AppDimensions` tokens.
- Gate 5 - Design Match: PASS. Existing design system constraints are explicit in requirements.
- Gate 6 - No Logic in Widgets: PASS. Search/filter/pagination/gating logic is planned in Cubit + mappers.
- Gate 7 - Responsiveness: PASS. Flow includes card/list layouts designed for small and large phone breakpoints.
- Gate 8 - Code Quality: PASS. Plan includes dedicated state handling, error isolation, and test coverage.
- Gate 9 - Package Check: PASS. Phase 0 research includes pub.dev evaluation and documented package decisions.

## Project Structure

### Documentation (this feature)

```text
specs/028-discover-companies/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- discovery-api-contract.md
`-- tasks.md
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
lib/
|-- core/
|   |-- networking/
|   |-- routing/
|   |-- theme/
|   |-- localization/
|   `-- widgets/
|-- features/
|   |-- auth/
|   |-- splash/
|   |-- onboarding/
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
`-- app.dart

test/
`-- features/
  |-- auth/
  |-- onboarding/
  `-- home/
```

**Structure Decision**: Expand the existing `home` feature from placeholder-only presentation into full data/domain/presentation layers for discovery use-cases, keeping routing and shared style concerns in existing core modules.

## Complexity Tracking

No constitutional violations identified.

## Phase 0 Research Output

- Completed: [research.md](./research.md)
- All technical unknowns resolved, including:
  - package-first choices for pagination, debounce, image caching, and skeleton loading
  - router strategy to allow discovery entry while preserving lead restrictions
  - API query normalization and service-type value mapping across endpoint variants

## Phase 1 Design Output

- Completed: [data-model.md](./data-model.md)
- Completed: [contracts/discovery-api-contract.md](./contracts/discovery-api-contract.md)
- Completed: [quickstart.md](./quickstart.md)
- Agent context updated via `.specify/scripts/powershell/update-agent-context.ps1 -AgentType copilot`

## Post-Design Constitution Check

- Gate 1 - Architecture Compliance: PASS. Contract and model decisions keep mapping/repository logic in data/domain layers and UI logic in Cubits.
- Gate 2 - Folder Structure: PASS. Planned implementation remains within feature-first `home` module boundaries.
- Gate 3 - State Management: PASS. Async section isolation and pagination/search orchestration remain Cubit-based.
- Gate 4 - Theme Usage: PASS. Quickstart mandates shared theme token usage.
- Gate 5 - Design Match: PASS. Clarified UI behavior and restriction UX are captured in contracts and quickstart.
- Gate 6 - No Logic in Widgets: PASS. Search debounce, stale request handling, and gating are modeled outside widgets.
- Gate 7 - Responsiveness: PASS. Card/list layouts and breakpoints are explicit in feature requirements and quickstart validation.
- Gate 8 - Code Quality: PASS. Plan includes focused widget/Cubit tests and section-level error handling.
- Gate 9 - Package Check: PASS. Research documents package evaluations, rationale, and alternatives.
