---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Enterprise

Retrieve enterprise by ID.

GET `/v1/hq/enterprise/{enterprise_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

enterprise\_id \* string

Enterprise ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/enterprise/string"
```

```
{

  "id": "aqmzX9Cm5tekKecsA",

  "companies": [

    "string"

  ],

  "connections": {

    "available_on_marketplace": true,

    "url_name": "noonacuts",

    "allows_booking_without_auth": true,

    "marketplace": {

      "enable_vouchers": true

    },

    "vouchers": {

      "enabled": true,

      "settlement_account_id": "wda8wud9a8wuddopk"

    }

  },

  "profile": {

    "name": "Noonacuts",

    "image": {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "public_id": "https://placekitten.com/200/300",

      "type": "thumbnail",

      "provider": "cloudinary",

      "width": 200,

      "height": 300,

      "bytes": 95849

    },

    "cover_images": [

      {

        "thumb": "https://placekitten.com/200/200",

        "image": "https://placekitten.com/200/300",

        "public_id": "https://placekitten.com/200/300",

        "type": "thumbnail",

        "provider": "cloudinary",

        "width": 200,

        "height": 300,

        "bytes": 95849

      }

    ]

  }

}
```

Empty[Update an employee POST](https://docs.noona.is/docs/hq/employees/UpdateEmployee)

[

Previous Page

](https://docs.noona.is/docs/hq/employees/UpdateEmployee)[

List enterprise companies GET

Next Page

](https://docs.noona.is/docs/hq/enterprise/ListEnterpriseCompanies)