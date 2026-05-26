---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [User](https://docs.noona.is/docs/marketplace/marketplace-user)

Lists categories that the user has booked in.

```
curl -X GET "https://api.noona.is/v1/marketplace/user/categories"
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
```[Get user GET](https://docs.noona.is/docs/marketplace/marketplace-user/GetUser)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-user/GetUser)[

List user companies GET

Next Page

](https://docs.noona.is/docs/marketplace/marketplace-user/ListUserCompanies)