---
tag: "noona.is"
---
Gets all available tima slots for company based on filter.

Either **event\_type\_ids** or **event\_id** must be provided.

Capacity is the number of customers in booking.

GET `/v1/marketplace/companies/{id}/time_slots`

## Path Parameters

id \* string

Company ID

Example `"aw7da9wd8ua28a821"`

## Query Parameters

employee\_id?string

Example `"8a1da9wd8ua28aa9d"`

space\_id?string

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

type?string

Filter by type of time slots to return.

`available` will only return slots with resources available.

`unavailable` will only return slots with resources unavailable.

`all` will return all slots.

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

expand?array<string>

[Expandable attributes](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body[List speedy tables for restaurant vertical GET](https://docs.noona.is/docs/marketplace/time-slots/ListSpeedyTables)

[

Previous Page

](https://docs.noona.is/docs/marketplace/time-slots/ListSpeedyTables)[

Update time slot reservation POST

Next Page

](https://docs.noona.is/docs/marketplace/time-slots/UpdateTimeSlotReservation)