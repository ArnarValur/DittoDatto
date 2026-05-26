---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Recommendations](https://docs.noona.is/docs/marketplace/recommendations)

Returns a list of recommended categories based on the user's location, booking history and behavior.

```
curl -X GET "https://api.noona.is/v1/marketplace/recommendations/categories"
```

```
{

  "categories": [

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

  ]

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```