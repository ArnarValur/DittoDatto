---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Goals](https://docs.noona.is/docs/hq/goals)

Lists all goal instances for a company. Each goal includes its tasks. Use the filter parameter to retrieve only active goals.

GET `/v1/hq/companies/{company_id}/goals`

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

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/goals"
```

```
[

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

]
```

Empty

Empty

Empty

Empty[Set a goal as active POST](https://docs.noona.is/docs/hq/goals/ActivateGoal)

[

Previous Page

](https://docs.noona.is/docs/hq/goals/ActivateGoal)[

Update a goal POST

Next Page

](https://docs.noona.is/docs/hq/goals/UpdateGoal)