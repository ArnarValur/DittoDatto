---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Companies

Lists opening hours of a company.

GET `/v1/hq/companies/{company_id}/opening_hours`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

filter?

[Filtering](https://api.noona.is/docs/working-with-the-apis/filtering)

Date range must be less than a year.

mode?string

Default `"company"`

sort?

[Sorting](https://api.noona.is/docs/working-with-the-apis/sorting)

pagination?

[Pagination](https://api.noona.is/docs/working-with-the-apis/pagination)

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

expand?array<string>

[Expandable attributes](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/opening_hours"
```

```
{

  "2020-08-24": [

    {

      "starts_at": "11:00",

      "ends_at": "13:00"

    },

    {

      "starts_at": "18:00",

      "ends_at": "21:00"

    }

  ]

}
```[Get company GET](https://docs.noona.is/docs/hq/companies/GetCompany)

[

Previous Page

](https://docs.noona.is/docs/hq/companies/GetCompany)[

List VATs GET

Next Page

](https://docs.noona.is/docs/hq/companies/ListVATs)