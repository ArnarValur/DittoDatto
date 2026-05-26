---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Roles

POST `/v1/hq/roles/{role_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

role\_id \* string

ID of the role to update

## Query Parameters

## Request Body

application/json

company\_id?string

Example `"7awdXawZoolkjad37a"`

title?string

Example `"Employee"`

permissions?array<Permission>

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/roles/string" \

  -H "Content-Type: application/json" \

  -d '{}'
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

Empty[List Roles GET](https://docs.noona.is/docs/hq/roles/ListRoles)

[

Previous Page

](https://docs.noona.is/docs/hq/roles/ListRoles)[

Rule Set Templates

Next Page

](https://docs.noona.is/docs/hq/rule-set-templates)