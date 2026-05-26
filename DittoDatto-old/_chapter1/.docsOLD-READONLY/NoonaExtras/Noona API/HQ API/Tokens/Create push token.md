---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Tokens](https://docs.noona.is/docs/hq/tokens)

Creates a push token that can be used to send push notifications to the Noona HQ app.

POST `/v1/hq/user/push_tokens`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

token \* string

Example `"7awdXawZoolkjad37a"`

platform \* string

Format `enum`

Example `"ios"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/user/push_tokens" \

  -H "Content-Type: application/json" \

  -d '{

    "token": "7awdXawZoolkjad37a",

    "platform": "ios"

  }'
```

```
{

  "token": "7awdXawZoolkjad37a",

  "platform": "ios",

  "created_at": "2019-08-24T14:15:22Z"

}
```

Empty

Empty

Empty

Empty

Empty[Tokens](https://docs.noona.is/docs/hq/tokens)

[

Previous Page

](https://docs.noona.is/docs/hq/tokens)[

Delete push token DELETE

Next Page

](https://docs.noona.is/docs/hq/tokens/DeleteUserPushToken)