# Research: Fix Logo RTL Alignment

**Feature**: 006-fix-logo-rtl  
**Date**: 2026-02-19

## R1. Is `Directionality` wrapper the idiomatic approach for preventing RTL mirroring?

**Decision**: Yes — `Directionality` is the canonical Flutter approach for overriding text direction in a subtree.

**Rationale**: `Directionality` is an `InheritedWidget` that sets `TextDirection` for its entire subtree. All direction-aware widgets (`Row`, `Flex`, `Align`, `EdgeInsetsDirectional`, `Text`) resolve layout direction via `Directionality.of(context)`. This is the mechanism Flutter itself uses internally in `MaterialApp` to propagate locale-driven direction. The current `_LogoGroup` implementation already applies this correctly.

**Alternatives Considered**:
- `Row(textDirection: TextDirection.ltr)` — valid but narrower scope; only controls child ordering, misses descendant `EdgeInsetsDirectional` or `Text` alignment. Rejected because `Directionality` is more comprehensive and intentional for a full-subtree override.
- Manual `Transform.scale(scaleX: -1)` flipping — a hack that introduces rendering artifacts and doesn't prevent internal text from rendering RTL. Rejected.
- `Stack`-based absolute positioning — over-complicated for a simple horizontal logo arrangement. Rejected.

## R2. Known gotchas with nested `Directionality`

**Decision**: No blocking issues. Three documented awareness points.

**Rationale**:
1. **Descendants inherit the override**: All widgets inside the `Directionality(ltr)` subtree resolve to LTR, including `EdgeInsetsDirectional` and `Text` alignment. This is **desirable** for the logo group which contains only fixed brand content ("W", "ASLA") — no translatable strings.
2. **Accessibility/Semantics**: `Directionality` affects `Semantics` `textDirection`. Screen readers announce the subtree as LTR content. For the brand name "WASLA" this is correct — it reads left-to-right even in Arabic context.
3. **Nesting**: Flutter handles nested `Directionality` cleanly — closest ancestor wins. No known conflicts between the outer RTL `Directionality` (from `MaterialApp` locale) and the inner LTR override on `_LogoGroup`.

## R3. Does `Directionality` affect the parent `Center` widget?

**Decision**: No impact.

**Rationale**: `Center` uses `Alignment.center` which resolves to `(0.0, 0.0)` — a fixed geometric center independent of text direction. The `Directionality` wrapper is *inside* `_LogoGroup`, so it only affects descendants. The logo remains geometrically centered on screen in both LTR and RTL modes.

## R4. Current implementation status

**Decision**: The current codebase already satisfies all spec requirements (FR-001 through FR-006).

**Rationale**: Code analysis of `onboarding_page.dart` reveals:
- `_LogoGroup` is wrapped in `Directionality(textDirection: TextDirection.ltr)` (line 110-111) — prevents internal content from flipping.
- `_LogoGroup` is wrapped in `Center` (line 63) — position is stable regardless of direction.
- `FittedBox(fit: BoxFit.scaleDown)` handles responsive scaling.
- Header uses `EdgeInsetsDirectional` and `Row` with `Spacer` — naturally mirrors in RTL.
- Button section uses `EdgeInsetsDirectional.symmetric` — correctly mirrors padding in RTL.

**What remains**: Widget tests to **lock down** this behavior and prevent future regressions. No code changes are needed aside from refining the implementation comment for intent documentation.

## R5. Testing RTL behavior in Flutter widget tests

**Decision**: Use `Directionality` wrapper in tests with position assertions.

**Rationale**: Best practices for RTL widget testing:
1. Wrap widget under test in `Directionality(textDirection: TextDirection.rtl)` to simulate RTL environment.
2. Assert child ordering using `tester.getTopLeft()` — verify "W" `dx` is always less than "ASLA" `dx`.
3. Verify `Directionality.of(context)` inside logo subtree equals `TextDirection.ltr`.
4. Test both LTR and RTL in parameterized tests to ensure stability.
5. Non-logo widgets should be tested separately to confirm they still respect RTL direction.

## R6. Future-proofing for additional branding elements

**Decision**: The `Directionality` wrapper pattern is sufficient. No reusable utility needed now.

**Rationale**: If additional branding elements need LTR pinning in the future, a simple `BrandLtr` wrapper widget could be extracted to `core/widgets/`. However, with only one logo group currently, this extraction would be premature. The pattern is documented in this research for future reference.

**Alternatives Considered**:
- Creating `BrandLtr` wrapper now — premature abstraction with only one use case. Can be extracted later if needed.
- Adding a `forceDirection` parameter to existing `WaslaLogo` — the `WaslaLogo` core widget and `_LogoGroup` are separate concerns (circle-only vs. full brand name). Not appropriate.
