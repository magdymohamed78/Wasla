# API Contracts: Customer Offers Flow

**Feature**: 033-add-offers-flow | **Date**: 2026-04-23
**Base URL**: `/api/customer-portal/my/offers`

## 1. Get Offer Details

```
GET /api/customer-portal/my/offers/{offerId}
Authorization: Bearer <JWT with customerId>
```

### Path Parameters
| Name | Type | Required |
|---|---|---|
| offerId | int32 | ✓ |

### Response 200 — `CustomerOfferDetailsDto`
```json
{
  "offerId": 42,
  "offerNumber": "OFF-2026-001",
  "companyId": 7,
  "companyName": "CleanPro Services",
  "status": "Pending",
  "serviceTypeOverall": "Cleaning",
  "totalAmount": 1500.00,
  "discountAmount": 100.00,
  "issueDate": "2026-04-20T10:00:00Z",
  "acceptDate": null,
  "digitalSignature": null,
  "rejectionReason": null,
  "insurance": "Basic coverage included",
  "includedInPrice": "Materials and transport",
  "costsIncludeVAT": true,
  "pdfUrl": "https://api.example.com/files/offer-42.pdf",
  "locations": [
    {
      "locationType": "Origin",
      "addressIndex": 0,
      "street": "123 Main St",
      "zipCode": "12345",
      "city": "Cairo",
      "countryCode": "EG",
      "buildingType": "Apartment",
      "floor": "3",
      "hasLift": true
    }
  ],
  "serviceLineItems": [
    {
      "serviceType": "Cleaning",
      "totalLinePrice": 1500.00,
      "serviceDetails": {
        "cleaningType": "Deep Clean",
        "durationHours": 4,
        "numberOfStaff": 2,
        "cleaningDate": "2026-05-01"
      },
      "additionalCosts": [
        { "description": "Special equipment", "price": 50.00 }
      ]
    }
  ]
}
```

### Error Responses
| Status | Description |
|---|---|
| 404 | Offer not found or access denied |
| 401 | Not authenticated |

---

## 2. Accept Offer

```
POST /api/customer-portal/my/offers/{offerId}/accept
Authorization: Bearer <JWT with customerId>
Content-Type: application/json
```

### Path Parameters
| Name | Type | Required |
|---|---|---|
| offerId | int32 | ✓ |

### Request Body — `AcceptOfferDto`
```json
{
  "digitalSignature": "SIG-abc123",
  "paymentMethod": 0
}
```

| Field | Type | Required | Constraints |
|---|---|---|---|
| digitalSignature | string | ✓ | min 1, max 64 chars |
| paymentMethod | int (enum) | ✓ | 0 = COD, 1 = Online |

### Response 200
- **COD**: Empty body or success message. Offer status → Accepted.
- **Online**: JSON body with `checkoutUrl` string for Stripe payment.

### Error Responses
| Status | Description |
|---|---|
| 400 | Terminal state or validation error |
| 403 | Forbidden |
| 404 | Offer not found / not owned |
| 422 | Company payment config missing (Online only) |
| 500 | Unexpected error |

---

## 3. Reject Offer

```
POST /api/customer-portal/my/offers/{offerId}/reject
Authorization: Bearer <JWT with customerId>
Content-Type: application/json
```

### Path Parameters
| Name | Type | Required |
|---|---|---|
| offerId | int32 | ✓ |

### Request Body — `RejectOfferDto`
```json
{
  "rejectionReason": "Price too high for the services offered."
}
```

| Field | Type | Required | Constraints |
|---|---|---|---|
| rejectionReason | string | ✓ | min 1, max 2000 chars |

### Response 200
Empty body. Offer status → Rejected.

### Error Responses
| Status | Description |
|---|---|
| 400 | Terminal state (already accepted/rejected/cancelled) |
| 403 | Forbidden |
| 404 | Offer not found / not owned |
| 500 | Unexpected error |
