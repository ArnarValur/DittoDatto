---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Companies

Uploads a file for a company that can be attached to a booking or customer

POST `/v1/hq/companies/{company_id}/files`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

multipart/form-data

file?string

The file to upload.

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/companies/dwawd8awudawd/files"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "filename": "my_image.jpg",

  "type": "image/jpeg",

  "bytes": 0,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

Empty

Empty

Empty

Empty

Empty[Update a company POST](https://docs.noona.is/docs/hq/companies/UpdateCompany)

[

Previous Page

](https://docs.noona.is/docs/hq/companies/UpdateCompany)[

List company types GET

Next Page

](https://docs.noona.is/docs/hq/companytypes/ListCompanyTypes)