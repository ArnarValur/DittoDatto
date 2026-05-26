---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Waitlists

Deletes a waitlist entry at company.

DELETE `/v1/hq/waitlist_entries/{waitlist_entry_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

waitlist\_entry\_id \* string

Waitlist Entry ID

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/waitlist_entries/dwawd8awudawd"
```

Empty[Create a waitlist entry POST](https://docs.noona.is/docs/hq/waitlists/CreateWaitlistEntry)

[

Previous Page

](https://docs.noona.is/docs/hq/waitlists/CreateWaitlistEntry)[

Retrieve a waitlist entry GET

Next Page

](https://docs.noona.is/docs/hq/waitlists/GetWaitlistEntry)