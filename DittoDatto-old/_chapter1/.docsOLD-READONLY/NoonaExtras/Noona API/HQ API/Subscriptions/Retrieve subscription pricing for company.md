---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Retrieve subscription pricing for company

GET `/v1/hq/companies/{company_id}/subscriptions/pricing`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/subscriptions/pricing"
```

```
[

  {

    "powerup": "appointments_pro",

    "price": 0,

    "currency": "string",

    "addons": [

      {

        "addon": "sms_reminders",

        "price": 0,

        "currency": "string"

      }

    ]

  }

]
```

Empty

Empty[Retrieve billing info for company GET](https://docs.noona.is/docs/hq/subscriptions/GetSubscriptionBillingInfo)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/GetSubscriptionBillingInfo)[

Retrieve billing invoices for company GET

Next Page

](https://docs.noona.is/docs/hq/subscriptions/ListBillingInvoices)