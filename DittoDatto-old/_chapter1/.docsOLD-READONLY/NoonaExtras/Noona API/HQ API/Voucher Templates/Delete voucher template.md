---
tag: "noona.is"
---
Deletes a voucher template at enterprise.

It is only possible to delete voucher templates that have not been used to create vouchers.

DELETE `/v1/hq/voucher_templates/{voucher_template_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

voucher\_template\_id \* string

Voucher Template ID

## Query Parameters

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/voucher_templates/string"
```

Empty

Empty[Create voucher template POST](https://docs.noona.is/docs/hq/voucher-templates/CreateVoucherTemplate)

[

Previous Page

](https://docs.noona.is/docs/hq/voucher-templates/CreateVoucherTemplate)[

Get voucher template GET

Next Page

](https://docs.noona.is/docs/hq/voucher-templates/GetVoucherTemplate)