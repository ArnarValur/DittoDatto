---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Roles

GET `/v1/hq/roles/{role_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

role\_id \* string

ID of the role to get

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/roles/string"
```

```
{

  "id": "7awdXawZoolkjad37a",

  "title": "Employee",

  "type": "default",

  "permissions": [

    "manageAllBookableResources"

  ]

}
```

Empty

Empty

Empty[Delete Role DELETE](https://docs.noona.is/docs/hq/roles/DeleteRole)

[

Previous Page

](https://docs.noona.is/docs/hq/roles/DeleteRole)[

List Roles GET

Next Page

](https://docs.noona.is/docs/hq/roles/ListRoles)