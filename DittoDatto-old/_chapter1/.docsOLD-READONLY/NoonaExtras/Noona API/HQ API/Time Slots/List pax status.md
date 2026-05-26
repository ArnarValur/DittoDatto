---
tag: "noona.is"
---
Lists pax statuses for date range.

The pax status is based on:

- Rules in effect
- Existing events

GET `/v1/hq/companies/{company_id}/pax_statuses`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

Example `"aw7da9wd8ua28a821"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/aw7da9wd8ua28a821/pax_statuses"
```

```
{

  "2024-05-02": {

    "12:00": {

      "arrivals": 1,

      "guests": 1,

      "max_guests": 50,

      "max_same_time_arrival": 10

    },

    "12:15": {

      "arrivals": 1,

      "guests": 2,

      "max_guests": 50,

      "max_same_time_arrival": 10

    },

    "12:30": {

      "arrivals": 0,

      "guests": 1,

      "max_guests": 50,

      "max_same_time_arrival": 10

    }

  }

}
```[Get time slot reservation GET](https://docs.noona.is/docs/hq/time-slots/GetTimeSlotReservation)

[

Previous Page

](https://docs.noona.is/docs/hq/time-slots/GetTimeSlotReservation)[

List time slot reservations GET

Next Page

](https://docs.noona.is/docs/hq/time-slots/ListTimeSlotReservations)