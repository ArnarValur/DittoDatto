---
tag: "noona.is"
---
Working with the APIs

---

The **behavior** query parameter is used to control what happens when a mutation takes place.

It accepts a JSON object that is specific to each resource type being mutated. An example for **update event** in the HQ API:

```
{

  "notify": true,

  "type": "single"

}
```

This behavior specifies that only this event of a recurring event series should be modified, and that the customer should be notified about it.