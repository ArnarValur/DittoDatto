---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Claims

Lists all claims for a company

GET `/v1/hq/companies/{company_id}/claims`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/claims"
```

```
[

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

]
```

Empty

Empty

Empty[Create claim POST](https://docs.noona.is/docs/hq/claims/CreateClaim)

[

Previous Page

](https://docs.noona.is/docs/hq/claims/CreateClaim)[

Clone a company POST

Next Page

](https://docs.noona.is/docs/hq/companies/CloneCompany)