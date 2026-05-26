---
tag: "noona.is"
---
Lists custom properties for a company

GET `/v1/hq/companies/{company_id}/properties`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/properties"
```

```
[

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

]
```

Empty

Empty[Delete custom property DELETE](https://docs.noona.is/docs/hq/custom-properties/DeleteCustomProperty)

[

Previous Page

](https://docs.noona.is/docs/hq/custom-properties/DeleteCustomProperty)[

Update custom property POST

Next Page

](https://docs.noona.is/docs/hq/custom-properties/UpdateCustomProperty)