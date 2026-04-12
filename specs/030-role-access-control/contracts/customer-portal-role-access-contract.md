# Contract: Customer Portal Role Access and Request Flow

## Purpose
Define client-to-server integration and route-level contracts for role resolution, guarded navigation, and service-request flow using Swagger as source of truth.

## Role Resolution Contract

### Source endpoints
- `POST /api/customer-portal/login`
- `POST /api/customer-portal/refresh-token`

### Source schema
- `AuthResultDto` fields used by client session model:
  - `token`
  - `refreshToken`
  - `refreshTokenExpiry`
  - `leadId`
  - `customerId`
  - identity/profile fields

### Resolution rules
- No token => Guest
- Token + `customerId == null` or missing => Lead
- Token + `customerId != null` (including 0) => Customer

## Authentication and Session Endpoints

### 1) Login
- Endpoint: `POST /api/customer-portal/login`
- Request: `CustomerLoginDto`
- Response: `CustomerLoginResultDto`/`AuthResultDto`-compatible auth payload
- Client action: persist session and resolve role immediately.

### 2) Refresh token
- Endpoint: `POST /api/customer-portal/refresh-token`
- Request: `RefreshTokenRequestDto`
- Behavior: token rotation with one-time-use refresh semantics.
- Client policy: exactly one refresh attempt per failing protected action.

### 3) Logout
- Endpoint: `POST /api/customer-portal/logout`
- Request: `LogoutRequestDto`
- Client action: clear local session and pending protected action state.

## Discovery and Company Browse Endpoints

### 1) Companies list
- Endpoint: `GET /api/customer-portal/companies`
- Query parameters:
  - `pageIndex`
  - `pageSize`
  - `search`
  - `city`
  - `serviceType`
  - `sortBy` (optional)

### 2) Recommended companies
- Endpoint: `GET /api/customer-portal/recommended-companies`
- Query parameters:
  - `ServiceType`
  - `PageIndex`
  - `PageSize`

### 3) Trending companies
- Endpoint: `GET /api/customer-portal/trending-companies`
- Query parameters:
  - `ServiceType`
  - `PageIndex`
  - `PageSize`

### 4) Company details
- Endpoint: `GET /api/customer-portal/companies/{companyId}`

### 5) Company reviews
- Endpoint: `GET /api/customer-portal/companies/{companyId}/reviews`
- Query parameters: `pageIndex`, `pageSize`

## Service Request Contract

### Submit request (Lead and Customer)
- Endpoint: `POST /api/customer-portal/service-requests`
- Request schema: `CreateServiceRequestDto`
- Required client rule: submission context includes selected `companyId`.
- Success behavior: route to Requests surface.

### Customer request history
- Endpoint: `GET /api/customer-portal/my/service-requests`
- Details endpoint: `GET /api/customer-portal/my/service-requests/{id}`

## Offers and Profile Contract

### Customer-only surfaces
- `GET /api/customer-portal/my/offers`
- `GET /api/customer-portal/my/offers/{offerId}`
- `GET/PUT /api/customer-portal/my/profile`

### Lead profile surface
- `GET/PUT /api/customer-portal/my/lead-profile`

## Error and Recovery Contract

### Protected-action 401 handling
1. Attempt one refresh via `POST /api/customer-portal/refresh-token`.
2. If refresh succeeds, continue original action.
3. If refresh fails:
   - clear authenticated state
   - switch to Guest role
   - prompt login
   - preserve pending Request Service intent for continuation.

## UI Route Contract (App-level)

### Role-specific destinations
- Lead profile route: `/my/lead-profile`
- Customer profile route: `/my/profile`
- Lead settings route: `/my/lead-settings`
- Customer settings route: `/my/settings`

### Companies dropdown destinations
- All Companies
- Recommended
- Trending

### Search entry contract
- Listing screens expose top search bar.
- Tap action routes to Explore page, where company and city search is executed.
