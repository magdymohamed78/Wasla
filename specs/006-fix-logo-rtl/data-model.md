# Data Model: Fix Logo RTL Alignment

**Feature**: 006-fix-logo-rtl  
**Date**: 2026-02-19

## Overview

This feature involves no data model changes. It is a purely presentational fix affecting widget layout behavior on the onboarding page.

## Entities

No new entities, fields, relationships, or state changes are introduced.

## Existing Entities (Unchanged)

The following entities are referenced but **not modified** by this feature:

- **LocaleState**: Holds the current `Locale`. Drives the app's text direction (LTR/RTL). Unchanged — the logo fix consumes the ambient direction but does not depend on or modify `LocaleState`.
- **OnboardingState**: Holds navigation state for the onboarding page. Unchanged — no impact from logo alignment fix.
