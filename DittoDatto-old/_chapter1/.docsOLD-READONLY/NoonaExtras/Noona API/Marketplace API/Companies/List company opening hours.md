---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Companies](https://docs.noona.is/docs/marketplace/marketplace-companies)

Lists opening hours of a company.

GET `/v1/marketplace/companies/{company_id}/opening_hours`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

filter?

[Filtering](https://api.noona.is/docs/working-with-the-apis/filtering)

Date range must be less than a year.

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

expand?array<string>

[Expandable attributes](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body

```
curl -X GET "https://api.noona.is/v1/marketplace/companies/dwawd8awudawd/opening_hours"
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
```[List companies GET](https://docs.noona.is/docs/marketplace/marketplace-companies/ListCompanies)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-companies/ListCompanies)[

List companies for map GET

Next Page

](https://docs.noona.is/docs/marketplace/marketplace-companies/ListMapCompanies)