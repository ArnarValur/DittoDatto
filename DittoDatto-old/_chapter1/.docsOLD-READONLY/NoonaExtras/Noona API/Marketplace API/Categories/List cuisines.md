---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace)

Lists available cuisines.

```
curl -X GET "https://api.noona.is/v1/marketplace/cuisines"
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