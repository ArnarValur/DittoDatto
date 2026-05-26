---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace)

List all company types and metadata about company types.

Providing a **latitude** and **longitude** causes results to be specific to the relevant country.

```
curl -X GET "https://api.noona.is/v1/marketplace/company_types"
```

```
{

  "company_types": [

    {

      "id": "7awdXwZoedakjad37a",

      "name": "Hair salons",

      "promotion": "Did you know you can book a haircut on Noona?",

      "locale_key": "hairstyling",

      "image": "https://api.noona.is/static/haircut.png",

      "public_id": "https://placekitten.com/200/300"

    }

  ]

}
```