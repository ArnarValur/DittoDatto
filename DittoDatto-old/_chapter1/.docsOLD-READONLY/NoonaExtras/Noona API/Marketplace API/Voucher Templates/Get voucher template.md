---
tag: "noona.is"
---
Gets a voucher template.

```
curl -X GET "https://api.noona.is/v1/marketplace/voucher_templates/string"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "type": "amount",

  "title": "Voucher for the men's haircut",

  "description": "Please note that the voucher is only valid between 10:00 and 14:00, Monday to Friday.",

  "marketplace_description": "A short form description displayed on the Noona marketplace.",

  "event_type": "string",

  "variation_id": "7awdXwZoedakjad37a",

  "company": "string",

  "number_of_guests": 2,

  "currency": "ISK",

  "amount": 10000,

  "value": 12500,

  "expiration_months_after_purchase": 12,

  "images": [

    {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "type": "thumbnail",

      "public_id": "https://placekitten.com/200/300"

    }

  ],

  "preview_image": {

    "thumb": "https://placekitten.com/200/200",

    "image": "https://placekitten.com/200/300",

    "type": "thumbnail",

    "public_id": "https://placekitten.com/200/300"

  },

  "primary_color": "#0f0f0f",

  "sessions_total": 5,

  "is_promoted": true,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```[Voucher Templates](https://docs.noona.is/docs/marketplace/voucher-templates)

[

Previous Page

](https://docs.noona.is/docs/marketplace/voucher-templates)[

List all voucher templates GET

Next Page

](https://docs.noona.is/docs/marketplace/voucher-templates/ListAllVoucherTemplates)