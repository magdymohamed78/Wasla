# Quickstart: User Roles and Access Control System

## 1) Prepare and validate environment
1. Ensure dependencies are installed with `flutter pub get`.
2. Confirm current branch is `feature/030-role-access-control`.
3. Regenerate localization if needed: `flutter gen-l10n`.

## 2) Wire session source of truth
1. Implement/extend global SessionCubit to load and persist SessionUser from secure storage.
2. Add role resolver logic:
   - no token => Guest
   - token + null/missing customerId => Lead
   - token + non-null customerId (including 0) => Customer
3. Expose login/logout/session-refresh events and immutable session states.

## 3) Implement refresh recovery behavior
1. Intercept protected-action 401 responses.
2. Trigger exactly one `POST /api/customer-portal/refresh-token` attempt.
3. If refresh succeeds, continue original action.
4. If refresh fails, clear session, fallback to Guest, and show login prompt.

## 4) Implement mandatory pending intent
1. On auth interruption during Request Service continuation, persist:
   - `pendingAction=requestService`
   - `pendingCompanyId`
2. After successful login, resume New Service Request when pending context is valid.
3. If pending context is invalid, route to Home safely.

## 5) Implement role-specific dynamic navigation
1. Guest nav: Companies (dropdown), Sign In.
2. Lead nav: Companies (dropdown), Profile, Settings.
3. Customer nav: Companies (dropdown), Requests, Offers, Profile, Settings.
4. Companies dropdown options: All Companies, Recommended, Trending.

## 6) Implement guarded destinations and UX
1. Request Service from Company Details:
   - Guest: restriction modal -> onboarding on Continue
   - Lead/Customer: open New Service Request with companyId
2. Restricted direct-route access for Guest/Lead shows EmptyStateWidget guidance.
3. Use shared RestrictionModal and EmptyStateWidget across all guarded paths.

## 7) Implement New Service Request placeholder flow
1. Keep screen lightweight for this phase while accepting required companyId.
2. Submit for both Lead and Customer to:
   - `POST /api/customer-portal/service-requests`
3. On success navigate to Requests view.
4. For Lead, preserve re-login prompt conversion flow behavior in spec.

## 8) Align API integration with Swagger
1. Auth/session:
   - `POST /api/customer-portal/login`
   - `POST /api/customer-portal/refresh-token`
   - `POST /api/customer-portal/logout`
2. Discovery:
   - `GET /api/customer-portal/companies`
   - `GET /api/customer-portal/recommended-companies`
   - `GET /api/customer-portal/trending-companies`
   - `GET /api/customer-portal/companies/{companyId}`
3. Customer content:
   - `GET /api/customer-portal/my/service-requests`
   - `GET /api/customer-portal/my/offers`
   - `GET/PUT /api/customer-portal/my/profile`
4. Lead profile:
   - `GET/PUT /api/customer-portal/my/lead-profile`

## 9) Verify routes and role-specific destinations
1. Lead profile route resolves to `/my/lead-profile`.
2. Customer profile route resolves to `/my/profile`.
3. Lead settings route resolves to `/my/lead-settings`.
4. Customer settings route resolves to `/my/settings`.

## 10) Execute validation checklist
1. Run static analysis: `flutter analyze`.
2. Run tests: `flutter test`.
3. Manual smoke flow:
   - Guest -> Sign In -> Lead
   - Lead Request Service submit -> re-login -> Customer
   - Customer accesses Requests/Offers/Profile/Settings
4. Confirm SC-001 through SC-012 scenarios from spec are reproducible.

## 11) Validation Record (2026-04-14)
1. Automated validation completed:
   - `flutter analyze` passed with no issues.
   - `flutter test` passed with all tests.
2. End-to-end role and continuation checks reviewed against implementation:
   - Guest shell navigation resolves to Companies dropdown + Sign In.
   - Lead shell navigation resolves to Companies dropdown + Profile + Settings and settings routes to `/my/lead-settings`.
   - Customer shell navigation resolves to Companies dropdown + Requests + Offers + Profile + Settings and settings routes to `/my/settings`.
   - Home section cards show limited previews and route View All actions to dedicated listing pages.
   - Listing-page search entry always routes to Explore.
   - Pending Request Service continuation is resumed after login when stored context is valid.
3. Device smoke checklist to run before release:
   - Guest -> Sign In -> Lead transition.
   - Lead request submit -> re-login -> Customer transition.
   - Customer access to Requests, Offers, Profile, and Settings.
