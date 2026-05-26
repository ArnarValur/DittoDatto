---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Vouchers](https://docs.noona.is/docs/hq/vouchers)

Updates a voucher with ID at enterprise.

POST `/v1/hq/vouchers/{voucher_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

voucher\_id \* string

Voucher ID

## Query Parameters

unset?array<VoucherField>

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

## Request Body

application/json

currency?string

Example `"ISK"`

amount?number

Format `double`

Example `3990`

data?|

color?string

Example `"#0f0f0f"`

message?string

name?string

Example `"Jon Snow"`

phone\_country\_code?string

Example `"354"`

phone\_number?string

If a phone number is provided, it receives news of the newly created voucher.

Example `"7134124"`

email?string

If an email is provided, it receives news of the newly created voucher.

Example `"test@testy.is"`

marketplace\_user?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

customer?| string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

company?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

template?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/vouchers/string" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "currency": "ISK",

  "amount": 3990,

  "data": {

    "type": "service",

    "sessions_used": 0,

    "sessions_total": 0,

    "event_type_name": "Quicky Haircut",

    "event_type_id": "d0a9w8da09w8dindwa",

    "number_of_guests": 2,

    "voucher_template": "7awdXwZoedakjad37a",

    "voucher_template_amount": 0.1,

    "voucher_template_value": 0.1

  },

  "code": "A328DB",

  "color": "#0f0f0f",

  "message": "You deserve to relax a bit!",

  "status": "never_used",

  "name": "Jon Snow",

  "phone_country_code": "354",

  "phone_number": "7134124",

  "email": "test@testy.is",

  "marketplace_user": "string",

  "customer": {

    "id": "7dj29KiAE1wdjw731",

    "name": "Joe the cuttee",

    "kennitala": "1613772649",

    "phone_number": 8578844,

    "phone_country_code": 354,

    "email": "example@example.com",

    "license_plate": "DF302",

    "license_plates": [

      "DF302"

    ],

    "company_id": "2fj29KiKX1wdjw985",

    "company": "2fj29KiKX1wdjw985",

    "event_count": 69,

    "groups": [

      "string"

    ],

    "employee_ids": [

      "1gj29KiKX1wdjw155"

    ],

    "previous_event": {

      "id": "string"

    },

    "next_event": {

      "id": "string"

    },

    "duplicates": {

      "id": "string"

    },

    "duplicateStatus": "possible",

    "notes": "Loves to be called Joe the cuttee",

    "update_origin": "hq",

    "updated_by": "2fj29KiKX1wdjw985",

    "last_employee": "John the hairy",

    "last_event": "date-time",

    "custom_properties": [

      {

        "id": "7awdXwZoedakjad37a",

        "values": [

          "string"

        ],

        "valueIsId": true

      }

    ],

    "attachments": [

      {

        "id": "7awdXwZoedakjad37a",

        "filename": "my_image.jpg",

        "type": "image/jpeg",

        "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

        "relative_url": "/7awdXwZoedakjad37a.jpg",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z"

      }

    ],

    "notices": [

      {

        "id": "8wa9uiah28dawd123",

        "message": "Important information!",

        "variant": "info",

        "dismissable": false,

        "expires_at": "2019-08-24T14:15:22Z",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z"

      }

    ],

    "tags": {

      "gluten_free": true,

      "lactose_intolerant": true,

      "severe_nut_allergy": true,

      "severe_shellfish_allergy": true,

      "vegan": true,

      "vegetarian": true,

      "vip": true,

      "wheelchair": true

    },

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z",

    "marketplace_user": "string",

    "parent_marketplace_user": "string"

  },

  "company": "string",

  "template": "string",

  "expiration": "2022-08-24T14:15:22Z",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z",

  "deleted_at": "2019-08-24T14:15:22Z"

}
```

Empty[List vouchers GET](https://docs.noona.is/docs/hq/vouchers/ListVouchers)

[

Previous Page

](https://docs.noona.is/docs/hq/vouchers/ListVouchers)[

Create a waitlist entry POST

Next Page

](https://docs.noona.is/docs/hq/waitlists/CreateWaitlistEntry)