---
tag: "noona.is"
---
Updates a voucher template at enterprise.

POST `/v1/hq/voucher_templates/{voucher_template_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

voucher\_template\_id \* string

Voucher Template ID

## Query Parameters

unset?array<VoucherTemplateField>

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

## Request Body

application/json

type?string

Example `"amount"`

title?string

title\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

description?string

description\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

marketplace\_description?string

marketplace\_description\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

event\_type?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

variation\_id?string

The ID of the event type variation that the value of the voucher should be calculated from.

Example `"7awdXwZoedakjad37a"`

company?string

Example `"7awdXwZoedakjad37a"`

number\_of\_guests?integer

The number of people this voucher is valid for.

Default `1`

Format `int32`

Example `2`

currency?string

Example `"ISK"`

amount?number

Format `double`

Example `10000`

value?number

Format `double`

Example `12500`

sessions\_total?integer

Format `int32`

Example `5`

marketplace?boolean

If true, voucher is visible on the marketplace.

Example `true`

expiration\_months\_after\_purchase?integer

Default `48`

Format `int32`

Example `12`

images?

primary\_color?string

Example `"#0f0f0f"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/voucher_templates/string" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
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
```

Empty[Get voucher template preview GET](https://docs.noona.is/docs/hq/voucher-templates/PreviewVoucherTemplate)

[

Previous Page

](https://docs.noona.is/docs/hq/voucher-templates/PreviewVoucherTemplate)[

Vouchers

Next Page

](https://docs.noona.is/docs/hq/vouchers)