---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Enterprise

Lists all enterprises the user has access to.

GET `/v1/hq/enterprises`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/enterprises"
```

```
[

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

]
```

Empty

Empty[List enterprise companies GET](https://docs.noona.is/docs/hq/enterprise/ListEnterpriseCompanies)

[

Previous Page

](https://docs.noona.is/docs/hq/enterprise/ListEnterpriseCompanies)[

Update enterprise POST

Next Page

](https://docs.noona.is/docs/hq/enterprise/UpdateEnterprise)