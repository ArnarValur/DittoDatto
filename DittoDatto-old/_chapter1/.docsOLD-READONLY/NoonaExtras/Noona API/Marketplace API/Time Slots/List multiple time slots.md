---
tag: "noona.is"
---
Gets all available tima slots for company based on filter for multiple event types.

This endpoint allows for fetching time slots for multiple event types at once. Opposed to **/time\_slots** which only allows for fetching time slots for a single event type.

If **event\_id** is provided, **event\_type\_ids** will be ignored and the event type of the event will be used.

GET `/v1/marketplace/companies/{id}/multiple_time_slots`

## Path Parameters

id \* string

Company ID

Example `"aw7da9wd8ua28a821"`

## Query Parameters

employee\_id?string

Example `"8a1da9wd8ua28aa9d"`

space\_id?string

Example `"ea7da9wd8ua28a134"`

event\_type\_ids?array<string>

event\_id?string

Example `"xa7da9wd8ua01a134"`

start\_date \* string

Example `"2021-01-01"`

end\_date \* string

Example `"2021-01-31"`

capacity?integer

Default `1`

Format `int32`

Example `5`

type?string

Filter by type of time slots to return.

`available` will only return slots with resources available.

`unavailable` will only return slots with resources unavailable.

`all` will return all slots.

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

expand?array<string>

[Expandable attributes](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body

```
curl -X GET "https://api.noona.is/v1/marketplace/companies/aw7da9wd8ua28a821/multiple_time_slots?start_date=2021-01-01&end_date=2021-01-31"
```

```
[

  {

    "event_type": {

      "id": "7awdXwZoedakjad37a",

      "title": "Men's haircut",

      "company_id": "831dXwZoedakjad40b",

      "company": "string",

      "minutes": 30,

      "description": "30 minute men's haircut",

      "min_guests_per_booking": 0,

      "max_guests_per_booking": 0,

      "thumb": "api.noona.is/static/haircut.png",

      "images": [

        {

          "thumb": "https://placekitten.com/200/200",

          "image": "https://placekitten.com/200/300",

          "type": "thumbnail",

          "public_id": "https://placekitten.com/200/300"

        }

      ],

      "variations": [

        {

          "id": "string",

          "label": "Premium",

          "description": "Premium service with extra attention",

          "selectable_in_marketplace": true,

          "customer_group": "7awdXwZoedakjad37a",

          "prices": [

            {

              "currency": "EUR",

              "amount": 40

            }

          ],

          "payments": {

            "pre_payment_enabled": true,

            "pre_payment_type": "payment",

            "pre_payment_required": true,

            "pre_payment_min_pax": 1,

            "flat_fee": 100000,

            "pre_payment_ratio": 20,

            "optional_full_payment": true,

            "pre_payment_amount": 2000,

            "optional_pre_payment_amount": 10000,

            "on_location_payment_amount": 8000,

            "on_location_payment_amount_upper_limit": 8000,

            "pre_payment_currency": "ISK",

            "total_payment": 10000,

            "total_payment_upper_limit": 10000

          }

        }

      ],

      "price_ranges": [

        {

          "min": 10,

          "max": 30,

          "currency": "EUR"

        }

      ],

      "connections": {

        "customer_selects": "employee",

        "service_needs": "employee",

        "booking_question": "string",

        "booking_questions": [

          {

            "id": "string",

            "title": "string",

            "description": "string",

            "answer_required": true,

            "answer_type": "string"

          }

        ],

        "booking_success_message": "Remember to bring your smile with you!",

        "marketplace": true

      },

      "payments": {

        "pre_payment_enabled": true,

        "pre_payment_type": "payment",

        "pre_payment_required": true,

        "pre_payment_min_pax": 1,

        "flat_fee": 100000,

        "pre_payment_ratio": 20,

        "optional_full_payment": true,

        "pre_payment_amount": 2000,

        "optional_pre_payment_amount": 10000,

        "on_location_payment_amount": 8000,

        "on_location_payment_amount_upper_limit": 8000,

        "pre_payment_currency": "ISK",

        "total_payment": 10000,

        "total_payment_upper_limit": 10000

      },

      "pending_payment_details": {

        "outstanding": 2000,

        "on_location": 8000,

        "on_location_upper_limit": 8000,

        "total": 10000,

        "total_upper_limit": 10000

      },

      "pending_payment_details_required": {

        "outstanding": 2000,

        "on_location": 8000,

        "on_location_upper_limit": 8000,

        "total": 10000,

        "total_upper_limit": 10000

      },

      "pending_payment_details_full": {

        "outstanding": 2000,

        "on_location": 8000,

        "on_location_upper_limit": 8000,

        "total": 10000,

        "total_upper_limit": 10000

      },

      "relative_location": {

        "lat": 0.1,

        "lng": 0.1,

        "distance": 0.1

      },

      "created_at": 1631558908,

      "updated_at": 1631558908,

      "deleted_at": "2019-08-24T14:15:22Z"

    },

    "time_slots": [

      {

        "status": "closed",

        "date": "2021-01-03",

        "slots": [

          {

            "time": "08:00",

            "employeeIds": [

              "string"

            ],

            "spaceIds": [

              "string"

            ],

            "timestamp": "2019-08-24T14:15:22Z",

            "unavailable_resources": [

              {

                "resource": "string",

                "reason": "booked"

              }

            ],

            "unavailable_employees": [

              {

                "resource": "string",

                "reason": "booked"

              }

            ]

          }

        ],

        "unavailable_slots": [

          {

            "time": "08:00",

            "employeeIds": [

              "string"

            ],

            "spaceIds": [

              "string"

            ],

            "timestamp": "2019-08-24T14:15:22Z",

            "unavailable_resources": [

              {

                "resource": "string",

                "reason": "booked"

              }

            ],

            "unavailable_employees": [

              {

                "resource": "string",

                "reason": "booked"

              }

            ]

          }

        ]

      }

    ]

  }

]
```[Get time slot reservation GET](https://docs.noona.is/docs/marketplace/time-slots/GetTimeSlotReservation)

[

Previous Page

](https://docs.noona.is/docs/marketplace/time-slots/GetTimeSlotReservation)[

List speedy slots for appointment vertical GET

Next Page

](https://docs.noona.is/docs/marketplace/time-slots/ListSpeedySlots)