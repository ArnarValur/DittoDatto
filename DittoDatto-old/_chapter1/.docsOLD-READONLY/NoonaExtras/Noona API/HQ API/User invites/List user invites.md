---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) User invites

Lists all user invites for a company. Only company owners can access this endpoint.

GET `/v1/hq/companies/{company_id}/user_invites`

BearerTokenAuth

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/user_invites"
```

```
[

  {

    "id": "string",

    "company_id": "string",

    "employee_id": "string",

    "user_id": "string",

    "token": "string",

    "expires_at": "2019-08-24T14:15:22Z",

    "consumed_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z",

    "is_expired": true,

    "is_used": true,

    "is_valid": true

  }

]
```

Empty

Empty[Get user invite context GET](https://docs.noona.is/docs/hq/user-invites/GetUserInviteContext)

[

Previous Page

](https://docs.noona.is/docs/hq/user-invites/GetUserInviteContext)[

Terminals

Next Page

](https://docs.noona.is/docs/hq/user-terminals)