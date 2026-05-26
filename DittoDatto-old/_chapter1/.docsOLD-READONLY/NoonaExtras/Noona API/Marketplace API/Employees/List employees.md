---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Employees](https://docs.noona.is/docs/marketplace/employees)

Lists employees at a given company.

```
curl -X GET "https://api.noona.is/v1/marketplace/companies/aw7da9wd8ua28a821/employees"
```

```
[

  {

    "id": "7dj29KiAE1wdjw731",

    "profile": {

      "name": "Joe the cutter",

      "description": "Joe is the cutter of many hairs",

      "image": {

        "thumb": "https://placekitten.com/200/200",

        "image": "https://placekitten.com/200/300",

        "type": "thumbnail",

        "public_id": "https://placekitten.com/200/300"

      }

    },

    "marketplace": true,

    "event_type_preferences": [

      {

        "id": "dw7aw7da6w8d76aw",

        "can_perform": true,

        "custom_duration": 30,

        "custom_duration_before_pause": 15,

        "custom_duration_pause": 30,

        "custom_duration_after_pause": 15

      }

    ],

    "exclude_from_randomization_pool": true,

    "bookable": "bookable",

    "verification": {

      "verification_status": "pending",

      "certification_title": "Verified master",

      "certification_description": "This staff member is a master hairdresser",

      "badge_title": "Verified master",

      "certification_level": "apprentice",

      "color": "grey",

      "certification_type": "cosmetology",

      "approved_at": "2019-08-24T14:15:22Z"

    },

    "deleted_at": "2019-08-24T14:15:22Z"

  }

]
```[Get employee GET](https://docs.noona.is/docs/marketplace/employees/GetEmployee)

[

Previous Page

](https://docs.noona.is/docs/marketplace/employees/GetEmployee)[

Search employees GET

Next Page

](https://docs.noona.is/docs/marketplace/employees/SearchEmployees)