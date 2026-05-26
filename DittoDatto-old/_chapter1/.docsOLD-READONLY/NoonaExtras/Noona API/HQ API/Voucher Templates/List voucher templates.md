---
tag: "noona.is"
---
Lists the voucher templates for a company.

GET `/v1/hq/companies/{company_id}/voucher_templates`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/voucher_templates"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "type": "amount",

    "title": "Voucher for the men's haircut",

    "title_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "description": "Please note that the voucher is only valid between 10:00 and 14:00, Monday to Friday.",

    "description_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "marketplace_description": "A short form description displayed on the Noona marketplace.",

    "marketplace_description_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "event_type": "string",

    "variation_id": "7awdXwZoedakjad37a",

    "company": "7awdXwZoedakjad37a",

    "number_of_guests": 2,

    "currency": "ISK",

    "amount": 10000,

    "value": 12500,

    "sessions_total": 5,

    "marketplace": true,

    "expiration_months_after_purchase": 12,

    "images": [

      {

        "thumb": "https://placekitten.com/200/200",

        "image": "https://placekitten.com/200/300",

        "public_id": "https://placekitten.com/200/300",

        "type": "thumbnail",

        "provider": "cloudinary",

        "width": 200,

        "height": 300,

        "bytes": 95849

      }

    ],

    "primary_color": "#0f0f0f",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty[Get voucher template GET](https://docs.noona.is/docs/hq/voucher-templates/GetVoucherTemplate)

[

Previous Page

](https://docs.noona.is/docs/hq/voucher-templates/GetVoucherTemplate)[

Get voucher template preview GET

Next Page

](https://docs.noona.is/docs/hq/voucher-templates/PreviewVoucherTemplate)