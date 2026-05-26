---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [OAuth](https://docs.noona.is/docs/hq/oauth)

Returns the Noona OAuth public key.

The public can be used to verify the signatures of identity tokens issued by Noona.

```
curl -X GET "https://api.noona.is/v1/hq/oauth/publickey"
```

```
{

  "kty": "RSA",

  "use": "sig",

  "kid": "1",

  "n": "string",

  "e": "string",

  "alg": "RS256"

}
```[Create OAuth consent POST](https://docs.noona.is/docs/hq/oauth/CreateOAuthConsent)

[

Previous Page

](https://docs.noona.is/docs/hq/oauth/CreateOAuthConsent)[

Get OAuth token POST

Next Page

](https://docs.noona.is/docs/hq/oauth/GetOAuthToken)