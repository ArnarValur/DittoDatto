---
tag: "noona.is"
---
Delete resource group for a company

DELETE `/v1/hq/resource_groups/{resource_group_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

resource\_group\_id \* string

Resource Group ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/resource_groups/string"
```

Empty

```
{

  "message": "Customer onboarding error."

}
```

Empty

Empty

Empty[Create a resource group POST](https://docs.noona.is/docs/hq/resource-groups/CreateResourceGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/resource-groups/CreateResourceGroup)[

Retrieve a resource group GET

Next Page

](https://docs.noona.is/docs/hq/resource-groups/GetResourceGroup)