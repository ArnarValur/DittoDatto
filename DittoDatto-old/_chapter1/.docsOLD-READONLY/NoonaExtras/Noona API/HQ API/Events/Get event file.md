---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Events](https://docs.noona.is/docs/hq/events)

Get event file with signed URL

GET `/v1/hq/events/{event_id}/files/{file_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

event\_id \* string

Example `"dwawd8awudawd"`

file\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/events/dwawd8awudawd/files/dwawd8awudawd"
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

Empty[Retrieve an event GET](https://docs.noona.is/docs/hq/events/GetEvent)

[

Previous Page

](https://docs.noona.is/docs/hq/events/GetEvent)[

List events GET

Next Page

](https://docs.noona.is/docs/hq/events/ListEvents)