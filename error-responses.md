# Error Response Contracts: Customer Portal

**Branch**: `001-portal-error-messages`  
**Date**: 2026-02-20

## Error Response Format

All customer portal endpoints return errors in this format:

```json
{
  "message": "Human-readable error description"
}
```

## Status Code Contracts by Endpoint

### POST `/api/customer-portal/register`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 201 | Success | `CustomerLoginResultDto` |
| 400 | Invalid input / password policy failure | `{ "message": "Password must contain..." }` |
| 409 | Email already in use | `{ "message": "Email already in use." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### POST `/api/customer-portal/login`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerLoginResultDto` |
| 400 | Not linked to lead/customer | `{ "message": "User is not linked to a lead or customer record." }` |
| 401 | Invalid credentials / inactive | `{ "message": "Invalid credentials or inactive account." }` |
| 429 | Too many login attempts (rate limited) | `{ "message": "Too many login attempts. Please try again later." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/companies`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `PaginatedResult<PublicCompanyListDto>` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/companies/{companyId}`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `PublicCompanyDetailsDto` |
| 404 | Company not found / inactive | `{ "message": "Company not found or inactive." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/companies/{companyId}/reviews`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `PaginatedResult<CompanyReviewDto>` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### POST `/api/customer-portal/companies/{companyId}/reviews`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 201 | Success | `CompanyReviewDto` |
| 404 | Company not found | `{ "message": "Company not found or inactive." }` |
| 409 | Already reviewed | `{ "message": "You have already reviewed this company. Use update to change your review." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### PUT `/api/customer-portal/companies/{companyId}/reviews`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CompanyReviewDto` |
| 404 | Review not found | `{ "message": "Review not found." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### DELETE `/api/customer-portal/companies/{companyId}/reviews`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 204 | Success | No content |
| 404 | Review not found | `{ "message": "Review not found." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/reviews`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `PaginatedResult<CompanyReviewDto>` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/profile`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerProfileDto` |
| 404 | Customer not found | `{ "message": "Customer not found." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### PUT `/api/customer-portal/my/profile`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerProfileDto` |
| 404 | Customer not found | `{ "message": "Customer not found." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/offers`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerOfferPagedResultDto` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/offers/{offerId}`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerOfferDetailsDto` |
| 404 | Offer not found / access denied | `{ "message": "Offer not found or access denied." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/dashboard`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerDashboardDto` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### POST `/api/customer-portal/service-requests`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 201 | Success | `CustomerServiceRequestDetailsDto` |
| 404 | Related resource not found | `{ "message": "..." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/service-requests`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerServiceRequestPagedResultDto` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/service-requests/{id}`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `CustomerServiceRequestDetailsDto` |
| 404 | Request not found | `{ "message": "..." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### GET `/api/customer-portal/my/lead-profile`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `LeadProfileDto` |
| 404 | Lead not found | `{ "message": "Lead not found." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### PUT `/api/customer-portal/my/lead-profile`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 200 | Success | `LeadProfileDto` |
| 404 | Lead not found | `{ "message": "Lead not found." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |

### POST `/api/customer-portal/companies/connect`

| Status | Condition | Response Body |
|--------|-----------|--------------|
| 201 | Success | `LeadCompanyDto` |
| 404 | Lead/Company not found | `{ "message": "Lead not found." / "Company not found or inactive." }` |
| 409 | Already connected | `{ "message": "You have already sent a connection request to this company." }` |
| 500 | Unexpected error | `{ "message": "An unexpected error occurred. Please try again later." }` |
