---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Verification

Updates the status of a verification request.

POST `/v1/hq/verifications/{userId}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

userId \* string

The ID of the user whose verification to update

## Query Parameters

## Request Body

application/json

status \* string

The new verification status for updates

rejected\_reason?string

Reason for rejection (required when status is 'rejected')

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/verifications/string" \

  -H "Content-Type: application/json" \

  -d '{

    "status": "approved"

  }'
```

```
{

  "status": "pending",

  "file": "string",

  "certification_type": "cosmetology",

  "certification_level": "apprentice",

  "submitted_at": "2019-08-24T14:15:22Z",

  "approved_at": "2019-08-24T14:15:22Z",

  "rejected_at": "2019-08-24T14:15:22Z",

  "rejected_reason": "string"

}
```

Empty

Empty

Empty

Empty

Empty[List verification requests GET](https://docs.noona.is/docs/hq/verification/ListVerificationRequests)

[

Previous Page

](https://docs.noona.is/docs/hq/verification/ListVerificationRequests)[

Verifone

Next Page

](https://docs.noona.is/docs/hq/verifone)