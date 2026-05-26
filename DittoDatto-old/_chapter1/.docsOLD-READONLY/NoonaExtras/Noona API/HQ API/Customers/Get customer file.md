---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Customers](https://docs.noona.is/docs/hq/customers)

Get customer file with signed URL

GET `/v1/hq/customers/{customer_id}/files/{file_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

customer\_id \* string

Example `"dwawd8awudawd"`

file\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/customers/dwawd8awudawd/files/dwawd8awudawd"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "filename": "my_image.jpg",

  "type": "image/jpeg",

  "bytes": 0,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z",

  "signed_url": "string"

}
```

Empty

Empty

Empty

Empty

Empty[Retrieve a customer GET](https://docs.noona.is/docs/hq/customers/GetCustomer)

[

Previous Page

](https://docs.noona.is/docs/hq/customers/GetCustomer)[

List all customers GET

Next Page

](https://docs.noona.is/docs/hq/customers/ListCustomers)