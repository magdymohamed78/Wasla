# Contract: Customer Service Requests UI and API Integration

## Purpose
Define API usage and UI behavior contracts for the customer Service Requests Page, including filters, preview limits, details navigation, and full-page pagination.

## Backend Endpoints

### 1) List Requests
- Method: `GET`
- Path: `/api/customer-portal/my/service-requests`
- Query params:
  - `pageIndex: int` (default 1)
  - `pageSize: int` (default backend 10)
  - `status: string?` (optional)
- Response schema: `CustomerServiceRequestPagedResultDto`
  - `items[]`: `CustomerServiceRequestSummaryDto`
  - `pageIndex`, `pageSize`, `totalCount`, `totalPages`
  - `statusCounts: Map<String,int>?`

### 2) Request Details
- Method: `GET`
- Path: `/api/customer-portal/my/service-requests/{id}`
- Path param:
  - `id: int`
- Response schema: `CustomerServiceRequestDetailsDto`

## Status Normalization Contract
- Pending tab includes: `Pending`, `New`, `Submitted`
- In Progress tab includes: `InProgress`, `OfferSent`, `Assigned`, `Scheduled`
- Closed tab includes: `Completed`, `Rejected`, `Cancelled`, `Accepted`
- Expired tab includes: `Expired`
- Unknown values:
  - included in All only
  - rendered with neutral badge

## Main Requests Page Contract
- AppBar title: `Requests`
- Header title: `Service Requests`
- Header description: `Track and manage your service requests`
- Filter tabs (horizontal): `All`, `Pending`, `In Progress`, `Closed`, `Expired`
- Count badges sourced from normalized `statusCounts`.
- Preview list:
  - max 5 cards
  - card fields: logo, company name, reference number, status badge, service type, preferred date, submission date, `View Request` action
- Loading:
  - card-shaped skeleton placeholders during initial load and filter switch
- Empty state:
  - primary CTA: `Browse Companies`
  - secondary CTA: `Retry`
- Recoverable error state:
  - primary CTA: `Browse Companies`
  - secondary CTA: `Retry`

## Full Filtered Page Contract
- Entry action text: `LOADING MORE REQUESTS...`
- Navigation carries active filter context.
- Data loading:
  - server pagination with `pageIndex/pageSize/status`
  - append next pages until end
  - no duplicate request ids after append
- Loading indicators:
  - initial skeleton state
  - incremental loading skeleton at list bottom

## Details Page Contract
- Input: `serviceRequestId`
- Fetch details from `/api/customer-portal/my/service-requests/{id}`
- Compact display only:
  - reference number
  - company identity
  - status
  - service type
  - preferred date
  - submission date
- Out of scope for this iteration:
  - full address/time-slot/offer deep details sections

## Routing Contract (App-level)
- Main requests route remains customer requests destination.
- Full-list route is filter-scoped via route argument/query (dedicated route context per selected filter).
- Details route accepts required `serviceRequestId` parameter.

## Error Handling Contract
- 403 on list/details: show access-denied style state and recoverable actions where applicable.
- 404 on details: show not-found state and safe back navigation.
- 500/network errors: show retry-capable error state with secondary Retry action.
