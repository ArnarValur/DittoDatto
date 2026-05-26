---
tag: "noona.is"
---
Lists booking offers for the marketplace user.

```
curl -X GET "https://api.noona.is/v1/marketplace/booking_offers"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "employee": "string",

    "time_slot_reservation": {

      "id": "string"

    },

    "waitlist_entry": "string",

    "is_desired_time": true,

    "message": "We have an opening for your requested service!",

    "expires_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Get booking offer GET](https://docs.noona.is/docs/marketplace/booking-offers/GetBookingOffer)

[

Previous Page

](https://docs.noona.is/docs/marketplace/booking-offers/GetBookingOffer)[

Cards

Next Page

](https://docs.noona.is/docs/marketplace/cards)