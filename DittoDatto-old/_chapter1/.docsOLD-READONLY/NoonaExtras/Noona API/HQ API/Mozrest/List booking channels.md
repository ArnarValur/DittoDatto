---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Mozrest](https://docs.noona.is/docs/hq/mozrest)

Lists all Mozrest booking channels in the context of a specific company.

GET `/v1/hq/integrations/mozrest/companies/{company_id}/booking_channels`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/integrations/mozrest/companies/string/booking_channels"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "name": "Tripadvisor",

    "enabled": true,

    "status": "not_enabled",

    "install_link": "https://meta.oauth/mozrest"

  }

]
```[Mozrest](https://docs.noona.is/docs/hq/mozrest)

[

Previous Page

](https://docs.noona.is/docs/hq/mozrest)[

Update booking channel POST

Next Page

](https://docs.noona.is/docs/hq/mozrest/UpdateMozrestBookingChannel)