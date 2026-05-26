---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Customers](https://docs.noona.is/docs/hq/customers)

Lists all customers of a company.

GET `/v1/hq/companies/{company_id}/customers`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/customers"
```

```
[

  {

    "id": "7dj29KiAE1wdjw731",

    "name": "Joe the cuttee",

    "kennitala": "1613772649",

    "phone_number": 8578844,

    "phone_country_code": 354,

    "email": "example@example.com",

    "license_plate": "DF302",

    "license_plates": [

      "DF302"

    ],

    "company_id": "2fj29KiKX1wdjw985",

    "company": "2fj29KiKX1wdjw985",

    "event_count": 69,

    "groups": [

      "string"

    ],

    "employee_ids": [

      "1gj29KiKX1wdjw155"

    ],

    "previous_event": {

      "id": "string"

    },

    "next_event": {

      "id": "string"

    },

    "duplicates": {

      "id": "string"

    },

    "duplicateStatus": "possible",

    "notes": "Loves to be called Joe the cuttee",

    "update_origin": "hq",

    "updated_by": "2fj29KiKX1wdjw985",

    "last_employee": "John the hairy",

    "last_event": "date-time",

    "custom_properties": [

      {

        "id": "7awdXwZoedakjad37a",

        "values": [

          "string"

        ],

        "valueIsId": true

      }

    ],

    "attachments": [

      {

        "id": "7awdXwZoedakjad37a",

        "filename": "my_image.jpg",

        "type": "image/jpeg",

        "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

        "relative_url": "/7awdXwZoedakjad37a.jpg",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z"

      }

    ],

    "notices": [

      {

        "id": "8wa9uiah28dawd123",

        "message": "Important information!",

        "variant": "info",

        "dismissable": false,

        "expires_at": "2019-08-24T14:15:22Z",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z"

      }

    ],

    "tags": {

      "gluten_free": true,

      "lactose_intolerant": true,

      "severe_nut_allergy": true,

      "severe_shellfish_allergy": true,

      "vegan": true,

      "vegetarian": true,

      "vip": true,

      "wheelchair": true

    },

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z",

    "marketplace_user": "string",

    "parent_marketplace_user": "string"

  }

]
```[Get customer file GET](https://docs.noona.is/docs/hq/customers/GetCustomerFile)

[

Previous Page

](https://docs.noona.is/docs/hq/customers/GetCustomerFile)[

Merge customers POST

Next Page

](https://docs.noona.is/docs/hq/customers/MergeCustomers)