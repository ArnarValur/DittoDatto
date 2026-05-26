---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Lists all plans for a given Chargebee item family. This endpoint is public and does not require authentication.

GET `/v1/hq/{item_family_id}/plans`

## Path Parameters

item\_family\_id \* string

The Chargebee item family ID

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/string/plans"
```

```
[

  {

    "id": "string",

    "name": "string",

    "external_name": "string",

    "description": "string",

    "price_variants": [

      {

        "id": "string",

        "price_variant_id": "string",

        "name": "string",

        "external_name": "string",

        "pricing_model": "flat_fee",

        "price": 0,

        "currency_code": "string",

        "period": 0,

        "period_unit": "string",

        "tiers": [

          {

            "starting_unit": 0,

            "ending_unit": 0,

            "price": 0

          }

        ]

      }

    ],

    "entitlements": [

      {

        "feature_id": "calendars",

        "feature_name": "string",

        "feature_type": "switch",

        "plan_id": "string",

        "bool_value": true,

        "int_value": 0,

        "string_value": "string",

        "is_enabled": true,

        "is_overridden": true

      }

    ]

  }

]
```

Empty

Empty[Retrieve billing invoices for company GET](https://docs.noona.is/docs/hq/subscriptions/ListBillingInvoices)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/ListBillingInvoices)[

Start trial POST

Next Page

](https://docs.noona.is/docs/hq/subscriptions/StartTrial)