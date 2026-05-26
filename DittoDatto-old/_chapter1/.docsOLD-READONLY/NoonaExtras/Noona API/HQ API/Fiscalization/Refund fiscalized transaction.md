---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Creates a credit invoice for a fiscalized transaction in the Noona system, along with a fiscalization record for the credit invoice in the tax authority's system.

If the transaction is not fiscalized, an error will be returned.

POST `/v1/hq/fiscalizations/transactions/{transaction_id}/refund`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

transaction\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/fiscalizations/transactions/dwawd8awudawd/refund"
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
```[Migrate Portugal company from InvoiceXpress to AT provider POST](https://docs.noona.is/docs/hq/fiscalization/MigratePortugalCompanyToATProvider)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/MigratePortugalCompanyToATProvider)[

Update fiscalization status POST

Next Page

](https://docs.noona.is/docs/hq/fiscalization/UpdateCompanyFiscalizationStatus)