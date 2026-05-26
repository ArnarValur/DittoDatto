# Product Guide: DittoDatto.no

## Initial Concept

DittoDatto.no is a multi-agentic service booking platform designed to revolutionize how people find and book local services in Norway. The startup is based in Drammen, Norway. The platform aims to scale nationally, becoming the go-to solution for locals, tourists, and businesses alike.

## Vision

To be the premier service discovery and booking platform in Norway, leveraging advanced AI agents ("Ditto" for users, "Datto" for businesses) to simplify complex interactions. The platform seeks to empower marginal groups and tourists through accessible interfaces while providing powerful management tools for local businesses.

## Strategic Roadmap & Sprints

### Sprint 1: Core Administration & Business Portal (Inventory & Data)

**Goal:** Deliver a functional Business Portal and finalize the Admin Panel to support basic company operations. "No User left behind, no Company unassigned."

- **Admin Panel:** Fix RBAC (User CRUD), implement `admin_createCompany` Cloud Function, and "MercuryEngine Playground" for testing flows.
- **Business Portal:** Implement `create-store`, `create-service`, and `create-staff` logic.
  - **Deliverable:** A Business Owner can log in, create a Store (e.g., "Viking Barbers"), add a Service ("Haircut"), and add Staff ("Sarah").

### Sprint 2: The Engine (Availability & AI Brain)

**Goal:** Implement the "Time Tetris" algorithm and Vector Search.

- **Availability Engine:** Implement `AvailabilityCalculator`, parallel data fetching (Open Hours, Bookings, Holds), and the `availability.getSlots` endpoint.
- **Concurrency:** Implement `create-hold` using Firestore Atomic Transactions (The "Lock").
- **AI Foundation:** Configure "Vector Search with Firestore" extension and implement `search.semantic` for natural language discovery.

### Sprint 3: The Market (Consumer Experience & Payments)

**Goal:** Let users find, book, and pay.

- **Public Marketplace:** Connect the frontend to `search.semantic` and `availability.getSlots`.
- **Booking Flow:** Build the "Slot Picker" UI and "Hold" action.
- **Payments:** Integrate Vipps MobilePay (`payments.initiateVipps` & `payments.vippsCallback`).
  - **Logic:** Convert "Hold ID" to "Order ID" for idempotency.
- **Deliverable:** A user can search "Beard", click a result, pick a time, pay with Vipps, and see a confirmed booking.

### Sprint 4: The Polish (Notification & Persistence)

**Goal:** Production readiness and self-healing.

- **Confirmation:** Async triggers for Email/SMS receipts.
- **Persistence:** Stream bookings to BigQuery for analytics.
- **Safety Net:** Implement Cron jobs (`scheduler.cleanExpiredHolds`, `scheduler.reconcilePayments`) to handle cleanup and zombie payments.

### Future Phase: Mobile Native (Flutter)

**Strategy:** "Steel Thread" MVP.

- **Focus:** A single, thin line of functionality (Open App -> Pick Slot -> Book -> Success) using Flutter & Riverpod.

## Deep Dive Features (Differentiation)

### 1. The "Time Tetris" Algorithm

- **Logic:** A robust availability calculation engine that handles recurrence, staff priorities, and resource allocation.
- **Key:** Maps "Minutes from Midnight" to solve the "Can I book?" question in <200ms.

### 2. AI "Brain" (Vector Search)

- **Problem:** Firestore strictly matches strings. "Fix messy beard" != "Beard Trim".
- **Solution:** Vector Embeddings via Vertex AI.
- **Flow:** Service Description -> Embedding -> `_embedding` Vector -> Cosine Similarity Search.

### 3. "Fort Knox" Security

- **Model:** Multi-tenancy in a single database.
- **Implementation:** Strict Firestore Security Rules and RBAC via Custom Claims to ensure total data isolation between tenants.

## Target Audience

1.  **Service Businesses:** From salons to clinics, starting in Drammen.
2.  **Marginal Groups & Tourists:** Users benefiting from accessible, multi-language agentic interfaces.
3.  **Norwegian General Public:** Locals seeking a modern, efficient booking experience.
