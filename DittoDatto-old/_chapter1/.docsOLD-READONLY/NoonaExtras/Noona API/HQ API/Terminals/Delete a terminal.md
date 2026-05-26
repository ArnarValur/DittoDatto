---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Terminals](https://docs.noona.is/docs/hq/terminals)

Deletes a terminal connected to a company.

DELETE `/v1/hq/terminals/{terminal_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

terminal\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/terminals/dwawd8awudawd"
```

Empty[Terminals](https://docs.noona.is/docs/hq/terminals)

[

Previous Page

](https://docs.noona.is/docs/hq/terminals)[

Get terminal GET

Next Page

](https://docs.noona.is/docs/hq/terminals/GetTerminal)