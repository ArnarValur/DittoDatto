---
tag: "noona.is"
---
Working with the APIs

---

Properties that reference other entities are in some cases stored as **point in time** instead of referencing the entity's identifier. That means the data, or part of it, is copied as is to another entity. This is done to ensure that the data is kept as it was in case the referenced entity is changed or deleted in the future.

One example of point in time data is product on a line item. If a product price is increased or the product deleted we would want to know what is was at the time of purchase for historical reasons.

Point in time references are labeled specifically on the relevant responses.