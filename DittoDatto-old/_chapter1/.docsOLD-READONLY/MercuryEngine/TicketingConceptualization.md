---
tag: "noona.is"
---

> [!NOTE] Arnar
> [https://youtu.be/fhdPyoO6aXI](TicketMaster System Design)
> 
> Can you please distill the Ticketing system that is being designed in this video? Give me the high-level spec doc that I could use to take it further into construction into my booking engine, I want to have a simple but pragmatic and production grade ticketing system for events on my platform.

---

Here is the distilled, high-level specification document based on the system design breakdown in the video. You can use this blueprint to start construction on your booking engine, Arnar.

### 1\. System Overview

A microservices-based ticketing backend designed to handle read-heavy traffic (searching and viewing events) while ensuring strict consistency for write-heavy, highly concurrent operations (reserving and buying seats).

### 2\. Core Requirements

**Functional:**

- **Search Events:** By keyword, location, type, and date \[[13:00](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=780)\].
- **View Event:** See venue details, performer, and an up-to-date seat map \[[12:04](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=724)\].
- **Book Tickets (Two-Phase):** Users select a seat, reserve it for a 10-minute window, and then securely confirm payment \[[14:29](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=869)\].

**Non-Functional:**

- **High Availability:** For searching and viewing events (stale data is temporarily acceptable here) \[[06:25](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=385)\].
- **Strong Consistency:** For ticket booking to guarantee zero double-booking \[[05:30](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=330)\].
- **Surge Scalability:** The system must survive massive, instantaneous traffic spikes for highly popular events \[[07:58](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=478)\].

### 3\. Core Data Entities

A relational database like **PostgreSQL** is recommended to leverage ACID properties for ticket transactions \[[21:44](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=1304)\].

- **Event:** `ID`, `VenueID`, `PerformerID`, `Name`, `Description`, `Date`
- **Venue:** `ID`, `Location`, `SeatMapLayout`
- **Performer:** `ID`, `Name`
- **Ticket:** `ID`, `EventID`, `SeatLocation`, `Price`, `Status` (Available, Booked), `UserID` (if booked)

*(Note: "Reserved" is intentionally kept out of the core database to avoid stale locks—see Section 6).*

### 4\. API Specifications

- **`GET /event/{event_id}`**: Retrieves event metadata, venue, performer, and the list of available tickets \[[12:09](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=729)\].
- **`GET /search`**: Accepts query params (e.g., `term`, `location`, `date`) and returns a partial list of matching events \[[12:58](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=778)\].
- **`POST /booking/reserve`**: Accepts `ticket_id`. Reserves the seat for a 10-minute countdown \[[15:36](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=936)\]. User identity is handled via auth headers/JWT.
- **`POST /booking/confirm`**: Accepts `ticket_id` and payment intent details to finalize the purchase \[[16:46](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=1006)\].

### 5\. High-Level Architecture

1. **API Gateway:** Handles incoming requests, routes to microservices, and manages authentication and rate limiting \[[18:28](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=1108)\].
2. **Event CRUD Service:** Handles the `GET /event` queries. It reads from Postgres but relies heavily on caching (e.g., Redis or a CDN) for event metadata, as venue and performer details rarely change \[[56:14](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=3374)\].
3. **Search Service:** Offloads search queries to an **Elasticsearch** cluster to prevent slow, full-table database scans \[[37:28](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=2248)\]. Elasticsearch is kept in sync with Postgres either via application-level dual-writes or a Change Data Capture (CDC) stream \[[40:57](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=2457)\].
4. **Booking Service:** Handles the transactional logic of reserving and purchasing tickets, integrating with a third-party payment processor like Stripe via webhooks \[[26:58](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=1618)\].

### 6\. Pragmatic Construction Decisions (The "Secret Sauce")

To make this production-grade without overcomplicating the initial build, the video highlights a few critical design patterns:

- **The 10-Minute Reservation Lock:** Instead of saving a "Reserved" status in Postgres and using a clunky cron job to release expired tickets, use a **Redis Distributed Lock** \[[31:15](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=1875)\]. When a user reserves a ticket, set a key (`ticket_id: true`) in Redis with a Time-To-Live (TTL) of 10 minutes \[[31:44](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=1904)\]. If they successfully pay, update the Postgres status to "Booked". If they don't, the Redis key simply evaporates, and the ticket is instantly available again \[[32:58](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=1978)\].
- **Real-Time Seat Maps via SSE:** To prevent users from constantly trying to click seats that were just taken, establish a **Server-Sent Events (SSE)** connection \[[49:35](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=2975)\]. This allows your server to push unidirectional updates to the client whenever a seat is locked or booked, keeping the UI instantly in sync.
- **Surge Protection (Virtual Waiting Queue):** For major events, direct database access will crash the system. Implement a choke point using a Virtual Waiting Queue (backed by a Redis Sorted Set) \[[51:26](http://www.youtube.com/watch?v=fhdPyoO6aXI&t=3086)\]. Users are placed in the queue and slowly let into the booking flow in controlled batches, ensuring the backend only processes the volume it can safely handle.

Since you're taking this into construction for your booking engine, I can generate a weekly project checklist to help you manage the build-out. Would you like me to schedule that?

---

> [!NOTE] Arnar
> Take a look at src-bundle, its my latest version of my booking engine:) How would you on a high-level integrate such ticketing system scaled down so I can start conceptualizing basic, simple yet pragmatic ticketing system?

---

Hey Arnar! It is great to see the inner workings of MercuryEngine. You already have a solid foundation with Hono, Firebase, and your existing domain split. I see you even have the placeholder routes ready to go in `src/routes/ticketing.ts`!

To keep things straightforward and pragmatic for your specific needs, we are going to ignore the massive scale complexities from that Ticketmaster video (like Redis locks and Elasticsearch). You don't need those yet. We can build a highly effective, scaled-down version using the Firestore transaction patterns you already wrote for your 1:1 appointments.

Here is how we can conceptualize and integrate this into your current engine.

### 1\. The Scaled-Down Data Model (Firestore)

Instead of tracking every single seat like a stadium, start with "General Admission" or "Pool" capacity to keep it simple.

- **Events Collection (`companies/{companyId}/events`)**:
	- Contains `id`, `name`, `date`, `totalCapacity`, and `availableCapacity`.
- **Ticket Holds Collection (`holds`)**:
	- You already use this for appointments. We just add an `eventId` and `quantity` to it.
- **Tickets Collection (`companies/{companyId}/tickets`)**:
	- The final, confirmed ticket owned by a user. Contains `eventId`, `userId`, `status: 'valid'`, and maybe a QR code string.

### 2\. Phase 1: The 10-Minute Hold (Reusing Your Logic)

In the video, they used a Redis Distributed Lock. You don't need that. You already have a brilliant, simple mechanism: your `DELETE /cleanup/holds/expired` cron job route.

When a user wants to buy a ticket, you will wire up your `POST /tickets/holds` route:

1. Run a Firestore transaction to check if `Event.availableCapacity >= requestedQuantity`.
2. If yes, decrement `Event.availableCapacity` by the quantity.
3. Create a document in your `holds` collection with an `expiresAt` set to 10 minutes from now.

If the user closes their laptop and doesn't pay, your existing cleanup route will eventually sweep up that expired hold. *Crucial addition:* When your cleanup script deletes an expired ticketing hold, it must also add the capacity back to the `Event` document!

### 3\. Phase 2: Confirming the Purchase

When Stripe (or your payment provider) says the payment was successful, you will wire up your `POST /tickets/purchase` route:

1. Run a Firestore transaction to read the hold document.
2. If the hold exists and isn't expired, generate the actual `Ticket` documents for the user.
3. Delete the hold document. (Because you already subtracted the capacity during the hold phase, you don't need to touch the `Event` document here).

### 4\. Phase 3: Verification (The Door Scanner)

You have a placeholder for `POST /tickets/verify`. For a pragmatic V1, simply have the client app pass the `ticketId`. The server looks up the ticket in Firestore:

- If `status === 'valid'`, update it to `status === 'scanned'` and return success.
- If `status === 'scanned'`, return an error (preventing double entry).

### Where to Start Coding

Since you like to keep things structured, here is your immediate strike plan for the MercuryEngine codebase:

1. **Define the Types:** Add `Event` and `Ticket` interfaces to your `@dittodatto/shared-types` package.
2. **Flesh out `src/core/tickets/index.ts`:** Remove the comments and write your `createTicketHold` and `confirmTicketPurchase` functions, mimicking the exact transaction style you used in `createBookingFromHold`.
3. **Update `src/routes/cleanup.ts`:** Modify your expired holds logic so that if a hold has an `eventId`, it safely returns the capacity to the event before deleting the hold.