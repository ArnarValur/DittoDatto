---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [OAuth](https://docs.noona.is/docs/hq/oauth)

Approves the OAuth consent for the user against a specific application.

POST `/v1/hq/oauth/auth`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Request Body

application/json

company\_id \* string

Example `"7awdXwZoedakjad37a"`

client\_id \* string

Example `"7awdXwZoedakjad37a"`

redirect\_uri \* string

Example `"https://example.com"`

state?string

Example `"1234567890"`

response\_type \* string

Format `enum`

Value in `"code"`

scopes \* OAuthScopes

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/oauth/auth" \

  -H "Content-Type: application/json" \

  -d '{

    "company_id": "7awdXwZoedakjad37a",

    "client_id": "7awdXwZoedakjad37a",

    "redirect_uri": "https://example.com",

    "response_type": "code",

    "scopes": [

      "activities:read"

    ]

  }'
```

```
{

  "redirect_uri": "https://example.com/?code=x&state=y"

}
```[OAuth](https://docs.noona.is/docs/hq/oauth)

[

Previous Page

](https://docs.noona.is/docs/hq/oauth)[

Get OAuth public key GET

Next Page

](https://docs.noona.is/docs/hq/oauth/GetOAuthPublicKey)