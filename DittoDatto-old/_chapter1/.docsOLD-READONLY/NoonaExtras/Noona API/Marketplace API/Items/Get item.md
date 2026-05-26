---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Items](https://docs.noona.is/docs/marketplace/items)

Retrieves a specific marketplace item by ID. No authentication required.

```
curl -X GET "https://api.noona.is/v1/marketplace/items/string"
```

```
{

  "id": "string",

  "type": "scheduled_event",

  "company": "string",

  "name": "string",

  "description": "string",

  "starts_at": "2019-08-24T14:15:22Z",

  "ends_at": "2019-08-24T14:15:22Z",

  "marketplace_visible": true,

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

  "allow_cancellation": true,

  "min_cancel_notice_minutes": 0,

  "customer_selects_tier": true,

  "images": [

    {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "type": "thumbnail",

      "public_id": "https://placekitten.com/200/300"

    }

  ],

  "tiers": [

    {

      "id": "string",

      "name": "string",

      "description": "string",

      "max_capacity": 0,

      "capacity": 0,

      "remaining": 0,

      "is_full": true,

      "min_group_size": 0,

      "max_group_size": 0,

      "currency": "string",

      "marketplace_visible": true,

      "confirmation_message": "string",

      "booking_questions": [

        {

          "id": "string",

          "title": "string",

          "description": "string",

          "answer_required": true,

          "answer_type": "string"

        }

      ],

      "variations": [

        {

          "id": "string",

          "label": "string",

          "description": "string",

          "price": 0

        }

      ],

      "event_type": "string",

      "resource": "string"

    }

  ],

  "total_capacity": 0,

  "remaining_capacity": 0,

  "is_full": true,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Items](https://docs.noona.is/docs/marketplace/items)

[

Previous Page

](https://docs.noona.is/docs/marketplace/items)[

List items GET

Next Page

](https://docs.noona.is/docs/marketplace/items/ListItems)