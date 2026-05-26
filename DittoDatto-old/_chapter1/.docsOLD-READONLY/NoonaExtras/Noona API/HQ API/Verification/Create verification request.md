---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Verification

Creates a new verification request for the current user.

POST `/v1/hq/user/verification`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

file \* string

URL to the verification document

certification\_type \* string

The type of certification

certification\_level?string

The certification level

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/user/verification" \

  -H "Content-Type: application/json" \

  -d '{

    "file": "string",

    "certification_type": "cosmetology"

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

Empty[List all user terminals GET](https://docs.noona.is/docs/hq/user-terminals/ListUserTerminals)

[

Previous Page

](https://docs.noona.is/docs/hq/user-terminals/ListUserTerminals)[

Get verification request file GET

Next Page

](https://docs.noona.is/docs/hq/verification/GetVerificationRequestFile)