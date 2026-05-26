---
tag: "noona.is"
---
Retrieves all event types for a company.

```
curl -X GET "https://api.noona.is/v1/marketplace/companies/string/event_types"
```

```
[

  {

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

  }

]
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Get event type GET](https://docs.noona.is/docs/marketplace/event-types/GetEventType)

[

Previous Page

](https://docs.noona.is/docs/marketplace/event-types/GetEventType)[

List event types and groups GET

Next Page

](https://docs.noona.is/docs/marketplace/event-types/ListEventTypesExpanded)