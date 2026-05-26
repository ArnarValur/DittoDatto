---
tag: "noona.is"
---
Update custom property for a company

POST `/v1/hq/properties/{property_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

property\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

company?string

Example `"7awdXwZoedakjad37a"`

name?string

Example `"Age"`

scope?string

Format `enum`

Example `"customers"`

type?string

Format `enum`

Example `"input"`

options?

order?integer

Format `int32`

Example `1`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/properties/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "7awdXwZoedakjad37a",

  "name": "Age",

  "scope": "customers",

  "type": "input",

  "options": [

    {

      "id": "7awdXwZoedakjad37a",

      "name": "string"

    }

  ],

  "order": 1,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

Empty

Empty[List custom properties GET](https://docs.noona.is/docs/hq/custom-properties/ListCustomProperties)

[

Previous Page

](https://docs.noona.is/docs/hq/custom-properties/ListCustomProperties)[

Customer Groups

Next Page

](https://docs.noona.is/docs/hq/customer-groups)