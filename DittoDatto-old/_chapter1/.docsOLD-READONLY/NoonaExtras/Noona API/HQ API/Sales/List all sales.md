---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Sales](https://docs.noona.is/docs/hq/sales)

Lists all sales for a company

Customer is [point in time property](https://docs.noona.is/docs/hq/sales/#section/Point-in-time-properties) and is always expanded.

GET `/v1/hq/companies/{company_id}/sales`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/sales"
```

```
[

  {

    "id": "8wa9uiah28dawd123",

    "transactions": [

      {

        "id": "string"

      }

    ],

    "events": [

      {

        "id": "string"

      }

    ],

    "company": "string",

    "customer": {

      "id": "string"

    },

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty

Empty

Empty[Retrieve a sale GET](https://docs.noona.is/docs/hq/sales/GetSale)

[

Previous Page

](https://docs.noona.is/docs/hq/sales/GetSale)[

Refund a marketplace sale POST

Next Page

](https://docs.noona.is/docs/hq/sales/RefundMarketplaceSale)