# Contracts: Fix Logo RTL Alignment

**Feature**: 006-fix-logo-rtl  
**Date**: 2026-02-19

## Overview

This feature introduces no API contracts, routes, or external interfaces. It is a purely presentational fix scoped to the onboarding page's `_LogoGroup` widget layout behavior.

## Widget Contract (Behavioral)

The `_LogoGroup` widget maintains the following behavioral contract:

| Property | Value | Enforced By |
|----------|-------|-------------|
| Internal content order | Always LTR: "W" circle (left) → "ASLA" text (right) | `Directionality(textDirection: TextDirection.ltr)` |
| Position on screen | Centered horizontally | Parent `Center` widget |
| Scaling behavior | Scales down proportionally on small screens | `FittedBox(fit: BoxFit.scaleDown)` |
| RTL immunity | Internal layout does not respond to ambient RTL direction | `Directionality` override |

This contract will be enforced by widget tests added in this feature.
