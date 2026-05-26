---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Companies

Lists all VATs applicable for the specified company.

GET `/v1/hq/companies/{company_id}/vats`

BearerTokenAuth

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/vats"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "ratio": 0.24,

    "country_code": "IS",

    "default": true

  }

]
```[List opening hours GET](https://docs.noona.is/docs/hq/companies/ListOpeningHours)

[

Previous Page

](https://docs.noona.is/docs/hq/companies/ListOpeningHours)[

Stream updates GET

Next Page

](https://docs.noona.is/docs/hq/companies/StreamUpdates)