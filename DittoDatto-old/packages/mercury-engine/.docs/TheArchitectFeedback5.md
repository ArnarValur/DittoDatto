> Holds as top-level collection — Holds live in /holds/{holdId} (top-level Firestore). Bookings live in /companies/{companyId}/reservations/. Is this asymmetry a problem at scale, or fine since holds are ephemeral (10-min TTL)?

<details>
<summary>Thought (20s)</summary>

> **Evaluating the Request**
>
> Okay, I'm analyzing the user's latest query, focusing on how holds are structured within the `MercuryEngine` booking system, specifically their top-level collection status. I'm noting the path provided for live holds, `/holds/{holdId}`. This structure is a key architectural point. I must provide the best answer possible!
>
> **Assessing Hold Asymmetry**
>
> I'm now diving into the codebase to clarify the asymmetry in data storage. I'm noting the `holdRef` in `hold.ts` confirms top-level collection [1], and the `bookingRef` also suggests top-level booking in `/bookings/{bookingId}` [1]. However, I also found reservations are structured under `/companies/{companyId}/reservations` [1], which is inconsistent. I'm evaluating if this impacts scalability, especially given holds' short TTL.
>
> **Analyzing Hold Efficiency**
>
> I'm now focusing on architectural trade-offs, specifically top-level collections versus subcollections within Firestore. I've been reviewing why the `MercuryEngine` opts for a top-level structure for `holds`. Expired holds need global cleanup, and a simple top-level query in `cleanup.ts` is much cleaner than a Collection Group query. I also note that the composite ID prevents any potential hotspots. The ephemeral nature of holds clearly influences this design.
>
> **Justifying Data Organization**
>
> I'm now clarifying the rationale for inconsistent structure. The distributed `storeId` avoids lexicographical grouping issues, which is great at this scale. Reservations' long-term nature and tenant specificity make subcollections, like `/companies/{companyId}/reservations/`, a secure and sensible approach for data isolation. Security rules become much simpler. It's a key NoSQL strategy.
>
> **Justifying Architecture Decisions**
>
> I'm now formulating a comprehensive response. I'm focusing on acknowledging the observed asymmetry between holds and reservations. I must clearly articulate that this isn't a performance issue, but a deliberate NoSQL design choice. I'll explain the ephemeral nature of holds, necessitating a top-level structure for easy global cleanup via a simple query. Conversely, I'll explain that the long-lived and tenant-specific nature of reservations makes subcollections ideal for natural multi-tenancy and data isolation, which are great features! I'll also clarify that Firestore handles scaling automatically, so top-level versus subcollections is irrelevant.

</details>This is an excellent observation. In relational databases, this kind of asymmetry would be a red flag. However, in NoSQL databases like Firestore, **this asymmetry is not a problem at scale—in fact, it is a highly optimized, query-driven design choice.**

Here is the architectural reasoning behind why mixing top-level collections for ephemeral data and subcollections for persistent data is perfectly fine, and actually beneficial for your specific use case.

### 1. Why Top-Level Works Best for Holds

In NoSQL, you structure your data based on how you intend to query it. Holds have two primary access patterns in your system:

1.  **Point Reads/Writes:** In `hold.ts`, you read and write a specific hold using a highly deterministic composite ID (`${storeId}_${date}_${slotTime}_${differentiator}`) [1]. Firestore can look up a top-level document by its ID in exactly the same O(1) time complexity as a subcollection document.
2.  **Global Cleanup (The Deciding Factor):** Because holds have a 10-minute TTL, you have a cron job in `src/routes/cleanup.ts` that queries `db.collection('holds').where('expiresAt', '<=', now)` [1].
    - If holds were stored in subcollections (e.g., `/companies/{id}/holds`), your cleanup job would have to use a Firestore **Collection Group Query**. While Collection Group queries are powerful, they require specific composite indexes and scan across all tenants.
    - By keeping holds in a single top-level collection, your cleanup job is a simple, highly efficient, single-collection query [1].

### 2. Why Subcollections Work Best for Reservations

Reservations, on the other hand, are long-lived, tenant-specific data. In `src/core/reservations/booking.ts`, you store them under `/companies/{companyId}/reservations` [1].

- **Multi-tenant Isolation:** This provides natural data isolation. A store manager querying their reservations will only ever query their specific subcollection. It makes it virtually impossible to accidentally leak another company's reservations.
- **Security Rules:** When you eventually write client-side Firebase Security Rules, it is much easier to secure tenant data when it is hierarchically nested under the tenant's `companyId`.

### 3. The Scale Implication

Firestore's performance scales based on the size of your _result set_, not the size of the collection. Querying 10 holds out of a top-level collection of 10 million performs exactly the same as querying 10 holds out of a subcollection of 100.

**The only minor caveat to watch out for:**
In `src/core/shared/data.ts`, when you calculate availability, you query the top-level holds collection using:
`db.collection("holds").where("storeId", "==", storeId).where("date", "==", date)` [1].

Because this is a top-level collection containing holds for _all_ stores, you must ensure you have a **Composite Index** created in Firestore for `storeId` (ASC) and `date` (ASC) on the `holds` collection. Without this index, the query will eventually slow down or fail as the global holds collection grows.

### Summary

Your design is architecturally sound. You are correctly applying **Query-Driven Data Modeling**. You optimized the ephemeral `holds` collection for global TTL cleanup [1], and you optimized the persistent `reservations` collection for multi-tenant isolation [1]. This asymmetry is exactly how NoSQL systems are meant to be designed.

Good luck with the Ticketing system build in April! You have a very solid foundation to build upon. Let me know if you and your partner need anything else in the future.
