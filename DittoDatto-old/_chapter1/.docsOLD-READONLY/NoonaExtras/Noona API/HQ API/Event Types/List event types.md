---
tag: "noona.is"
---
Retrieves all event types for a company.

GET `/v1/hq/companies/{company_id}/event_types`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/event_types"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "reference_id": "external-service-id",

    "company": "string",

    "event_type_category": "string",

    "event_type_category_group": "string",

    "title": "Men's haircut",

    "title_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "description": "30 minute men's haircut",

    "description_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "minutes": 30,

    "duration": 30,

    "delay": 30,

    "beforePause": 30,

    "pause": 30,

    "afterPause": 30,

    "buffer_after_service": 10,

    "min_guests_per_booking": 0,

    "max_guests_per_booking": 0,

    "thumb": "https://cdn.noona.is/static/haircut-thumb.png",

    "image": "https://cdn.noona.is/static/haircut-org.png",

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

    "color": "#66d8cd",

    "overbookable": "partially_overbookable",

    "vat": "string",

    "variations": [

      {

        "id": "string",

        "label": "Premium",

        "label_translations": {

          "is": "King Accounting tenging",

          "fr": "Connexion King Accounting"

        },

        "description": "Premium service with extra attention",

        "description_translations": {

          "is": "King Accounting tenging",

          "fr": "Connexion King Accounting"

        },

        "selectable_in_marketplace": true,

        "prices": [

          {

            "currency": "EUR",

            "amount": 40

          }

        ],

        "customer_group": "string"

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

      "service_needs": "employee",

      "customer_selects": "employee",

      "booking_question": "What color do you want to dye your hair?",

      "booking_question_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "booking_questions": [

        {

          "id": "string",

          "title": "string",

          "title_translations": {

            "is": "King Accounting tenging",

            "fr": "Connexion King Accounting"

          },

          "description": "string",

          "description_translations": {

            "is": "King Accounting tenging",

            "fr": "Connexion King Accounting"

          },

          "answer_required": true,

          "answer_type": "string"

        }

      ],

      "booking_success_message": "Remember to bring your smile with you!",

      "booking_success_message_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "hidden": true

    },

    "custom_payment_settings": true,

    "payments": {

      "pre_payment_enabled": true,

      "pre_payment_type": "payment",

      "pre_payment_required": true,

      "pre_payment_min_pax": 1,

      "flat_fee": 100000,

      "pre_payment_ratio": 20,

      "optional_full_payment": true,

      "settlement_account": "string",

      "onboarded_at": "2019-08-24T14:15:22Z",

      "enabled_card_types": [

        "visa"

      ]

    },

    "price": {

      "currency": "ISK",

      "amount": 10000,

      "amount_upper_limit": 10000

    },

    "tax_exemption_reason": "string",

    "created_at": "2019-01-01T00:00:00.000Z",

    "updated_at": "2019-01-02T00:00:00.000Z"

  }

]
```

Empty[Get event type GET](https://docs.noona.is/docs/hq/event-types/GetEventType)

[

Previous Page

](https://docs.noona.is/docs/hq/event-types/GetEventType)[

Stream event types GET

Next Page

](https://docs.noona.is/docs/hq/event-types/StreamEventTypes)