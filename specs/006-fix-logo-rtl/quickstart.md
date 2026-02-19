# Quickstart: Fix Logo RTL Alignment

**Feature**: 006-fix-logo-rtl  
**Date**: 2026-02-19

## What This Feature Does

Ensures the Wasla logo group on the onboarding page remains centered with its internal content order ("W" circle → "ASLA" text) always reading left-to-right, regardless of whether the app is in English (LTR) or Arabic (RTL) mode. All other onboarding UI elements continue to mirror correctly in RTL.

## Current State

The existing implementation in `_LogoGroup` already wraps the logo content in `Directionality(textDirection: TextDirection.ltr)`, which prevents the internal `Row` from flipping in RTL. The logo is also wrapped in `Center`, which is direction-agnostic.

**The current code already satisfies all functional requirements.** This feature focuses on:
1. Verifying the existing behavior is correct
2. Adding widget tests to prevent future regressions
3. Documenting the pattern for future branding elements

## Key Files

| File | Role | Action |
|------|------|--------|
| `lib/features/onboarding/presentation/pages/onboarding_page.dart` | `_LogoGroup` widget with `Directionality` wrapper | Verify / minor refinement |
| `test/features/onboarding/presentation/pages/onboarding_page_test.dart` | Widget tests for RTL logo behavior | **Create new** |

## How to Verify

1. Run the app: `flutter run`
2. Navigate to the onboarding page
3. Tap the language selector and switch to Arabic
4. Confirm the logo stays centered with "W" on the left and "ASLA" on the right
5. Confirm header elements (language selector, support icon) swap sides correctly
6. Switch back to English — confirm no flicker or position change on the logo

## Test Commands

```bash
# Run the specific test file
flutter test test/features/onboarding/presentation/pages/onboarding_page_test.dart

# Run all tests
flutter test
```

## Architecture Notes

- **Pattern**: `Directionality(textDirection: TextDirection.ltr)` is the idiomatic Flutter approach for pinning a subtree to LTR layout. It overrides the ambient `TextDirection` for all descendants.
- **Scope**: Only applied to branding elements. All other widgets continue to use `EdgeInsetsDirectional` and ambient direction for proper RTL support.
- **No data layer impact**: No models, repositories, or state management changes.
