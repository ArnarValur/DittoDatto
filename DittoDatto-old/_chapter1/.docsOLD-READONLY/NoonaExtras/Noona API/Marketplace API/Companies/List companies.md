---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Companies](https://docs.noona.is/docs/marketplace/marketplace-companies)

Retrieves all companies accessible on the Noona marketplace.

```
curl -X GET "https://api.noona.is/v1/marketplace/companies"
```

```
[

  {

    "id": "7dj29KiAE1wdjw731",

    "vertical": "appointment",

    "enterprise_id": "3dj29KiAE1wdjw135",

    "enterprise": "string",

    "profile": {

      "store_name": "John's Hair Salon",

      "description": "string",

      "favorites": 0,

      "company_type_ids": [

        "8aj29KiAE1wdjw143"

      ],

      "company_types": [

        "string"

      ],

      "cuisines": [

        {

          "id": "7awdXwZoedakjad37a",

          "name": "Bistro",

          "readable_id": "bistro",

          "image": "https://placekitten.com/200/200",

          "public_id": "https://placekitten.com/200/300",

          "vertical": "appointment",

          "type": "service_type",

          "available": true

        }

      ],

      "dietaries": [

        {

          "id": "7awdXwZoedakjad37a",

          "name": "Bistro",

          "readable_id": "bistro",

          "image": "https://placekitten.com/200/200",

          "public_id": "https://placekitten.com/200/300",

          "vertical": "appointment",

          "type": "service_type",

          "available": true

        }

      ],

      "ambiences": [

        {

          "id": "7awdXwZoedakjad37a",

          "name": "Bistro",

          "readable_id": "bistro",

          "image": "https://placekitten.com/200/200",

          "public_id": "https://placekitten.com/200/300",

          "vertical": "appointment",

          "type": "service_type",

          "available": true

        }

      ],

      "settings": {

        "license_plate": true

      },

      "image": {

        "thumb": "https://placekitten.com/200/200",

        "image": "https://placekitten.com/200/300",

        "type": "thumbnail",

        "public_id": "https://placekitten.com/200/300"

      },

      "cover_images": [

        {

          "thumb": "https://placekitten.com/200/200",

          "image": "https://placekitten.com/200/300",

          "type": "thumbnail",

          "public_id": "https://placekitten.com/200/300"

        }

      ],

      "phone_country_code": 354,

      "phone_number": "string",

      "prefer_12_hours": true,

      "price_category": 3,

      "min_guests_per_booking": 0,

      "max_guests_per_booking": 0,

      "exceed_max_guests_message": "string"

    },

    "connections": {

      "multiple_services": true,

      "url_name": "string",

      "contact_email": "string",

      "required_fields": {

        "kennitala": true,

        "email": true,

        "license_plate": true

      },

      "opening_hours": [

        {

          "opens_at": "08:00",

          "closes_at": "18:00",

          "is_closed": true

        }

      ],

      "max_future": 0,

      "client_cancel_disabled": true,

      "client_reschedule_disabled": true,

      "min_cancel_notice": 0,

      "min_move_notice": 0,

      "location": {

        "google_place_id": "string",

        "formatted_address": "string",

        "lat_lng": {

          "lat": 0.1,

          "lng": 0.1

        },

        "country": {

          "short_name": "IS",

          "long_name": "Iceland"

        },

        "time_zone": "Atlantic/Reykjavik"

      },

      "booking_redirect_url": "string",

      "web_auth_opt_out": true,

      "booking_success_message": "string",

      "timatorg": true,

      "enable_vouchers": true,

      "enable_amount_vouchers": true,

      "waitlist_enabled": true,

      "show_booking_ends_at": true,

      "tracking": true

    },

    "no_show_enabled": true,

    "most_recently_visited_company": true,

    "locale": {

      "ui_language": "is",

      "messaging_language": "is",

      "default_currency": {

        "code": "EUR",

        "name": "Euro",

        "symbol": "€"

      }

    },

    "relative_location": {

      "lat": 0.1,

      "lng": 0.1,

      "distance": 0.1

    },

    "payment_provider": "teya"

  }

]
```[Retrieve a company GET](https://docs.noona.is/docs/marketplace/marketplace-companies/GetCompanyByUrlName)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-companies/GetCompanyByUrlName)[

List company opening hours GET

Next Page

](https://docs.noona.is/docs/marketplace/marketplace-companies/ListCompanyOpeningHours)