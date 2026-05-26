---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Spaces](https://docs.noona.is/docs/marketplace/spaces)

Lists spaces at a given company.

```
curl -X GET "https://api.noona.is/v1/marketplace/companies/aw7da9wd8ua28a821/spaces"
```

```
[

  {

    "id": "7dj29KiAE1wdjw731",

    "name": "Room 3",

    "description": "The room where the magic happens",

    "image": {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "type": "thumbnail",

      "public_id": "https://placekitten.com/200/300"

    },

    "company_id": "3dj29KiAE1wdjw135",

    "company": "string",

    "event_type_preferences": [

      {

        "id": "dw7aw7da6w8d76aw",

        "can_perform": true

      }

    ],

    "marketplace": true,

    "deleted_at": "2019-08-24T14:15:22Z"

  }

]
```[Get space GET](https://docs.noona.is/docs/marketplace/spaces/GetSpace)

[

Previous Page

](https://docs.noona.is/docs/marketplace/spaces/GetSpace)[

Suggestions

Next Page

](https://docs.noona.is/docs/marketplace/suggestions)