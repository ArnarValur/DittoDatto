---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Transactions](https://docs.noona.is/docs/hq/transactions)

Update a transaction

POST `/v1/hq/transactions/{transaction_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

transaction\_id \* string

Transaction ID

## Query Parameters

## Request Body

application/json

company?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

sale?| string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

subtransactions?

employees?

line\_items?

refunds?array<string>

References refunds for this transaction.

refund\_origin?string

References the original transaction that was refunded.

Example `"8wa9uiah28dawd123"`

note?string

issuer?

fiscalization?string

currency?string

Example `"ISK"`

origin?string

The origin of the transaction.

- marketplace: The transaction was created via the marketplace.
- pos: The transaction was created via the POS.

Example `"marketplace"`

type?string

Example `"invoice"`

status?string

Example `"draft"`

completed\_at?string

Format `date-time`

voided\_at?string

Only supported to unset this field. That is done by providing the value as "zero date" (0001-01-01T00:00:00Z)

Format `date-time`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/transactions/string" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "8wa9uiah28dawd123",

  "company": "string",

  "sale": {

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

  },

  "subtransactions": [

    "string"

  ],

  "employees": [

    "string"

  ],

  "line_items": [

    {

      "id": "string"

    }

  ],

  "refunds": [

    "8wa9uiah28dawd123"

  ],

  "refund_origin": "8wa9uiah28dawd123",

  "invoice_number": 9001,

  "note": "string",

  "issuer": {

    "id": "8wa9uiah28dawd123",

    "type": "company",

    "name": "Noona cuts",

    "bin": "string",

    "legal_address": "My Street 1, 101 Reykjavik",

    "extra_invoice_info": "Some extra info to include on invoices.",

    "vat_id": "string",

    "other": "string"

  },

  "fiscalization": "string",

  "fiscalization_warning": "string",

  "currency": "ISK",

  "total_amount": 1990,

  "total_amount_without_vat": 1990,

  "vat_amount": 478,

  "due_amount": 990,

  "paid_on_marketplace_amount": 1000,

  "origin": "marketplace",

  "tax_exemption_reason": "M01",

  "type": "invoice",

  "status": "draft",

  "drafted_at": "2019-08-24T14:15:22Z",

  "completed_at": "2019-08-24T14:15:22Z",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z",

  "voided_at": "2019-08-24T14:15:22Z",

  "invopop_header": {

    "uuid": "0199dd45-e893-7208-ac79-8f4fe5449e04",

    "code": "FR IXTEST-01/8849",

    "digest": {

      "algorithm": "sha256",

      "value": "ead24e3c59a8b23f4953145566c8371e1c5b8d86280612654531b421d263e89d"

    },

    "stamps": [

      {

        "provider": "at-atcud",

        "value": "AAJFJRJYD4-8849"

      }

    ]

  }

}
```

Empty

Empty

Empty[Sends receipt for transaction POST](https://docs.noona.is/docs/hq/transactions/SendTransactionReceipt)

[

Previous Page

](https://docs.noona.is/docs/hq/transactions/SendTransactionReceipt)[

User

Next Page

](https://docs.noona.is/docs/hq/user)