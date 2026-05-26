---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [User](https://docs.noona.is/docs/hq/user)

Starts an OAuth flow for a user.

POST `/v1/hq/user/oauth`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

provider \* string

redirect\_uri?string

The URI to redirect to after the OAuth flow is complete.

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/user/oauth?provider=google"
```

```
{

  "redirect_url": "string"

}
```

Empty[Update current user POST](https://docs.noona.is/docs/hq/user/UpdateCurrentUser)

[

Previous Page

](https://docs.noona.is/docs/hq/user/UpdateCurrentUser)[

Consume user invite POST

Next Page

](https://docs.noona.is/docs/hq/user-invites/ConsumeUserInvite)