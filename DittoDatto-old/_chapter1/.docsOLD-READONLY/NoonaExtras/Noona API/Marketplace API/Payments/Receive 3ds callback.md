---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Payments](https://docs.noona.is/docs/marketplace/payments)

Receives a 3ds callback from Teya.

POST `/v1/marketplace/payments/callbacks/3ds`

## Query Parameters

## Request Body

application/json

pares?string

The `pares` parameter from the 3D Secure flow.

cres?string

The `cres` parameter from the 3D Secure flow.

threeDSSessionData?string

The `MD` data from the 3D Secure flow is in the attribute.

## Response Body

```
curl -X POST "https://api.noona.is/v1/marketplace/payments/callbacks/3ds" \

  -H "Content-Type: application/json" \

  -d '{}'
```

Empty

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
```[Resolves a payment POST](https://docs.noona.is/docs/marketplace/payments/PaymentResolvePost)

[

Previous Page

](https://docs.noona.is/docs/marketplace/payments/PaymentResolvePost)[

Request an Apple Pay Payment Session POST

Next Page

](https://docs.noona.is/docs/marketplace/payments/RequestApplePaySession)