---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Retrieves billing invoices for company

GET `/v1/hq/companies/{company_id}/subscriptions/invoices`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company id

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/subscriptions/invoices"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "amount": 0,

    "currency": "string",

    "date": "2019-08-24T14:15:22Z",

    "status": "paid",

    "payment_url": "string"

  }

]
```

Empty

Empty[Retrieve subscription pricing for company GET](https://docs.noona.is/docs/hq/subscriptions/GetSubscriptionPricing)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/GetSubscriptionPricing)[

List plans for item family GET

Next Page

](https://docs.noona.is/docs/hq/subscriptions/ListBillingPlans)