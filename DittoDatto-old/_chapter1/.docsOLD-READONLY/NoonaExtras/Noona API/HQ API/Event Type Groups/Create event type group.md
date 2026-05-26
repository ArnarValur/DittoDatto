---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Event Type Groups](https://docs.noona.is/docs/hq/event-type-groups)

Creates an event type group

POST `/v1/hq/event_type_groups`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company?string

Example `"7awdXwZoedakjad37a"`

title?string

Example `"Haircuts"`

title\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

description?string

Example `"Haircuts"`

description\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

images?

order?integer

Format `int32`

Example `1`

event\_types?array<string>

is\_default\_group?boolean

Example `true`

parent\_event\_type\_group?string

Example `"7awdXwZoedakjad37a"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/event_type_groups" \

  -H "Content-Type: application/json" \

  -d '{}'
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

Empty

Empty[Event Type Groups](https://docs.noona.is/docs/hq/event-type-groups)

[

Previous Page

](https://docs.noona.is/docs/hq/event-type-groups)[

Delete event type group DELETE

Next Page

](https://docs.noona.is/docs/hq/event-type-groups/DeleteEventTypeGroup)