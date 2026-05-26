---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Recommendations](https://docs.noona.is/docs/marketplace/recommendations)

Returns a list of suggested quick booking searches based on the user's location, booking history and behavior.

```
curl -X GET "https://api.noona.is/v1/marketplace/suggestions/quick_booking_searches"
```

```
[

  {

    "keyword": "Men's haircut"

  }

]
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```