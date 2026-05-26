---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq)

Rule sets are used to define the behavior of the system. Multiple rules of the same type can be active at the same time within a single rule set, but but can not overlap.

Multiple rule sets can be active at the same time, in that case the rules take priority according to the overlapping rules chapter below.

**List of rules**

- `availability`
	Specifies when company is open or closed for business. By default a business is closed. Can be tied to specific employees and resources.
- `online_bookings`
	Specifies when company accepts online bookings. Can be tied to specific entities.
- `max_total_pax`
	Specifies the maximum number of people that can be booked at the same time.

**Overlapping rules**

If 2 or more rule sets are active during the same period, the comparison is done in the following order:

1. The rule set with fewer instances (according to the RRule, or the lack of one) takes priority.
2. If the rule sets have the same number of instances, the rule set with the shorter time period takes priority. (The time period is defined by the starts\_at and ends\_at of the rule set.)
3. If the rule sets have the same number of instances and the same time period, the rule set that was most recently updated takes priority.

The `priority` attribute can be used to override the default priority.

Rules with a priority set will always take precedence over rules without a priority set.

Lower priority values take precedence over higher priority values.

**Associated Entities**

Rules can be divided into two categories:

1. General rules
2. Rules tied to certain entities

Entities:

- Event Types
- Resources
- Employees

When a rule is tied to entities, it will only affect the entities it is tied to. This is achieved through the following attributes, using resources as an example:

- `resources` - A list of resource IDs.
- `association` - The association type. Can be either `include` or `exclude`.

**Examples**

---

```
\{

  resources: ["id-1", "id-2"],

  association: "includes",

\}
```

This rule is only applicable to resources with the IDs `id-1` and `id-2`.

---

```
\{

  resources: ["id-1", "id-2"],

  association: "excludes",

\}
```

This rule is applicable to all resources except those with the IDs `id-1` and `id-2`.

---

```
\{

  resources: [],

  association: "excludes",

\}
```

This rule is applicable to all resources.

---

**Interval**

The interval of a rule set is defined by the `starts_at` and `ends_at` attributes.

By default, rules in a set are active in that interval but each rule can overwrite the starts\_at and ends\_at attributes to define a custom interval.

A rule can however not extend beyond the interval of the rule set.[Update a rule set template POST](https://docs.noona.is/docs/hq/rule-set-templates/UpdateRuleSetTemplate)

[

Previous Page

](https://docs.noona.is/docs/hq/rule-set-templates/UpdateRuleSetTemplate)[

Create a rule set POST

Next Page

](https://docs.noona.is/docs/hq/rule-sets/CreateRuleSet)