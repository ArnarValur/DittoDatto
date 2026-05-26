---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Updates the fiscalization status for the user to the specified value.

POST `/v1/hq/fiscalizations/users/{user_id}/status`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

user\_id \* string

User ID

## Request Body

application/json

fiscalization\_enabled \* boolean

The desired fiscalization enabled status

Example `true`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/fiscalizations/users/string/status" \

  -H "Content-Type: application/json" \

  -d '{

    "fiscalization_enabled": true

  }'
```

```
{

  "fiscalization_enabled": true

}
```

Empty

Empty

Empty

Empty

Empty[Update fiscalization status POST](https://docs.noona.is/docs/hq/fiscalization/UpdateCompanyFiscalizationStatus)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/UpdateCompanyFiscalizationStatus)[

Upsert fiscalization onboarding data POST

Next Page

](https://docs.noona.is/docs/hq/fiscalization/UpsertCompanyFiscalizationData)