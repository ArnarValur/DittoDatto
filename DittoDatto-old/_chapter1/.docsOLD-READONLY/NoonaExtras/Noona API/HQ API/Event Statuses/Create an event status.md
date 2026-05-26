---
tag: "noona.is"
---
Creates an event status for a company.

POST `/v1/hq/event_statuses`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

id?string

Example `"7awdXwZoedakjad37a"`

company?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

name?string

Example `"showup"`

label?string

The label of the status. This is the label that is shown to the user in the UI.

For default Noona statuses the label is translated according to the Accept-Language header.

For custom statuses the label is simply the value of the `label` field.

Example `"Show-up"`

order?integer

The order of the status. This is the order that the statuses are shown in the UI.

For default Noona statuses the order is always 0.

Order can be used to sort custom statuses.

Format `int32`

Example `1`

color?string

Example `"#00FF00"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/event_statuses" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "name": "showup",

  "label": "Show-up",

  "order": 1,

  "color": "#00FF00",

  "default": true,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```[Event Statuses](https://docs.noona.is/docs/hq/event-statuses)

[

Previous Page

](https://docs.noona.is/docs/hq/event-statuses)[

Delete event status DELETE

Next Page

](https://docs.noona.is/docs/hq/event-statuses/DeleteEventStatus)