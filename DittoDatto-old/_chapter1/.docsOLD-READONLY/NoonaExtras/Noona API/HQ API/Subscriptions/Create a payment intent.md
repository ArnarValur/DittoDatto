---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Create a payment intent to be used for the 3DSecure payment flow

POST `/v1/hq/companies/{company_id}/subscriptions/payment_intent`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/companies/dwawd8awudawd/subscriptions/payment_intent"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "customer_id": "7awdXwZoedakjad37a",

  "status": "inited",

  "currency_code": "EUR",

  "amount": 0,

  "gateway": "braintree",

  "gateway_account_id": "gw_7awdXwZoedakjad37a",

  "expires_at": 1257894000,

  "created_at": 1257894000,

  "modified_at": 1257894000,

  "resource_version": 0,

  "updated_at": 1257894000

}
```

Empty

Empty[Cancel subscription POST](https://docs.noona.is/docs/hq/subscriptions/CancelSubscription)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/CancelSubscription)[

Create a subscription for company POST

Next Page

](https://docs.noona.is/docs/hq/subscriptions/CreateSubscription)