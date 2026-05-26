---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Tokens](https://docs.noona.is/docs/hq/tokens)

Deletes a push token.

DELETE `/v1/hq/user/push_tokens/{push_token}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

push\_token \* string

Push Token

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/user/push_tokens/string"
```

Empty

Empty

Empty

Empty

Empty

Empty[Create push token POST](https://docs.noona.is/docs/hq/tokens/CreateUserPushToken)

[

Previous Page

](https://docs.noona.is/docs/hq/tokens/CreateUserPushToken)[

Transactions

Next Page

](https://docs.noona.is/docs/hq/transactions)