---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Event Type Category Groups](https://docs.noona.is/docs/hq/event-type-category-groups)

GET `/v1/hq/event_type_category_groups`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/event_type_category_groups"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "readable_id": "barbering",

    "name": "Barbering"

  }

]
```[Event Type Category Groups](https://docs.noona.is/docs/hq/event-type-category-groups)

[

Previous Page

](https://docs.noona.is/docs/hq/event-type-category-groups)[

List all event type category groups GET

Next Page

](https://docs.noona.is/docs/hq/event-type-category-groups/ListEventTypeCategoryGroupsForCompany)