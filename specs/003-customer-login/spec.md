# Feature Specification: Customer Login

**Feature ID**: 009-customer-login  
**Date**: 2026-02-19  
**Priority**: P1 — Core feature

## Overview

Implement the Customer Login page with full API integration, enabling users to authenticate via email and password against the backend API endpoint `POST /api/customer-portal/login`.

## User Stories

### US1: Customer logs in with valid credentials (P1)
As a customer, I want to enter my email and password and tap "Sign In" so that I can access my account.

### US2: Customer sees validation feedback (P1)
As a customer, I want to see clear error messages when my login credentials are invalid or when required fields are empty, so I know what to fix.

## Functional Requirements

- FR-001: Email input field with keyboard type email
- FR-002: Password input field with visibility toggle
- FR-003: Remember me checkbox
- FR-004: Forgot password navigation placeholder
- FR-005: Sign In button calls POST /api/customer-portal/login
- FR-006: Success response stores token and navigates forward
- FR-007: Error response (401) shows "Invalid email or password"
- FR-008: Sign Up link navigates to register screen
- FR-009: Loading state disables button and shows indicator
- FR-010: Responsive across 360dp, 414dp, 768dp

## API Contract

**Endpoint**: POST /api/customer-portal/login

**Request**:
```json
{ "email": "string", "password": "string" }
```

**Success (200)**:
```json
{
  "token": "string",
  "userId": 0,
  "customerId": 0,
  "firstName": "string",
  "lastName": "string",
  "email": "string"
}
```

**Error (401)**: Invalid email or password

## Success Criteria

- SC-001: User can log in with valid credentials and receive token
- SC-002: Invalid credentials show appropriate error message
- SC-003: Empty fields show validation errors
- SC-004: UI matches Figma design across all screen sizes
