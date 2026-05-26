---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Event Type Categories](https://docs.noona.is/docs/marketplace/event-type-categories)

Lists event type categories.

GET `/v1/marketplace/event_type_categories`

Marketplace-Authentication

## Query Parameters

## Header Parameters

Accept-Language?string

The language to return event type categories in.

It is also possible to query for all languages by passing in "\*".

Example `"is"`

## Response Body

```
curl -X GET "https://api.noona.is/v1/marketplace/event_type_categories"
```

```
[

  {

    "titles": {

      "en": "Men's haircut",

      "is": "Karlaklipping",

      "fr": "Coupe pour homme"

    }

  }

]
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Event Type Categories](https://docs.noona.is/docs/marketplace/event-type-categories)

[

Previous Page

](https://docs.noona.is/docs/marketplace/event-type-categories)[

Event Types

Next Page

](https://docs.noona.is/docs/marketplace/event-types)