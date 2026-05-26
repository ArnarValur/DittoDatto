---
tag: "noona.is"
---
Retrieves information about an existing scheduled event.

GET `/v1/hq/scheduled_events/{scheduled_event_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

scheduled\_event\_id \* string

Scheduled Event ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/scheduled_events/string"
```

```
{

  "id": "se_abc123",

  "company": "string",

  "name": "Imagine Dragons Concert",

  "name_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "description": "Live concert at O2 Arena",

  "description_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "starts_at": "2024-03-15T20:00:00Z",

  "ends_at": "2024-03-15T23:00:00Z",

  "marketplace_visible": true,

  "allow_cancellation": true,

  "min_cancel_notice_minutes": 1440,

  "customer_selects_tier": true,

  "location": {

    "google_place_id": "string",

    "address": {

      "city": "string",

      "postalCode": "string",

      "street": "string",

      "region": "string",

      "locality": "string",

      "country": "string"

    },

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

  "tiers": [

    {

      "id": "tier_abc123",

      "name": "Floor",

      "name_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "description": "Standing area near the stage",

      "description_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "max_capacity": 300,

      "min_group_size": 1,

      "max_group_size": 4,

      "currency": "USD",

      "variations": [

        {

          "id": "string",

          "label": "VIP Meet & Greet",

          "label_translations": {

            "is": "King Accounting tenging",

            "fr": "Connexion King Accounting"

          },

          "description": "Includes backstage pass",

          "description_translations": {

            "is": "King Accounting tenging",

            "fr": "Connexion King Accounting"

          },

          "price": 25000

        }

      ],

      "marketplace_visible": true,

      "payment_settings": {

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

      "confirmation_message": "Thanks for booking! Please arrive 15 minutes early.",

      "confirmation_message_translations": {

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

      "capacity": 300,

      "remaining": 250,

      "is_full": false

    }

  ],

  "total_capacity": 500,

  "remaining_capacity": 350,

  "is_full": false,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

Empty

Empty[Delete a scheduled event DELETE](https://docs.noona.is/docs/hq/scheduled-events/DeleteScheduledEvent)

[

Previous Page

](https://docs.noona.is/docs/hq/scheduled-events/DeleteScheduledEvent)[

List scheduled events GET

Next Page

](https://docs.noona.is/docs/hq/scheduled-events/ListScheduledEvents)