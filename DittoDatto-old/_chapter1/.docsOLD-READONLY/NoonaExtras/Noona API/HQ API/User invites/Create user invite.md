---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) User invites

Creates a new user invite for the company. Only company owners can create user invites. The link expires after 7 days and is single-use.

POST `/v1/hq/user_invites`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company\_id?string

ID of the company this user invite will belong to

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/user_invites" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
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
```

Empty

Empty

Empty[Consume user invite POST](https://docs.noona.is/docs/hq/user-invites/ConsumeUserInvite)

[

Previous Page

](https://docs.noona.is/docs/hq/user-invites/ConsumeUserInvite)[

Delete user invite DELETE

Next Page

](https://docs.noona.is/docs/hq/user-invites/DeleteUserInvite)