---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Permission groups

GET `/v1/hq/companies/{company_id}/permission_groups`

## Path Parameters

company\_id \* string

ID of the company to list permission groups for

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/permission_groups"
```

```
[

  {

    "id": "string",

    "title": "string",

    "readable_id": "string",

    "order": 0,

    "permissions": [

      {

        "id": "string",

        "title": "string",

        "readable_id": "manageAllBookableResources",

        "order": 0,

        "requirements": [

          "manageAllBookableResources"

        ]

      }

    ]

  }

]
```

Empty

Empty[Update payment POST](https://docs.noona.is/docs/hq/payments/UpdatePayment)

[

Previous Page

](https://docs.noona.is/docs/hq/payments/UpdatePayment)[

Product Groups

Next Page

](https://docs.noona.is/docs/hq/product-groups)