<!--
===============================================================================
  SYNC IMPACT REPORT
===============================================================================
  Version Change  : 1.0.0 → 1.1.0
  Modified Principles : Added Principle XI (Package-First Development)
  Added Sections  :
    - Core Principles (11 principles)
    - Technology Stack
    - Quality Gates
    - Governance
  Removed Sections: N/A

  Templates Requiring Updates:
    - .specify/templates/plan-template.md  ✅ (Compatible)
    - .specify/templates/spec-template.md  ✅ (Compatible)
    - .specify/templates/tasks-template.md ✅ (Compatible)

  Follow-up TODOs: None
===============================================================================
-->

# Wasla Constitution

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [Technology Stack](#technology-stack)
3. [Quality Gates](#quality-gates)
4. [Governance](#governance)

---

## Core Principles

---

### I. Clean Architecture (NON-NEGOTIABLE)

All code MUST follow Clean Architecture with strict separation between three layers:

| Layer | Contents | Responsibility |
|---|---|---|
| **Presentation** | Widgets, Cubits, UI components | User interaction and state presentation only |
| **Domain** | Use cases, entities, repository interfaces | Business logic with zero framework dependencies |
| **Data** | Repository implementations, data sources, models | API calls, local storage, and data mapping |

> **Rationale**: Clear boundaries enable independent testing, easier maintenance, and flexibility to swap implementations without affecting business logic.

---

### II. Feature-Based Modular Structure (NON-NEGOTIABLE)

Every feature MUST be organized in its own module following this structure:

```text
lib/
├── core/                    # Shared utilities, constants, themes
│   ├── theme/
│   ├── utils/
│   ├── widgets/             # Reusable widgets
│   └── routing/
├── features/
│   └── [feature_name]/
│       ├── presentation/
│       │   ├── cubit/
│       │   ├── pages/
│       │   └── widgets/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── use_cases/
│       └── data/
│           ├── models/
│           ├── repositories/
│           └── data_sources/
```

> **Rationale**: Feature isolation enables parallel development, reduces merge conflicts, and makes the codebase navigable for a graduation project team.

---

### III. Cubit State Management (NON-NEGOTIABLE)

All state management MUST use Cubit (from flutter_bloc package):

- Each feature MUST have dedicated Cubit(s) for its state management
- Cubits MUST emit immutable state objects
- State classes MUST use sealed classes or freezed for type safety
- Cubits MUST NOT contain UI logic (navigation, dialogs, snackbars)
- Cubits MUST be injected via BlocProvider, never instantiated in widgets

> **Rationale**: Cubit provides predictable state management with less boilerplate than Bloc, making it ideal for a graduation project's complexity level while maintaining testability.

---

### IV. Navigation Separation (NON-NEGOTIABLE)

Navigation logic MUST be kept outside UI widgets:

- Use a centralized AppRouter class in `core/routing/`
- Navigation MUST be triggered via Cubit states or dedicated navigation services
- Deep linking and route guards MUST be handled at the router level
- Widgets MUST NOT directly call `Navigator.push/pop` or `context.go`

> **Rationale**: Centralized navigation enables easier testing, consistent transitions, and prevents navigation logic from polluting widget code.

---

### V. Figma Design Compliance (NON-NEGOTIABLE)

UI implementation MUST strictly follow Figma designs:

- Spacing MUST match Figma specifications exactly (pixel-perfect)
- Typography MUST use exact font families, sizes, weights, and line heights from Figma
- Colors MUST match Figma hex values exactly
- Component dimensions MUST match Figma unless responsive adaptation is required
- Any deviation from Figma MUST be documented and approved

> **Rationale**: Design consistency ensures professional quality expected for a graduation project and prevents scope creep from arbitrary UI decisions.

---

### VI. Centralized Theming (NON-NEGOTIABLE)

All visual styling MUST use the centralized AppTheme:

- **AppColors**: All color constants in `core/theme/app_colors.dart`
- **AppTypography**: All text styles in `core/theme/app_typography.dart`
- **AppDimensions**: Spacing, padding, border radius in `core/theme/app_dimensions.dart`
- Hard-coded colors, font sizes, or spacing values in widgets are **FORBIDDEN**
- Theme MUST be accessible via `Theme.of(context)` or extension methods

> **Rationale**: Centralized theming ensures consistency, enables easy global changes, and supports potential dark mode or branding updates.

---

### VII. Widget Purity

Widgets MUST be pure presentation components:

- Widgets MUST NOT contain business logic, calculations, or data transformations
- Widgets MUST NOT make API calls or access repositories directly
- Widgets MUST receive all data via constructor parameters or Cubit state
- Complex widget logic MUST be extracted to separate helper classes or use cases
- `build()` methods MUST be focused on rendering UI only

> **Rationale**: Pure widgets are easier to test, reuse, and maintain. Business logic in widgets creates tight coupling and makes unit testing difficult.

---

### VIII. Responsive Design

All screens MUST be responsive across device sizes:

- Use `MediaQuery`, `LayoutBuilder`, or `ResponsiveBuilder` for adaptive layouts
- Define breakpoints in `core/utils/responsive_utils.dart`
- Test on minimum 3 screen sizes: small phone (360dp), large phone (414dp), tablet (768dp)
- Text MUST scale appropriately without overflow or truncation
- Touch targets MUST remain accessible (minimum 48×48dp) on all sizes

> **Rationale**: A graduation project must demonstrate professional quality across the Android device ecosystem.

---

### IX. Widget Reusability

Common UI patterns MUST be extracted to reusable widgets:

- Reusable widgets MUST live in `core/widgets/` or feature-specific `widgets/` folders
- Reusable widgets MUST be configurable via parameters (not hard-coded values)
- Reusable widgets MUST have clear, descriptive names reflecting their purpose
- Duplicate widget code across features is **FORBIDDEN**—extract and share
- Document widget parameters with dartdoc comments

> **Rationale**: Reusable widgets reduce code duplication, ensure consistency, and speed up development for team members.

---

### X. Testable & Maintainable Code

All code MUST be written for testability and long-term maintenance:

- Dependencies MUST be injected, never instantiated within classes
- Use abstract classes/interfaces for repository contracts
- Avoid global state and singletons (except for service locator setup)
- Keep functions focused (single responsibility) and under 50 lines where possible
- Use meaningful names for classes, methods, and variables
- Add dartdoc comments for public APIs and complex logic

> **Rationale**: A graduation project must demonstrate software engineering best practices, not just working code.

---

### XI. Package-First Development (NON-NEGOTIABLE)

Before starting any implementation, the agent MUST first search for existing Flutter packages on [pub.dev](https://pub.dev) that already provide the required functionality:

- Search pub.dev for well-maintained, actively supported packages that solve the problem
- Evaluate candidate packages by **popularity, pub points, likes, maintenance status, and null-safety support**
- If a suitable package exists, it MUST be used instead of building the functionality from scratch
- Custom implementation is only permitted when **no adequate package exists**, or when existing packages conflict with other constitutional principles (e.g., architecture, theming)
- The decision to use or reject a package MUST be documented with rationale

> **Rationale**: Leveraging the Flutter ecosystem avoids reinventing the wheel, reduces development time, minimizes bugs, and allows the team to focus on business logic unique to Wasla.

---

## Technology Stack

| Category | Tool / Package |
|---|---|
| **Framework** | Flutter (latest stable) |
| **Language** | Dart (null-safe) |
| **State Management** | flutter_bloc (Cubit) |
| **Dependency Injection** | get_it + injectable (recommended) |
| **Routing** | go_router or auto_route |
| **Networking** | dio with retrofit (recommended) |
| **Local Storage** | shared_preferences, hive, or sqflite as needed |
| **Testing** | flutter_test, bloc_test, mockito or mocktail |

---

## Quality Gates

All code contributions MUST pass these gates before merge:

| # | Gate | Description |
|---|---|---|
| 1 | **Architecture Compliance** | Code follows Clean Architecture layer separation |
| 2 | **Folder Structure** | Files are in correct feature module locations |
| 3 | **State Management** | Uses Cubit correctly, no `setState` in stateful widgets for app state |
| 4 | **Theme Usage** | No hard-coded colors, fonts, or spacing |
| 5 | **Design Match** | UI matches Figma designs (screenshot comparison if needed) |
| 6 | **No Logic in Widgets** | Business logic is in use cases or Cubits |
| 7 | **Responsiveness** | Tested on multiple screen sizes |
| 8 | **Code Quality** | No lint warnings, proper naming, documented public APIs |
| 9 | **Package Check** | Verified pub.dev for existing packages before custom implementation |

---

## Governance

This Constitution is the supreme authority for all development decisions on the Wasla project:

- All team members MUST read and acknowledge this Constitution before contributing
- Code reviews MUST verify compliance with all principles
- Violations MUST be fixed before merge—no exceptions for "quick fixes"
- Amendments require team discussion, documentation of rationale, and version increment
- When principles conflict with deadlines, escalate to project supervisor—never silently violate

### Amendment Process

1. Propose change with rationale in team discussion
2. Document impact on existing code
3. Obtain team consensus
4. Update Constitution with new version number
5. Communicate changes to all team members

---

> **Version**: 1.1.0 | **Ratified**: 2026-02-17 | **Last Amended**: 2026-03-06