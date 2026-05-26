---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Goals](https://docs.noona.is/docs/hq/goals)

Updates properties of a goal instance.

POST `/v1/hq/goals/{goal_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

goal\_id \* string

Example `"dwawd8awudawd"`

## Request Body

application/json

goal\_completion\_acknowledged?boolean

Whether the goal completion has been acknowledged

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/goals/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company_id": "7awdXwZoedakjad37a",

  "goal_template": "goal_first_online_booking",

  "active": true,

  "title": "Get your first online booking",

  "description": "Complete these tasks to get your first booking",

  "completed_description": "You've successfully completed all tasks",

  "tasks": [

    {

      "id": "7awdXwZoedakjad37a",

      "company_id": "7awdXwZoedakjad37a",

      "goal_instance": "7awdXwZoedakjad37a",

      "task_template": "task_create_services",

      "title": "Create your services",

      "description": "Add at least one service to your catalog",

      "completion_method": "manual",

      "order": 1,

      "prerequisites": [

        "task_create_services"

      ],

      "icon": "Calendar",

      "action": {

        "title": "Go to services",

        "completed_title": "View",

        "type": "navigate",

        "navigate_to": "event_types",

        "content": "Text to copy"

      },

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z",

      "completed_at": "2019-08-24T14:15:22Z",

      "blocked": true

    }

  ],

  "total_tasks": 6,

  "completed_tasks": 4,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z",

  "completed_at": "2019-08-24T14:15:22Z",

  "goal_completion_acknowledged": true

}
```

Empty

Empty

Empty

Empty[List company goals GET](https://docs.noona.is/docs/hq/goals/ListGoalInstances)

[

Previous Page

](https://docs.noona.is/docs/hq/goals/ListGoalInstances)[

Update a task POST

Next Page

](https://docs.noona.is/docs/hq/goals/UpdateTask)