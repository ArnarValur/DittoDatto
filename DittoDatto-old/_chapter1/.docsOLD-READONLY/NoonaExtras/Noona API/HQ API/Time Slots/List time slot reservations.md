---
tag: "noona.is"
---
Lists time slot reservation at company.

Time slot reservations are created when a customer is going through the booking process and selects a time slot on the marketplace.

GET `/v1/hq/companies/{company_id}/time_slot_reservations`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/time_slot_reservations"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "event_types": [

      "string"

    ],

    "starts_at": "2019-08-24T14:15:22Z",

    "ends_at": "2019-08-24T14:15:22Z",

    "date": "2022-09-12",

    "duration": 30,

    "employee": "string",

    "space": "string",

    "resources": [

      {

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

      }

    ],

    "expires_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```[List pax status GET](https://docs.noona.is/docs/hq/time-slots/ListPaxStatuses)

[

Previous Page

](https://docs.noona.is/docs/hq/time-slots/ListPaxStatuses)[

List time slots GET

Next Page

](https://docs.noona.is/docs/hq/time-slots/ListTimeSlots)