---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Roles

GET `/v1/hq/companies/{company_id}/roles`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

ID of the company to list roles for

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/roles"
```

```
[

  {

    "id": "7awdXawZoolkjad37a",

    "title": "Employee",

    "type": "default",

    "permissions": [

      "manageAllBookableResources"

    ]

  }

]
```

Empty

Empty

Empty[Get Role GET](https://docs.noona.is/docs/hq/roles/GetRole)

[

Previous Page

](https://docs.noona.is/docs/hq/roles/GetRole)[

Update Role POST

Next Page

](https://docs.noona.is/docs/hq/roles/UpdateRole)