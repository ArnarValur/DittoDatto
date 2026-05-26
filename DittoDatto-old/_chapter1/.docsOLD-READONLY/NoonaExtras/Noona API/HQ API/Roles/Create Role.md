---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Roles

POST `/v1/hq/roles`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

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
curl -X POST "https://api.noona.is/v1/hq/roles" \

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

Empty[Update a resource POST](https://docs.noona.is/docs/hq/resources/UpdateResource)

[

Previous Page

](https://docs.noona.is/docs/hq/resources/UpdateResource)[

Delete Role DELETE

Next Page

](https://docs.noona.is/docs/hq/roles/DeleteRole)