---
tag: "noona.is"
---
Gets all available tima slots for company based on filter.

Either **event\_type\_ids** or **event\_id** must be provided.

Capacity is the number of customers in booking.

GET `/v1/hq/companies/{company_id}/time_slots`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

Example `"aw7da9wd8ua28a821"`

## Query Parameters

employee\_id?string

Example `"8a1da9wd8ua28aa9d"`

resource\_id?string

Example `"ea7da9wd8ua28a134"`

event\_type\_ids?array<string>

event\_id?string

Example `"xa7da9wd8ua01a134"`

start\_date \* string

Example `"2021-01-01"`

end\_date \* string

Example `"2021-01-31"`

capacity?integer

Default `1`

Format `int32`

Example `5`

duration?integer

Duration is by default inferred from event type(s) but can be overwritten with this parameter.

Format `int32`

Example `30`

skip\_can\_perform?boolean

If true, skips checking if employees and resources can perform the event types and returns all available timeslots

Example `false`

override\_booking\_interval?integer

Override the booking interval used for generating timeslots. This overrides the intervals set on the company, employees, and resources.

Default `15`

Format `int32`

Example `15`

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

expand?array<string>

[Expandable attributes](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body[List time slot reservations GET](https://docs.noona.is/docs/hq/time-slots/ListTimeSlotReservations)

[

Previous Page

](https://docs.noona.is/docs/hq/time-slots/ListTimeSlotReservations)[

Stream time slot reservations GET

Next Page

](https://docs.noona.is/docs/hq/time-slots/StreamTimeSlotReservations)