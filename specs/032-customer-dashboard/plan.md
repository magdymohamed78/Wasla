# Implementation Plan: Customer Dashboard Home Section

**Branch**: `032-add-customer-dashboard` | **Date**: 2026-04-19 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/032-customer-dashboard/spec.md`

## Summary

Implement a customer-only dashboard module on Home (below search, above companies) with four animated metric cards (Total Offers, Accepted Offers, Pending Offers, My Reviews), strict role-gated rendering, and navigation-driven actions. Reuse existing offers filtering/state logic and add a dedicated My Reviews flow (paginated list + edit/delete) through the existing customer-portal repository stack, while preserving centralized theming, RTL behavior, section-level loading/error states, and same-session count synchronization.

## Technical Context

**Language/Version**: Dart 3.11 (Flutter stable, null-safe)
**Primary Dependencies**: `flutter_bloc`, `go_router`, `dio`, `intl`, `shimmer`, `cached_network_image`, `modal_bottom_sheet`, `flutter_rating_bar` (new)
**Storage**: N/A (read/write through backend API only; no new local persistence)
**Testing**: `flutter_test`, `bloc_test`, `mocktail` (cubit + widget tests for dashboard and review actions)
**Target Platform**: Flutter mobile app (Android/iOS)
**Project Type**: Single Flutter mobile application with feature-based modules
**Performance Goals**: Dashboard metrics rendered within 2s on standard network, smooth 60fps scrolling in My Reviews, non-blocking section updates
**Constraints**: Must follow Clean Architecture and Cubit-only state, use AppTheme tokens only, maintain full RTL parity, use route-query filter contract for offers
**Scale/Scope**: 2 user-facing surfaces (Home dashboard section + My Reviews page), 2 cubits, 3 review endpoints, integration with existing offers flow

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Gate 1 - Architecture Compliance: PASS. Plan keeps presentation/domain/data separation and extends existing customer-portal repository abstractions.
- Gate 2 - Folder Structure: PASS. New code remains in feature modules (`home`, `reviews`, `offers`) with shared routing/core updates only where required.
- Gate 3 - State Management: PASS. Dashboard and My Reviews are Cubit-driven with immutable state transitions.
- Gate 4 - Theme Usage: PASS. UI contract requires AppColors/AppTypography/AppDimensions; no hard-coded styling values.
- Gate 5 - Design Match: PASS. Grid+card layout, icon treatment, spacing rules, and interaction requirements are preserved from spec.
- Gate 6 - No Logic in Widgets: PASS. Aggregation, filtering, and API mutation behavior is confined to cubits/use cases/repositories.
- Gate 7 - Responsiveness: PASS. Design artifacts include mobile-first two-column behavior and RTL layout checks.
- Gate 8 - Code Quality: PASS. Error handling, retry states, and test expectations are explicitly defined.
- Gate 9 - Package Check: PASS. Package-first research is completed in [research.md](./research.md), including adoption-quality comparison and selection rationale.

## Project Structure

### Documentation (this feature)

```text
specs/032-customer-dashboard/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- customer-dashboard-contract.md
`-- checklists/
    `-- requirements.md
```

### Source Code (repository root)

```text
lib/
|-- core/
|   |-- routing/
|   |   `-- app_router.dart                                  (add my-reviews route + offers filter query parsing)
|   `-- localization/l10n/
|       |-- app_en.arb                                       (new dashboard/reviews strings)
|       `-- app_ar.arb                                       (new dashboard/reviews strings)
|-- features/
|   |-- home/
|   |   |-- presentation/
|   |   |   |-- pages/home_page.dart                         (insert customer dashboard section)
|   |   |   |-- cubit/dashboard_cubit.dart                   (new)
|   |   |   |-- cubit/dashboard_state.dart                   (new)
|   |   |   `-- widgets/dashboard/                           (new dashboard cards, skeleton, error widget)
|   |   |-- domain/repositories/customer_reviews_repository.dart (new interface)
|   |   |-- data/data_sources/customer_reviews_remote_data_source.dart (new)
|   |   `-- data/models/customer_review_dto.dart             (new)
|   |-- reviews/
|   |   `-- presentation/
|   |       |-- pages/my_reviews_page.dart                   (new)
|   |       |-- cubit/my_reviews_cubit.dart                  (new)
|   |       |-- cubit/my_reviews_state.dart                  (new)
|   |       `-- widgets/                                     (new review card/edit/delete dialogs)
|   `-- offers/
|       `-- presentation/pages/customer_offers_page.dart     (support initial filter from route query)
`-- app.dart                                                 (wire new repository/use case providers)

test/
`-- features/
    |-- home/presentation/cubit/dashboard_cubit_test.dart
    `-- reviews/presentation/
        |-- my_reviews_cubit_test.dart
        `-- my_reviews_page_test.dart
```

**Structure Decision**: Keep customer-portal API integration centralized under `features/home/data` (matching existing requests/offers/profile patterns), and keep UI concerns split by user surface (`home` dashboard embedding + dedicated `reviews` presentation feature). This minimizes duplication and preserves established DI/repository composition in `app.dart`.

## Complexity Tracking

No constitutional violations identified.

## Phase 0 Research Output

- Completed: [research.md](./research.md)
- All technical unknowns resolved, including:
  - package-first decision for rating selector and animation approach
  - offers-metric reuse strategy without duplicate business logic
  - review API contract behavior (pagination + update/delete semantics)
  - same-session count synchronization between My Reviews and Home dashboard

## Phase 1 Design Output

- Completed: [data-model.md](./data-model.md)
- Completed: [contracts/customer-dashboard-contract.md](./contracts/customer-dashboard-contract.md)
- Completed: [quickstart.md](./quickstart.md)
- Agent context update: completed via `.specify/scripts/powershell/update-agent-context.ps1 -AgentType copilot`

## Post-Design Constitution Check

- Gate 1 - Architecture Compliance: PASS. Data/domain/presentation ownership is explicit in model + contract artifacts.
- Gate 2 - Folder Structure: PASS. Feature placement is defined with bounded integration touchpoints.
- Gate 3 - State Management: PASS. Dashboard and My Reviews state machines are cubit-centric and independently recoverable.
- Gate 4 - Theme Usage: PASS. Contracts enforce tokenized theme usage and no hard-coded visual values.
- Gate 5 - Design Match: PASS. Grid layout, card visual behavior, and interaction contract are codified.
- Gate 6 - No Logic in Widgets: PASS. Data aggregation, edit/delete workflows, and count sync live outside widgets.
- Gate 7 - Responsiveness: PASS. Quickstart includes small-phone/large-phone/tablet and RTL verification checkpoints.
- Gate 8 - Code Quality: PASS. Validation, error, and retry behavior are deterministic and testable.
- Gate 9 - Package Check: PASS. Package comparison and selection rationale are documented in research artifacts.
