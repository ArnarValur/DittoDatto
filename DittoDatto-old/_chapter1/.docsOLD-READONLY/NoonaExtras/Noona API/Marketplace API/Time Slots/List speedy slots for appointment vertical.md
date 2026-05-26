---
tag: "noona.is"
---
Lists speedy slots, availble for booking, for a specific event type at a company.

The returned companies are solely within the appointment vertical.

```
curl -X GET "https://api.noona.is/v1/marketplace/speedy_slots?start_date=2022-11-01&end_date=2022-11-03&lat=0.1&lng=0.1&radius=10000"
```

```
[

  {

    "company": {

      "id": "7dj29KiAE1wdjw731",

      "vertical": "appointment",

      "enterprise_id": "3dj29KiAE1wdjw135",

      "enterprise": "string",

      "profile": {

        "store_name": "John's Hair Salon",

        "description": "string",

        "favorites": 0,

        "company_type_ids": [

          "8aj29KiAE1wdjw143"

        ],

        "company_types": [

          "string"

        ],

        "cuisines": [

          {

            "id": "7awdXwZoedakjad37a",

            "name": "Bistro",

            "readable_id": "bistro",

            "image": "https://placekitten.com/200/200",

            "public_id": "https://placekitten.com/200/300",

            "vertical": "appointment",

            "type": "service_type",

            "available": true

          }

        ],

        "dietaries": [

          {

            "id": "7awdXwZoedakjad37a",

            "name": "Bistro",

            "readable_id": "bistro",

            "image": "https://placekitten.com/200/200",

            "public_id": "https://placekitten.com/200/300",

            "vertical": "appointment",

            "type": "service_type",

            "available": true

          }

        ],

        "ambiences": [

          {

            "id": "7awdXwZoedakjad37a",

            "name": "Bistro",

            "readable_id": "bistro",

            "image": "https://placekitten.com/200/200",

            "public_id": "https://placekitten.com/200/300",

            "vertical": "appointment",

            "type": "service_type",

            "available": true

          }

        ],

        "settings": {

          "license_plate": true

        },

        "image": {

          "thumb": "https://placekitten.com/200/200",

          "image": "https://placekitten.com/200/300",

          "type": "thumbnail",

          "public_id": "https://placekitten.com/200/300"

        },

        "cover_images": [

          {

            "thumb": "https://placekitten.com/200/200",

            "image": "https://placekitten.com/200/300",

            "type": "thumbnail",

            "public_id": "https://placekitten.com/200/300"

          }

        ],

        "phone_country_code": 354,

        "phone_number": "string",

        "prefer_12_hours": true,

        "price_category": 3,

        "min_guests_per_booking": 0,

        "max_guests_per_booking": 0,

        "exceed_max_guests_message": "string"

      },

      "connections": {

        "multiple_services": true,

        "url_name": "string",

        "contact_email": "string",

        "required_fields": {

          "kennitala": true,

          "email": true,

          "license_plate": true

        },

        "opening_hours": [

          {

            "opens_at": "08:00",

            "closes_at": "18:00",

            "is_closed": true

          }

        ],

        "max_future": 0,

        "client_cancel_disabled": true,

        "client_reschedule_disabled": true,

        "min_cancel_notice": 0,

        "min_move_notice": 0,

        "location": {

          "google_place_id": "string",

          "formatted_address": "string",

          "lat_lng": {

            "lat": 0.1,

            "lng": 0.1

          },

          "country": {

            "short_name": "IS",

            "long_name": "Iceland"

          },

          "time_zone": "Atlantic/Reykjavik"

        },

        "booking_redirect_url": "string",

        "web_auth_opt_out": true,

        "booking_success_message": "string",

        "timatorg": true,

        "enable_vouchers": true,

        "enable_amount_vouchers": true,

        "waitlist_enabled": true,

        "show_booking_ends_at": true,

        "tracking": true

      },

      "no_show_enabled": true,

      "most_recently_visited_company": true,

      "locale": {

        "ui_language": "is",

        "messaging_language": "is",

        "default_currency": {

          "code": "EUR",

          "name": "Euro",

          "symbol": "€"

        }

      },

      "relative_location": {

        "lat": 0.1,

        "lng": 0.1,

        "distance": 0.1

      },

      "payment_provider": "teya"

    },

    "event_types": [

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

  }

]
```[List multiple time slots GET](https://docs.noona.is/docs/marketplace/time-slots/ListMultipleTimeSlots)

[

Previous Page

](https://docs.noona.is/docs/marketplace/time-slots/ListMultipleTimeSlots)[

List speedy tables for restaurant vertical GET

Next Page

](https://docs.noona.is/docs/marketplace/time-slots/ListSpeedyTables)