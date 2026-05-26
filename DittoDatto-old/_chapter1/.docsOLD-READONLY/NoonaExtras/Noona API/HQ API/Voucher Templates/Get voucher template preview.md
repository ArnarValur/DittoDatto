---
tag: "noona.is"
---
Retrieves a preview of a voucher template.

GET `/v1/hq/companies/{company_id}/pdf/voucher_templates`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/pdf/voucher_templates"
```

```
"string"
```

Empty

Empty[List voucher templates GET](https://docs.noona.is/docs/hq/voucher-templates/ListVoucherTemplates)

[

Previous Page

](https://docs.noona.is/docs/hq/voucher-templates/ListVoucherTemplates)[

Update voucher template POST

Next Page

](https://docs.noona.is/docs/hq/voucher-templates/UpdateVoucherTemplate)