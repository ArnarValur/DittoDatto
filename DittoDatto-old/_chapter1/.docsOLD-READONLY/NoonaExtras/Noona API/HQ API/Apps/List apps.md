---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Apps](https://docs.noona.is/docs/hq/apps)

Lists all apps for the specified company.

GET `/v1/hq/companies/{company_id}/apps`

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

## Response Body[Get app GET](https://docs.noona.is/docs/hq/apps/GetApp)

[

Previous Page

](https://docs.noona.is/docs/hq/apps/GetApp)[

Blocked times

Next Page

](https://docs.noona.is/docs/hq/blocked-times)