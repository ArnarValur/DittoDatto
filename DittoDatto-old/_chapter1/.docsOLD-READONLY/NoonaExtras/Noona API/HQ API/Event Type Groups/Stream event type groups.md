---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Event Type Groups](https://docs.noona.is/docs/hq/event-type-groups)

Streams event type groups for a company.

GET `/v1/hq/stream/companies/{company_id}/event_type_groups`

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
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd/event_type_groups"
```

Empty[List event type groups GET](https://docs.noona.is/docs/hq/event-type-groups/ListEventTypeGroups)

[

Previous Page

](https://docs.noona.is/docs/hq/event-type-groups/ListEventTypeGroups)[

Update event type group POST

Next Page

](https://docs.noona.is/docs/hq/event-type-groups/UpdateEventTypeGroup)