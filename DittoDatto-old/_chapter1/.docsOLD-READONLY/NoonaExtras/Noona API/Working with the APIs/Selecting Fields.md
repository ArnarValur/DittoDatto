---
tag: "noona.is"
---
Working with the APIs

---

All endpoints that return data support field selection via the **select** query parameter.

Field selection allows saving bandwidth by returning only the fields required at any given point in time.

This is applicable when listing, retrieving and creating data.

If select is **not provided**, the whole object is returned.

```
{

  "id": "7dj29KiAE1wdjw731",

  "enterprise_id": "3dj29KiAE1wdjw135",

  "profile": {

    "store_name": "John's Hair Salon",

    "description": "string",

    "favorites": 0,

    "company_type_ids": ["8aj29KiAE1wdjw143"],

    "settings": {

      "license_plate": true

    },

    "image": {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "public_id": "https://placekitten.com/200/300"

    },

    "cover_images": [

      {

        "thumb": "https://placekitten.com/200/200",

        "image": "https://placekitten.com/200/300",

        "public_id": "https://placekitten.com/200/300"

      }

    ],

    "phone_number": "string"

  },

  "connections": {

    "multiple_services": true,

    "url_name": "string",

    "contact_email": "string",

    "required_fields": {

      "kennitala": true,

      "email": true

    },

    "opening_hours": [

      {

        "opens_at": "08:00",

        "closes_at": "18:00",

        "is_closed": true

      }

    ],

    "max_future": 0,

    "min_cancel_notice": 0,

    "location": {

      "formatted_address": "string",

      "lat_lng": {

        "lat": 0,

        "lng": 0

      },

      "country": {

        "short_name": "IS",

        "long_name": "Iceland"

      }

    },

    "booking_redirect_url": "string",

    "web_auth_opt_out": true,

    "booking_success_message": "string",

    "timatorg": true,

    "enable_vouchers": true,

    "min_move_notice": 0

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

  }

}
```

The **select** query parameter accepts an array of keys that should be returned:

```
select="profile.store_name"&select="connections.location.country.long_name"
```

**Result**

```
{

  "profile": {

    "store_name": "John's Hair Salon"

  },

  "connections": {

    "location": {

      "country": {

        "long_name": "Iceland"

      }

    }

  }

}
```[Expandable Attributes](https://docs.noona.is/docs/working-with-the-apis/expandable-attributes)

[

Sorting

](https://docs.noona.is/docs/working-with-the-apis/sorting)