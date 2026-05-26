---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Terminals](https://docs.noona.is/docs/hq/terminals)

Lists all terminals connected to a company.

The list includes terminals connected to the company directly and terminals connected to the company through a user.

GET `/v1/hq/companies/{company_id}/terminals`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/terminals"
```

```
[

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

]
```[Get terminal GET](https://docs.noona.is/docs/hq/terminals/GetTerminal)

[

Previous Page

](https://docs.noona.is/docs/hq/terminals/GetTerminal)[

Update a terminal POST

Next Page

](https://docs.noona.is/docs/hq/terminals/UpdateTerminal)