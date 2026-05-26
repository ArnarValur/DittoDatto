---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Issuers

Lists all available invoice issuers for a company.

This includes the company and all employees that issue their own invoices.

Disabled employees are not included.

GET `/v1/hq/companies/{company_id}/issuers`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/issuers"
```

```
[

  {

    "id": "8wa9uiah28dawd123",

    "type": "company",

    "name": "Noona cuts",

    "bin": "string",

    "legal_address": "My Street 1, 101 Reykjavik",

    "extra_invoice_info": "Some extra info to include on invoices.",

    "vat_id": "string",

    "other": "string"

  }

]
```

Empty

Empty

Empty[List Holidays GET](https://docs.noona.is/docs/hq/holidays/ListHolidays)

[

Previous Page

](https://docs.noona.is/docs/hq/holidays/ListHolidays)[

Create a line item POST

Next Page

](https://docs.noona.is/docs/hq/line-items/CreateLineItem)