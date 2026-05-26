---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Suggestions](https://docs.noona.is/docs/marketplace/suggestions)

Returns a suggested company type based on the user's location, booking history and behavior.

```
curl -X GET "https://api.noona.is/v1/marketplace/suggestions/company_type"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "name": "Hair salons",

  "promotion": "Did you know you can book a haircut on Noona?",

  "locale_key": "hairstyling",

  "image": "https://api.noona.is/static/haircut.png",

  "public_id": "https://placekitten.com/200/300"

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Suggestions](https://docs.noona.is/docs/marketplace/suggestions)

[

Previous Page

](https://docs.noona.is/docs/marketplace/suggestions)[

List suggested companies GET

Next Page

](https://docs.noona.is/docs/marketplace/suggestions/ListSuggestedCompanies)