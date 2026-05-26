---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Deletes the fiscalization data for the user.

DELETE `/v1/hq/fiscalizations/users/{user_id}/onboarding`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

user\_id \* string

Example `"user123"`

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/fiscalizations/users/user123/onboarding"
```

Empty

Empty

Empty

Empty

Empty

Empty[Delete fiscalization onboarding data DELETE](https://docs.noona.is/docs/hq/fiscalization/DeleteCompanyFiscalizationData)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/DeleteCompanyFiscalizationData)[

Fiscalize transaction POST

Next Page

](https://docs.noona.is/docs/hq/fiscalization/FiscalizeTransaction)