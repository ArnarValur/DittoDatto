---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Event Type Groups](https://docs.noona.is/docs/hq/event-type-groups)

Retrieves event type group by ID

GET `/v1/hq/event_type_groups/{event_type_group_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

event\_type\_group\_id \* string

Event Type Group ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/event_type_groups/string"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "parent_event_type_group": {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "parent_event_type_group": {

      "id": "string"

    },

    "title": "Haircuts",

    "title_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "description": "Haircuts",

    "description_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

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

    "order": 1,

    "is_default_group": true,

    "ordered_event_types": [

      {

        "order": 1,

        "event_type": "string"

      }

    ]

  },

  "title": "Haircuts",

  "title_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "description": "Haircuts",

  "description_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

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

  "order": 1,

  "is_default_group": true,

  "ordered_event_types": [

    {

      "order": 1,

      "event_type": "string"

    }

  ]

}
```

Empty[Delete event type group DELETE](https://docs.noona.is/docs/hq/event-type-groups/DeleteEventTypeGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/event-type-groups/DeleteEventTypeGroup)[

List event type groups GET

Next Page

](https://docs.noona.is/docs/hq/event-type-groups/ListEventTypeGroups)