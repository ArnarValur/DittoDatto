---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Mozrest](https://docs.noona.is/docs/hq/mozrest)

Updates a Mozrest booking channel in the context of a company.

POST `/v1/hq/integrations/mozrest/companies/{company_id}/booking_channels/{booking_channel_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

booking\_channel\_id \* string

Booking Channel ID

## Query Parameters

## Request Body

application/json

enabled \* boolean

Example `true`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/integrations/mozrest/companies/string/booking_channels/string" \

  -H "Content-Type: application/json" \

  -d '{

    "enabled": true

  }'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "name": "Tripadvisor",

  "enabled": true,

  "status": "not_enabled",

  "install_link": "https://meta.oauth/mozrest"

}
```[List booking channels GET](https://docs.noona.is/docs/hq/mozrest/ListMozrestBookingChannels)

[

Previous Page

](https://docs.noona.is/docs/hq/mozrest/ListMozrestBookingChannels)[

Retrieve notification settings configuration GET

Next Page

](https://docs.noona.is/docs/hq/notification-settings/ListNotificationSettings)