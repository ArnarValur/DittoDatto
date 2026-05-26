---
tag: "noona.is"
---
Delete custom property for a company

DELETE `/v1/hq/properties/{property_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

property\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/properties/dwawd8awudawd"
```

Empty

Empty

Empty[Create custom property POST](https://docs.noona.is/docs/hq/custom-properties/CreateCustomProperty)

[

Previous Page

](https://docs.noona.is/docs/hq/custom-properties/CreateCustomProperty)[

List custom properties GET

Next Page

](https://docs.noona.is/docs/hq/custom-properties/ListCustomProperties)