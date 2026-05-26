---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Payments](https://docs.noona.is/docs/marketplace/payments)

Requests an Apple Pay Payment Session.

The session is required for Apple Pay on web.

```
curl -X POST "https://api.noona.is/v1/marketplace/companies/string/apple_pay_session"
```

```
{

  "data": "dGhlIGFwcGxlIHBheSBzZXNzaW9uIHBheWxvYWQ="

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Receive 3ds callback POST](https://docs.noona.is/docs/marketplace/payments/Receive3dsCallback)

[

Previous Page

](https://docs.noona.is/docs/marketplace/payments/Receive3dsCallback)[

Recommendations

Next Page

](https://docs.noona.is/docs/marketplace/recommendations)