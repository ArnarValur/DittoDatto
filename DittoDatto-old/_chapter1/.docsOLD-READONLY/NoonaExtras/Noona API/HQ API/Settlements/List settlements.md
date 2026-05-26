---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Settlements](https://docs.noona.is/docs/hq/settlements)

Lists the settlements for a company.

GET `/v1/hq/companies/{company_id}/settlements`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/settlements"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "transferred_to_enterprise": true,

    "transferred_to_enterprise_at": "2019-08-24T14:15:22Z",

    "line_items": [

      {

        "title": "voucher",

        "quantity": 8,

        "total": 40000,

        "fee": 2000,

        "net_total": 38000

      }

    ],

    "total": 40000,

    "fee": 2000,

    "net_total": 38000,

    "currency": "ISK",

    "settled_to": "John The Cutter",

    "settlement_account": {

      "id": "7awdXwZoedakjad37a",

      "name": "Main account",

      "description": "I want all the money here!",

      "ssn": "0503205160",

      "bank": "0542",

      "book": "02",

      "account": "220865",

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z"

    },

    "payments_from": "2019-08-24T14:15:22Z",

    "payments_to": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty