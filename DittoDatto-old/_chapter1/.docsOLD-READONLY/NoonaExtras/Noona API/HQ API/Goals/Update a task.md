---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Goals](https://docs.noona.is/docs/hq/goals)

Updates a task instance. Currently supports marking tasks as complete.

POST `/v1/hq/tasks/{task_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

task\_id \* string

Example `"dwawd8awudawd"`

## Request Body

application/json

company\_id \* string

The company ID that owns the task

completed?boolean

Set to true to mark the task as complete. For manual tasks only. Computed tasks are automatically evaluated.

## Response Body[Update a goal POST](https://docs.noona.is/docs/hq/goals/UpdateGoal)

[

Previous Page

](https://docs.noona.is/docs/hq/goals/UpdateGoal)[

Create Google Calendar connection POST

Next Page

](https://docs.noona.is/docs/hq/google-calendar/CreateGoogleCalendarConnection)