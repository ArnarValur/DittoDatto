---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Terminals](https://docs.noona.is/docs/hq/terminals)

Retrieves terminal with ID.

GET `/v1/hq/terminals/{terminal_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

terminal\_id \* string

Terminal ID

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/terminals/dwawd8awudawd"
```

```
{

  "id": "string",

  "readable_identifier": "Suzy's terminal",

  "brand": "string",

  "model": "string",

  "provider": "Istari",

  "serial": "string",

  "issuer": "string",

  "description": "string",

  "default": true,

  "created_at": 0.1

}
```[Delete a terminal DELETE](https://docs.noona.is/docs/hq/terminals/DeleteTerminal)

[

Previous Page

](https://docs.noona.is/docs/hq/terminals/DeleteTerminal)[

List all terminals GET

Next Page

](https://docs.noona.is/docs/hq/terminals/ListTerminals)