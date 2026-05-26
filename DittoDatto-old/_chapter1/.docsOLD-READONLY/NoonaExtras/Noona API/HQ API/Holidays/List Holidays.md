---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Holidays

List holidays according to the company's country.

The language of the holiday names is can be controlled by including a Accept-Language header. If the header is not included, the language is the company's default language.

GET `/v1/hq/companies/{company_id}/holidays`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Header Parameters

Accept-Language?string

The language of the holiday names. If not included, the language is the company's default language.

Example `"is"`

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/holidays?from=2019-08-24T14%3A15%3A22Z&to=2019-08-24T14%3A15%3A22Z"
```

```
[

  {

    "name": "Christmas Day",

    "date": "2024-12-25"

  }

]
```[Get Google Calendar connection GET](https://docs.noona.is/docs/hq/google-calendar/GetGoogleCalendarConnection)

[

Previous Page

](https://docs.noona.is/docs/hq/google-calendar/GetGoogleCalendarConnection)[

List available invoice issuers GET

Next Page

](https://docs.noona.is/docs/hq/issuers/ListIssuers)