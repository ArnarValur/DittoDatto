---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Event Type Category Groups](https://docs.noona.is/docs/hq/event-type-category-groups)

Lists all even type category groups

GET `/v1/hq/companies/{company_id}/event_type_category_groups`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/event_type_category_groups"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "readable_id": "barbering",

    "name": "Barbering"

  }

]
```[List Event Type Category Groups GET](https://docs.noona.is/docs/hq/event-type-category-groups/ListEventTypeCategoryGroups)

[

Previous Page

](https://docs.noona.is/docs/hq/event-type-category-groups/ListEventTypeCategoryGroups)[

Event Type Groups

Next Page

](https://docs.noona.is/docs/hq/event-type-groups)