---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Claims

Creates a new claim for a company

POST `/v1/hq/claims`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

payor\_id \* string

Unique identifier of the payor (typically the customer responsible for the claim).

company\_id \* string

Unique identifier of the company associated with this claim.

event\_id \* string

Unique identifier of the event for which the claim is being made.

vat\_id \* string

Unique identifier of the VAT percentage to be used for the claim.

amount?number

Total monetary value of the claim.

Format `double`

notify\_customer?boolean

Whether to notify the customer via sms about the claim.

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/claims" \

  -H "Content-Type: application/json" \

  -d '{

    "payor_id": "string",

    "payor_ssn": "string",

    "company_id": "string",

    "event_id": "string",

    "vat_id": "string"

  }'
```

```
{

  "id": "string",

  "reference_id": "string",

  "bill_number": "string",

  "due_date": "string",

  "claimant_id": "string",

  "employee_name": "string",

  "customer_name": "string",

  "customer_kennitala": "string",

  "amount": 0,

  "currency": "string",

  "status": "Paid",

  "external_url": "string",

  "created_at": "2019-08-24T14:15:22Z",

  "paid_at": "2019-08-24T14:15:22Z"

}
```

Empty

Empty

Empty

Empty

Empty[List all claims GET](https://docs.noona.is/docs/hq/claims/ListClaims)

[

Next Page

](https://docs.noona.is/docs/hq/claims/ListClaims)