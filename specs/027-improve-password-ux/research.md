# Research: Enhance Password Field UX

## Decision 1: Use `flutter_password_strength_meter` for score visualization
- Decision: Adopt `flutter_password_strength_meter` as the strength calculation/visualization base for the sign-up password field.
- Rationale: Satisfies constitution package-first principle, already provides real-time strength feedback, and reduces custom algorithm risk while enabling smooth UI transitions.
- Alternatives considered:
  - `flutter_password_strength`: mature and popular, but the feature requirement explicitly asked for `flutter_password_strength_meter`.
  - Custom strength algorithm and custom painter: rejected due to longer implementation time and higher maintenance cost.

## Decision 2: Keep password rule checks as explicit reusable helper functions
- Decision: Add dedicated helpers `hasMinLength`, `hasNumber`, `hasSpecialChar`, and `hasUppercase` in shared validation utilities.
- Rationale: Requirement mandates independent reusable logic and explicitly forbids overloading `validatePasswordLength`; helpers support reuse in login/reset/change-password flows.
- Alternatives considered:
  - Reusing only `validatePasswordLength` error-key mapping: rejected because it is ordered single-error validation and not suitable for per-rule checklist states.
  - Embedding regex checks directly in widget: rejected by constitution (no logic-heavy widgets, maintainability risk).

## Decision 3: Reuse existing `RegisterCubit` state flow for live feedback
- Decision: Consume `state.password` from `RegisterCubit` and rely on existing `passwordChanged` and `passwordBlurred` signals.
- Rationale: Meets no-new-cubit constraint and preserves established auth form behavior.
- Alternatives considered:
  - New dedicated Cubit for password feedback: rejected as unnecessary complexity and state duplication.
  - Local widget-only `setState` source of truth: rejected because it diverges from form submission validation state.

## Decision 4: Canonical special-character definition is strict set `!@#$%^&*`
- Decision: Checklist and strength-adjacent rule evaluation treat special characters as only `!@#$%^&*`.
- Rationale: Clarified and approved in clarification session; ensures deterministic validation behavior.
- Alternatives considered:
  - Any non-alphanumeric character: rejected because it conflicts with clarified acceptance expectation.
  - Backend-driven dynamic policy fetch: rejected as out of scope (no backend/API changes).

## Decision 5: Canonical interaction-state rendering
- Decision: For unmet rules, show grey while typing and red on blur; met rules are green. Empty password shows checklist neutral and hides strength meter. Weak helper text appears immediately for non-empty weak passwords.
- Rationale: Aligns UX clarifications and avoids ambiguity in acceptance tests.
- Alternatives considered:
  - Always red for unmet rules: rejected as too aggressive during typing.
  - Hide checklist on empty: rejected by explicit clarification decision.
