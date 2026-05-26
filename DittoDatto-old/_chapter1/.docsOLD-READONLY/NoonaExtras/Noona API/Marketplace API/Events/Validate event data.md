---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Events](https://docs.noona.is/docs/marketplace/marketplace-events)

Validates data gathered in the booking/event-creation flow.

```
curl -X POST "https://api.noona.is/v1/marketplace/companies/string/events/validate" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "name": "",

  "phone_country_code": "",

  "phone_number": "",

  "license_plate": "",

  "ssn": "",

  "email": ""

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Update an event POST](https://docs.noona.is/docs/marketplace/marketplace-events/UpdateEvent)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-events/UpdateEvent)[

User

Next Page

](https://docs.noona.is/docs/marketplace/marketplace-user)