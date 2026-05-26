---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [OAuth](https://docs.noona.is/docs/hq/oauth)

Returns an OAuth token. This is the final step of the flow. Needs a valid authorization code that was generated from the consent screen. Also needs the client\_id and client\_secret of the application.

**Client Authentication:**The preferred method is HTTP Basic Authentication:

```
Authorization: Basic base64(client_id:client_secret)
```

For backwards compatibility, client\_id and client\_secret can also be passed as query parameters, but this is deprecated and will be removed in a future version.

POST `/v1/hq/oauth/token`

## Query Parameters

client\_id?string Deprecated

Deprecated: Use HTTP Basic Authentication instead. Client ID of the application.

Example `""`

client\_secret?string Deprecated

Deprecated: Use HTTP Basic Authentication instead. Client secret of the application.

Example `""`

## Request Body

client\_id?string

client\_secret?string

grant\_type \* string

Format `enum`

code?string

Example `"7awdXwZoedakjad37a"`

refresh\_token?string

Example `"7awdXwZoedakjad37a"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/oauth/token" \

  -H "Content-Type: application/json" \

  -d '{

    "grant_type": "authorization_code"

  }'
```

```
{

  "token_type": "Bearer",

  "expires_at": "2020-08-24T14:15:22Z",

  "access_token": "7awdXwZoedakjad37a7awdXwZoedakjad37a7awdXwZoedakjad37a",

  "refresh_token": "7awdXwZoedakjad37a7awdXwZoedakjad37a"

}
```[Get OAuth public key GET](https://docs.noona.is/docs/hq/oauth/GetOAuthPublicKey)

[

Previous Page

](https://docs.noona.is/docs/hq/oauth/GetOAuthPublicKey)[

List OAuth scopes GET

Next Page

](https://docs.noona.is/docs/hq/oauth/ListOAuthScopes)