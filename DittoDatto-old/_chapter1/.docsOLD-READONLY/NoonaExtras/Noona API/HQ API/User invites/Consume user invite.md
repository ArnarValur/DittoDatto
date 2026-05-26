---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) User invites

Consumes a user invite token after validation. This endpoint requires authentication and will mark the user invite as used.

POST `/v1/hq/user_invites/{token}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

token \* string

User invite token

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/user_invites/string"
```

Empty

Empty

Empty

```
{

  "message": "Customer onboarding error.",

  "code": "user_invite_expired"

}
```

Empty[OAuth POST](https://docs.noona.is/docs/hq/user/UserOAuthPost)

[

Previous Page

](https://docs.noona.is/docs/hq/user/UserOAuthPost)[

Create user invite POST

Next Page

](https://docs.noona.is/docs/hq/user-invites/CreateUserInvite)