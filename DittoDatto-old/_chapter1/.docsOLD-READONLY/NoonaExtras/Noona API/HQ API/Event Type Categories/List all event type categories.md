---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Event Type Categories](https://docs.noona.is/docs/hq/event-type-categories)

Lists all even type categories

GET `/v1/hq/companies/{company_id}/event_type_categories`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/event_type_categories"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "group": "7awdXwZoedakjad37a",

    "name": "Men's Haircut"

  }

]
```[Event Type Categories](https://docs.noona.is/docs/hq/event-type-categories)

[

Previous Page

](https://docs.noona.is/docs/hq/event-type-categories)[

Event Type Category Groups

Next Page

](https://docs.noona.is/docs/hq/event-type-category-groups)