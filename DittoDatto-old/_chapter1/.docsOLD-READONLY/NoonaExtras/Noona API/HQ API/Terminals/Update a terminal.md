---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Terminals](https://docs.noona.is/docs/hq/terminals)

Updates a terminal connected to a company.

POST `/v1/hq/terminals/{terminal_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

terminal\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

readable\_identifier?string

Example `"Suzy's terminal"`

description?string

default?boolean

Whether this terminal is the default terminal to use for sales.

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/terminals/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
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
```[List all terminals GET](https://docs.noona.is/docs/hq/terminals/ListTerminals)

[

Previous Page

](https://docs.noona.is/docs/hq/terminals/ListTerminals)[

Time Slots

Next Page

](https://docs.noona.is/docs/hq/time-slots)