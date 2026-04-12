# Research: User Roles and Access Control System

## Decision 1: Role resolution uses token presence plus nullable customerId semantics
- Decision: Resolve role as Guest when token is absent, Lead when token exists and customerId is null/missing, Customer when token exists and customerId is any non-null value (including 0).
- Rationale: Clarification decisions finalized this behavior; Swagger customer-portal auth docs describe lead/customer differentiation by claim presence.
- Alternatives considered:
  - Customer only when customerId > 0: rejected because it conflicts with approved clarification.
  - Role based only on leadId presence: rejected because both claims can coexist after conversion.

## Decision 2: Use single-attempt refresh recovery on protected-action 401
- Decision: On protected-action authorization failure, execute one `POST /api/customer-portal/refresh-token` attempt; continue action if successful, otherwise clear session and fallback to Guest.
- Rationale: Swagger refresh endpoint uses rotation and replay protection; repeated retries increase invalid-token-family risk.
- Alternatives considered:
  - Immediate logout on first 401: rejected due poorer UX and unnecessary re-authentication.
  - Unlimited retry loop: rejected due security and race-condition risk.

## Decision 3: Persist Request Service continuation intent as mandatory behavior
- Decision: Always capture `pendingAction=requestService` plus `pendingCompanyId` when auth interrupts Request Service flow and resume after successful login if context remains valid.
- Rationale: Clarified requirement mandates deterministic continuation.
- Alternatives considered:
  - Optional best-effort persistence: rejected because it can lose user intent.
  - No persistence with Home fallback: rejected due conversion-flow friction.

## Decision 4: Use one shared request submission endpoint for Lead and Customer
- Decision: Both roles submit via `POST /api/customer-portal/service-requests` using the same DTO contract and success navigation to Requests.
- Rationale: Swagger explicitly states this endpoint supports both Lead and Customer callers.
- Alternatives considered:
  - Separate endpoint per role: rejected because no separate role endpoint exists in Swagger.
  - Lead-only submit in this phase: rejected by clarification decision.

## Decision 5: Requests history source is customer-scoped endpoint
- Decision: Requests history surface uses `GET /api/customer-portal/my/service-requests` and request details use `GET /api/customer-portal/my/service-requests/{id}`.
- Rationale: Swagger defines these as customer-facing history endpoints.
- Alternatives considered:
  - Using `GET /api/customer-portal/service-requests`: rejected because Swagger defines submit at this path, not customer history listing.

## Decision 6: Profile access splits by role using Swagger endpoints
- Decision: Lead profile uses `GET/PUT /api/customer-portal/my/lead-profile`; Customer profile uses `GET/PUT /api/customer-portal/my/profile`.
- Rationale: Swagger descriptions explicitly direct lead vs customer profile usage.
- Alternatives considered:
  - Single profile endpoint for all roles: rejected due explicit backend role scoping.

## Decision 7: Settings destinations are app routes, not backend endpoints
- Decision: Keep role-specific settings destinations as app routes (`/my/lead-settings`, `/my/settings`) while profile/settings data remains backed by existing profile/customer-portal endpoints until dedicated settings APIs exist.
- Rationale: Clarification defined route behavior; Swagger currently has no customer-portal settings endpoint matching these routes.
- Alternatives considered:
  - Treat routes as backend endpoints: rejected because they are absent in Swagger.

## Decision 8: Company discovery continues to use public customer-portal browse APIs
- Decision: Use existing browse endpoints for all roles:
  - `GET /api/customer-portal/companies`
  - `GET /api/customer-portal/recommended-companies`
  - `GET /api/customer-portal/trending-companies`
  - `GET /api/customer-portal/companies/{companyId}`
  - `GET /api/customer-portal/companies/{companyId}/reviews`
- Rationale: Spec requires browse continuity independent of role while guarding restricted actions.
- Alternatives considered:
  - Role-specific duplicate browse APIs: rejected as unnecessary and unsupported by current backend contract.

## Decision 9: Guarded destinations rely on explicit role-aware navigation model
- Decision: Build navigation from resolved role each render cycle (Guest: Companies+Sign In, Lead: Companies+Profile+Settings, Customer: Companies+Requests+Offers+Profile+Settings) and apply guard checks for direct-route access.
- Rationale: Clarified dynamic navigation requirement and deterministic restriction behavior.
- Alternatives considered:
  - Fixed nav with hidden/disabled tabs: rejected because spec requires role-dependent composition.
