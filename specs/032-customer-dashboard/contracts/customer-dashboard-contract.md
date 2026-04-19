# Contract: Customer Dashboard and My Reviews Integration

## Purpose
Define UI, routing, and API integration contracts for the customer-only dashboard section on Home and the My Reviews management flow.

## UI Placement and Visibility Contract
- Dashboard renders only for `customer` role.
- Dashboard position on Home:
  - below search entry widget
  - above recommended/trending/all companies sections
- Non-customer behavior:
  - dashboard not rendered
  - Home and other sections continue normal rendering

## Dashboard Card Contract
- Grid: 2 columns, 4 cards total.
- Cards:
  - Total Offers
  - Accepted Offers
  - Pending Offers
  - My Reviews
- Card content:
  - prominent numeric value
  - subtle title
  - icon in rounded tinted container
- Motion:
  - entry: fade + slight upward offset
  - tap: scale-down + ripple feedback

## Navigation Contract
- Total Offers card -> `/my/offers` (default filter)
- Accepted Offers card -> `/my/offers?filter=accepted`
- Pending Offers card -> `/my/offers?filter=pending`
- My Reviews card -> `/my/reviews`
- Offers screen must initialize active filter from route query `filter` when present.

## Access Guard Contract (My Reviews)
- Guest user attempting `/my/reviews` -> redirect to `/login`
- Authenticated non-customer attempting `/my/reviews` -> redirect to `/home`
- My Reviews UI must not render for non-customer roles

## API Contracts

### 1) Offers Metrics Source
- Method: `GET`
- Path: `/api/customer-portal/my/offers`
- Query params:
  - `pageIndex: int`
  - `pageSize: int`
  - `status: string?`
- Usage contract:
  - Reuse existing offers status-count mapping
  - Dashboard reads totals from same logic used by offers tabs

### 2) List My Reviews
- Method: `GET`
- Path: `/api/customer-portal/my/reviews`
- Query params:
  - `pageIndex: int` (default 1)
  - `pageSize: int` (default 10)
- Response normalization contract:
  - Adapter must support paginated-object and array payloads
  - Internal model must expose `items`, `pageIndex`, `pageSize`, `totalCount`, `totalPages`

### 3) Edit Review
- Method: `PUT`
- Path: `/api/customer-portal/companies/{companyId}/reviews`
- Path param:
  - `companyId: int`
- Request body (CreateCompanyReviewDto shape):
  - `rating: int` (required)
  - `reviewText: string?` (optional)
- Validation contract:
  - client enforces `rating` in range `1..5`
  - client trims `reviewText` whitespace before submit

### 4) Delete Review
- Method: `DELETE`
- Path: `/api/customer-portal/companies/{companyId}/reviews`
- Path param:
  - `companyId: int`
- UX contract:
  - confirmation modal with Yes/No
  - perform delete only on affirmative confirmation

## My Reviews View Contract
- List item fields:
  - company logo
  - company name
  - rating stars
  - review text
  - date
  - edit icon
  - delete icon
- Loading:
  - skeleton cards
  - no full-screen blocking loader
- Pagination:
  - incremental load on scroll
  - pull-to-refresh resets to first page
- Error/empty:
  - section/page-level retry action

## Cross-Screen Synchronization Contract
- After successful edit:
  - update list item in-place
  - keep Home `My Reviews` metric unchanged
- After successful delete:
  - remove deleted item from list
  - decrement Home `My Reviews` metric by one in same session

## Feedback Contract
- Success messages use existing `ToastUtils.showSuccess`
- Error messages follow existing localized retry/error patterns
- Retry labels reuse localization key family used elsewhere (for example `networkErrorRetry`)
