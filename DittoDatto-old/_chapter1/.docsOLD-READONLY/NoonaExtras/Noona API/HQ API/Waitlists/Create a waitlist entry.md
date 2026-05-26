---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Waitlists

Creates a waitlist entry for a company.

POST `/v1/hq/waitlist_entries`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company \* string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

customer \* | string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

employee?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

resource?| string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

event\_types \*

number\_of\_guests?integer

Number of guests for the event.

Format `int32`

Example `1`

notes?string

preferred\_times?

booking\_offers?

expires\_at?string Deprecated

Format `date-time`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/waitlist_entries" \

  -H "Content-Type: application/json" \

  -d '{

    "company": "string",

    "customer": {},

    "event_types": [

      "string"

    ]

  }'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

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

  "employee": "string",

  "resource": {

    "id": "7dj29KiAE1wdjw731",

    "company": "string",

    "resource_group": {

      "id": "string"

    },

    "type": "space",

    "name": "Table 1",

    "name_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "description": "A good window view",

    "description_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "priority": "normal",

    "image": {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "public_id": "https://placekitten.com/200/300",

      "type": "thumbnail",

      "provider": "cloudinary",

      "width": 200,

      "height": 300,

      "bytes": 95849

    },

    "reference_id": "1234567890",

    "marketplace": true,

    "available_for_bookings": true,

    "booking_interval": 15,

    "order": 1,

    "min_capacity": 1,

    "max_capacity": 2,

    "allow_overlapping_bookings": false,

    "sub_resources": [

      "string"

    ],

    "event_type_preferences": [

      {

        "event_type": "string",

        "skip": false,

        "skip_calendar": false,

        "skip_marketplace": false,

        "has_custom_duration": false,

        "custom_duration": {

          "duration": 60,

          "before_pause": 25,

          "pause": 10,

          "after_pause": 25

        }

      }

    ],

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  },

  "event_types": [

    "string"

  ],

  "number_of_guests": 1,

  "notes": "string",

  "preferred_times": [

    {

      "date": "2024-10-08",

      "times": [

        "11:00"

      ]

    }

  ],

  "booking_offers": [

    {

      "id": "7awdXwZoedakjad37a",

      "company": "string",

      "message": "We have an opening for your requested service!",

      "starts_at": "2019-08-24T14:15:22Z",

      "declined_at": "2019-08-24T14:15:22Z",

      "expires_at": "2019-08-24T14:15:22Z",

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z",

      "deleted_at": "2019-08-24T14:15:22Z",

      "event": {

        "id": "string"

      }

    }

  ],

  "expires_at": "2019-08-24T14:15:22Z",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```[Update voucher POST](https://docs.noona.is/docs/hq/vouchers/UpdateVoucher)

[

Previous Page

](https://docs.noona.is/docs/hq/vouchers/UpdateVoucher)[

Delete a waitlist entry DELETE

Next Page

](https://docs.noona.is/docs/hq/waitlists/DeleteWaitlistEntry)