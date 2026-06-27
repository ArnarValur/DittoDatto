# Communication & Notification Architecture Research

> Research conducted June 2026.
> Purpose: Inform DittoDatto's communication infrastructure across three channels — B2C messaging, platform feedback, and future agent-to-agent communication.

---

## 1. TL;DR

Start with SurrealDB-native messaging using the existing `message_thread` and `message` tables, powered by `LIVE SELECT` over WebSockets. This covers real-time B2C chat and platform feedback for your first 100+ companies with zero additional infrastructure. Add Sveve for SMS booking reminders and MailerSend for transactional emails when you need external notifications. Keep agent-to-agent communication on the same `message` table but with `sender_type: 'ditto' | 'datto'` — the Google A2A protocol is your escape hatch when agents need to talk across platform boundaries, but internally your DB *is* the message bus. Don't buy Kafka, don't deploy RabbitMQ, don't build a notification microservice. Your database already does what most startups spend months wiring up.

---

## 2. Industry Primer — Messaging Infrastructure for Founders

Think of messaging infrastructure like plumbing. Different pipes for different jobs. Here's what each technology actually does, explained without the jargon fog.

### 2.1 Message Queues (RabbitMQ, Amazon SQS)

**What it is:** A to-do list for computers. One system puts a task on the list, another picks it up and does it. Once done, the task is removed.

**Analogy:** A restaurant kitchen ticket rail. The waiter clips an order, one cook grabs it, prepares the food, removes the ticket. No two cooks grab the same ticket.

**When you need it:** When a task must happen reliably but doesn't need to happen *right now*. "Send a booking confirmation email" — the user doesn't need to wait for the email to be sent before seeing "Booking confirmed!"

**When it's overkill for DittoDatto:** Right now. SurrealDB `DEFINE EVENT` with `ASYNC` gives you the same "do this later" pattern without deploying a separate message broker. You have maybe 5 companies. You don't need RabbitMQ until you're processing thousands of background tasks per minute.

**Scale:** Designed for tens of thousands of messages/second. You're at maybe 10/hour.

### 2.2 Event Streaming (Apache Kafka, Amazon Kinesis)

**What it is:** A permanent diary of everything that happens. Unlike a queue (where tasks are deleted after processing), a stream keeps every event forever (or for a configured period). Any service can "rewind" and re-read history.

**Analogy:** A security camera recording. You can review footage from last Tuesday, or watch live. Multiple people can watch different parts independently.

**When you need it:** When you need event replay (fixing a bug and reprocessing old data), complex analytics pipelines, or coordination across dozens of microservices.

**When it's overkill for DittoDatto:** Absolutely right now, and probably for the next 2-3 years. Kafka requires dedicated infrastructure, operational expertise, and introduces complexity that's designed for Netflix-scale problems. You have one database, one booking engine, and three Flutter apps.

**Scale:** Designed for millions of events/second across distributed clusters.

### 2.3 Pub/Sub (Redis Pub/Sub, Google Cloud Pub/Sub)

**What it is:** A broadcast system. One publisher announces "a booking was created" and every interested subscriber gets a copy of that announcement simultaneously.

**Analogy:** A school PA system. The principal makes an announcement once, and every classroom hears it at the same time.

**When you need it:** When one event needs to trigger multiple independent reactions. "Booking created" → update the calendar AND send a confirmation AND update analytics AND notify the staff member.

**When it's relevant for DittoDatto:** This is actually the pattern you'll eventually want for notifications, but SurrealDB `DEFINE EVENT` already gives you a lightweight version of this. The event fires on booking creation and can trigger multiple side effects. Google Cloud Pub/Sub becomes relevant when you need guaranteed delivery across multiple independent services (e.g., a separate analytics service, a separate notification service).

**Scale:** Google Cloud Pub/Sub handles millions of messages/second. Redis Pub/Sub is simpler but doesn't persist messages — if a subscriber is offline, the message is lost.

### 2.4 WebSockets (What SurrealDB LIVE SELECT Uses)

**What it is:** A persistent, two-way connection between client and server. Unlike HTTP (where the client asks and the server responds), WebSockets keep the line open. Either side can send data at any time.

**Analogy:** A phone call. Once connected, either person can talk at any time without hanging up and redialing.

**When you need it:** Real-time UIs — chat messages appearing instantly, booking calendars updating when a colleague books a slot, live typing indicators.

**DittoDatto relevance:** This is your bread and butter. Your entire Business Portal runs on WebSocket connections to SurrealDB (ADR-0010, ADR-0011). `LIVE SELECT` is WebSocket-based. Chat, booking updates, staff schedule changes — all real-time via WebSocket. You're already using this.

**Scale:** Thousands of concurrent connections per SurrealDB instance. Single-node for now, but sufficient for hundreds of companies.

### 2.5 Server-Sent Events (SSE)

**What it is:** A one-way stream from server to client over HTTP. The server pushes updates; the client just listens.

**Analogy:** A radio broadcast. You tune in and listen, but you can't talk back through the radio.

**When you need it:** When you only need server→client updates (no client→server), like a live feed of notifications or a progress bar for a long-running task.

**DittoDatto relevance:** Interesting for one specific case — the Google A2A protocol uses SSE for streaming task updates. For your own surfaces, WebSockets (via SurrealDB) are more capable since they're bidirectional. SSE would only matter if you expose an A2A-compatible agent endpoint.

### 2.6 Webhooks

**What it is:** An HTTP callback. When something happens in System A, it sends an HTTP POST to System B's URL with the event data.

**Analogy:** "Call me when my table is ready." You give the restaurant your phone number, and they call you when it's time.

**When you need it:** Integrations with external services. Payment provider (Vipps) notifying you that a payment succeeded. SMS provider confirming message delivery. Third-party calendar syncs.

**DittoDatto relevance:** You'll use webhooks *inbound* (receiving callbacks from Vipps, Sveve delivery reports) rather than *outbound*. SurrealDB `DEFINE EVENT` with `http::post()` can send outbound webhooks if needed, but that's a Phase 2+ concern.

### 2.7 Actor Model (Erlang/Akka)

**What it is:** A programming pattern where independent "actors" (lightweight processes) communicate by sending messages to each other. Each actor has its own state and mailbox. No shared memory, no locks.

**Analogy:** A company where every employee has their own office and inbox. They never share a desk — they send memos to each other.

**When you need it:** Massively concurrent systems where thousands of independent entities need to operate simultaneously without stepping on each other's toes. Chat systems (each conversation is an actor), IoT (each device is an actor), game servers (each player is an actor).

**DittoDatto relevance:** This is conceptually interesting for your Ditto/Datto agents — each agent *could* be modeled as an actor with its own mailbox. But Google ADK already handles agent orchestration, so you don't need to build an actor system from scratch. The pattern is worth understanding for the A2A question (Section 5).

---

## 3. What SurrealDB Already Gives You

This is the good news section. SurrealDB 3.1 is not just a database — it's a database with built-in real-time infrastructure. Here's what you already have without adding any external service.

### 3.1 LIVE SELECT — Real-Time Subscriptions

**What it does:** Subscribe to changes on any table with filtering. The database pushes CREATE, UPDATE, and DELETE events to connected clients via WebSocket.

**Your existing use:** The Business Portal already uses `LIVE SELECT` for appointments, staff schedules, and booking streams (ADR-0010). This is proven infrastructure.

**For messaging:** `LIVE SELECT * FROM message WHERE thread = $thread_id` gives you real-time chat. When a customer sends a message in the Marketplace app, the BP staff member's inbox updates instantly. No polling, no message broker.

**Performance notes:**
- Single-digit millisecond latency (Rust-native)
- Use `LIVE SELECT DIFF` for large records to reduce payload size
- Single-node optimized (fine for your scale — hundreds of companies, not millions)
- Each `LIVE SELECT` is scoped to the current database context — important for your multi-tenant model

### 3.2 DEFINE EVENT — Server-Side Triggers

**What it does:** Execute custom logic when a table changes. Like database triggers, but more powerful — can create records in other tables, call external HTTP APIs, and run conditionally.

**For messaging:**
```sql
-- When a new message is created, update the thread's updated_at
DEFINE EVENT message_created ON TABLE message
WHEN $event = "CREATE"
THEN (
    UPDATE $after.thread SET updated_at = time::now()
);

-- When a booking is created, schedule a reminder (async, non-blocking)
DEFINE EVENT booking_reminder ON TABLE booking
ASYNC
WHEN $event = "CREATE"
THEN (
    CREATE notification_schedule SET
        booking = $after.id,
        channel = 'sms',
        send_at = $after.start_time - 24h,
        status = 'pending'
);
```

**Key capability:** The `ASYNC` keyword means the event runs outside the original transaction. Perfect for side effects that shouldn't block the main operation (sending notifications, updating counters, syncing to discovery).

**Limitation:** Events don't fire during bulk imports. Not a concern for messaging (messages arrive one at a time).

### 3.3 Graph Traversal for Message Routing

**What it does:** Your schema already models relationships as graph edges (`works_at`, `assigned_to`, `offers`). Messages naturally fit this pattern.

**For messaging:** The existing `message_thread` already links `establishment` and `customer`. To find all threads for a staff member:
```sql
SELECT <-works_at<-staff AS staff FROM establishment:xyz;
-- Then: SELECT * FROM message_thread WHERE establishment = establishment:xyz;
```

To find a customer's messages across all threads:
```sql
SELECT * FROM message_thread WHERE customer = customer:abc ORDER BY updated_at DESC;
```

### 3.4 Cross-Namespace Limitations (Critical Constraint)

**The rule (ADR-0002):** No cross-namespace queries. `companies/{slug}` cannot query `users/users` directly. Cross-DB references use string `user_id` fields resolved at the application layer.

**Impact on messaging:**
- B2C messages live in the company DB (`companies/company_{slug}`) — this is correct, the business owns the conversation context
- Consumer-side view (Marketplace app) must query messages via a separate connection to each relevant company DB, or via a shared namespace
- Platform feedback (User→DittoDatto) cannot live in a company DB — it needs a platform-level location

**This is the architectural fork that matters most.** See Section 4.

### 3.5 What SurrealDB Does NOT Give You

- **External delivery:** SurrealDB can't send SMS or email. You need an external provider for that.
- **Push notifications:** SurrealDB can't push to mobile devices (APNs/FCM). Requires Firebase Cloud Messaging or similar.
- **Offline message queueing:** If a client disconnects, `LIVE SELECT` events are lost. When they reconnect, they get current state (not missed events). This is fine for chat (just query recent messages on reconnect) but important to understand.
- **Cross-tenant message fanout:** If a platform announcement needs to reach all company DBs, you need application-layer fan-out (loop through companies and insert into each DB).
- **Rate limiting / throttling:** No built-in mechanism for preventing message spam. Application-layer concern.

---

## 4. Recommended Architecture — The Three Channels

### Channel 1: Business ↔ Customer (B2C)

**Where messages live:** In the company database (`companies/company_{slug}`), using the existing `message_thread` and `message` tables.

**Why:** The business owns the customer relationship. Messages are tenant-scoped data — booking confirmations, rescheduling requests, follow-ups are all about the business-customer relationship within that company's context. This matches your DB-per-company isolation model perfectly.

**Schema evolution (extend existing):**

```sql
-- Extend message_thread with unread tracking and last message preview
DEFINE FIELD unread_count     ON message_thread TYPE int DEFAULT 0;
DEFINE FIELD last_message     ON message_thread TYPE option<string>;  -- preview text
DEFINE FIELD last_message_at  ON message_thread TYPE option<datetime>;

-- Extend message with read receipts and message types
DEFINE FIELD read_at          ON message TYPE option<datetime>;
DEFINE FIELD message_type     ON message TYPE string DEFAULT 'text'
  ASSERT $value IN ['text', 'booking_confirmation', 'reminder', 'system', 'marketing'];
DEFINE FIELD metadata         ON message TYPE option<object> FLEXIBLE;  -- booking ref, etc.

-- Index for inbox queries
DEFINE INDEX idx_thread_establishment ON message_thread FIELDS establishment;
DEFINE INDEX idx_thread_customer ON message_thread FIELDS customer;
DEFINE INDEX idx_thread_updated ON message_thread FIELDS updated_at;
DEFINE INDEX idx_message_thread ON message FIELDS thread;

-- Auto-update thread when message is created
DEFINE EVENT on_message_created ON TABLE message
WHEN $event = "CREATE"
THEN {
    UPDATE $after.thread SET
        updated_at = time::now(),
        last_message = string::slice($after.body, 0, 100),
        last_message_at = time::now(),
        unread_count += 1;
};
```

**Real-time wiring:**
- **Business Portal (staff):** `LIVE SELECT * FROM message_thread WHERE establishment = $est_id ORDER BY updated_at DESC` — real-time inbox. Already on a WebSocket connection to the company DB (ADR-0010).
- **Marketplace (consumer):** Needs a connection to each company DB where they have threads. Two approaches:
  - **Option A (simple):** Consumer's Marketplace app connects to company DBs on-demand when opening a thread. Use the `user_id` string reference to find threads.
  - **Option B (better UX):** Store a lightweight `inbox_reference` in `users/users` that lists `{company_slug, thread_id, last_message_at}` — the Marketplace app queries this first, then connects to the relevant company DB for the full thread. Synced via `DEFINE EVENT` on the company side.

**Recommendation:** Start with Option A. It's simpler and works fine when a consumer has threads with 1-3 businesses. Switch to Option B when consumers start having 10+ active threads across many companies.

**External notification layer (Phase 2):**
```
[booking created] → DEFINE EVENT → notification_schedule table
    ↓
[MercuryEngine cron job] → reads pending notifications
    ↓
[Sveve API] → sends SMS reminder
[MailerSend API] → sends email confirmation
```

### Channel 2: Platform Feedback (User → DittoDatto)

**Where feedback lives:** In `companies/registry` — the platform-level database that already stores companies, system alerts, audit logs, and icon collections.

**Why NOT in company DBs:** Platform feedback is about DittoDatto itself, not about any specific company. A consumer complaint about a business, a bug report from a merchant, a feature request — these are platform concerns. Putting them in company DBs would scatter platform-level data across hundreds of tenant databases.

**Why NOT in `users/users`:** That namespace is GDPR-isolated PII. Feedback tickets involve operational data (screenshots, feature descriptions, bug details) that shouldn't be mixed with pure identity data.

**Schema proposal (new tables in `companies/registry`):**

```sql
-- Platform feedback / support ticket
DEFINE TABLE feedback SCHEMAFULL;
DEFINE FIELD subject          ON feedback TYPE string;
DEFINE FIELD body             ON feedback TYPE string;
DEFINE FIELD category         ON feedback TYPE string DEFAULT 'general'
  ASSERT $value IN ['bug', 'feature_request', 'complaint', 'support', 'general'];
DEFINE FIELD source_app       ON feedback TYPE string
  ASSERT $value IN ['business_portal', 'marketplace', 'admin_panel'];
DEFINE FIELD submitter_id     ON feedback TYPE string;  -- user_id string ref
DEFINE FIELD submitter_name   ON feedback TYPE string;  -- snapshot
DEFINE FIELD submitter_email  ON feedback TYPE string;  -- snapshot for reply
DEFINE FIELD company_slug     ON feedback TYPE option<string>;  -- if from BP, which company
DEFINE FIELD status           ON feedback TYPE string DEFAULT 'new'
  ASSERT $value IN ['new', 'acknowledged', 'in_progress', 'resolved', 'closed'];
DEFINE FIELD priority         ON feedback TYPE string DEFAULT 'normal'
  ASSERT $value IN ['low', 'normal', 'high', 'urgent'];
DEFINE FIELD assigned_to      ON feedback TYPE option<string>;  -- admin user
DEFINE FIELD attachments      ON feedback TYPE array<string> DEFAULT [];
DEFINE FIELD created_at       ON feedback TYPE datetime VALUE $value OR time::now();
DEFINE FIELD updated_at       ON feedback TYPE datetime VALUE time::now();

-- Feedback response (admin replies)
DEFINE TABLE feedback_response SCHEMAFULL;
DEFINE FIELD feedback         ON feedback_response TYPE record<feedback>;
DEFINE FIELD responder_id     ON feedback_response TYPE string;
DEFINE FIELD responder_name   ON feedback_response TYPE string;
DEFINE FIELD body             ON feedback_response TYPE string;
DEFINE FIELD is_internal      ON feedback_response TYPE bool DEFAULT false;  -- internal notes
DEFINE FIELD created_at       ON feedback_response TYPE datetime VALUE $value OR time::now();

DEFINE INDEX idx_feedback_status ON feedback FIELDS status;
DEFINE INDEX idx_feedback_source ON feedback FIELDS source_app;
DEFINE INDEX idx_feedback_created ON feedback FIELDS created_at;
```

**How it connects to existing Inbox screens:**
- **Admin Panel Inbox:** Already has a placeholder screen. Wire it to `LIVE SELECT * FROM feedback WHERE status != 'closed' ORDER BY created_at DESC` on the `companies/registry` DB. Admin sees all platform feedback, can assign, respond, close.
- **Business Portal Inbox:** Shows two sections: (1) B2C message threads from the company DB, and (2) "My feedback to DittoDatto" from `companies/registry` filtered by `company_slug`. BP users can submit feedback and see responses.
- **Marketplace:** Simple "Contact Us" / "Report" form that creates a `feedback` record in `companies/registry`.

**This is NOT the same as B2C messaging.** Business-customer chat is a conversation. Platform feedback is a ticket. Different data models, different lifecycle, different UI. Don't try to unify them.

### Channel 3: Agent-to-Agent (Ditto ↔ Datto) — Future

**See Section 5 for full analysis.** Summary: use the same `message` table with agent sender types, add a structured `metadata` field for machine-readable negotiation payloads.

---

## 5. The A2A Question — Can Humans and Agents Share the Same Pipe?

### The Short Answer

Yes, and this is not naive — it's exactly how Intercom, Zendesk, and every modern customer-communication platform works. The pattern is called **"bot-as-a-teammate"**: the agent is just another participant in the conversation, using the same thread, the same message format, and the same inbox.

### Why This Works

Your `message` table already has a `sender_type` field:
```sql
DEFINE FIELD sender_type ON message TYPE string
  ASSERT $value IN ['customer', 'staff', 'datto'];
```

This is the right design. `'datto'` is already there. Add `'ditto'` and `'system'`:
```sql
ASSERT $value IN ['customer', 'staff', 'datto', 'ditto', 'system'];
```

A conversation between a customer and a business might look like:
1. **customer:** "Hi, can I reschedule my 3pm Tuesday haircut?"
2. **datto (auto):** "Let me check available slots... I have 4pm Tuesday or 2pm Wednesday. Which works?"
3. **customer:** "4pm Tuesday please."
4. **datto (auto):** "Done! Your haircut is rescheduled to 4pm Tuesday. See you then! 💇"
5. **system:** "Booking #B123 rescheduled: 3pm → 4pm Tuesday" *(metadata message)*

If Datto can't handle it:
6. **datto (auto):** "I'm not sure about that — let me get a human to help."
7. **staff:** "Hi! I see you want to add a beard trim. Let me add that..."

This is the **switchboard pattern** used by Intercom (Fin AI Agent) and Zendesk (Sunshine Conversations). The bot and human are teammates in the same thread. The customer sees a seamless conversation.

### The Structured Metadata Layer

For agent-to-agent *negotiation* (Ditto asking Datto for availability), the messages need a machine-readable layer that humans don't see:

```sql
DEFINE FIELD metadata ON message TYPE option<object> FLEXIBLE;
-- Example metadata for an agent negotiation:
-- {
--   "intent": "check_availability",
--   "service_id": "service:haircut_30",
--   "preferred_times": ["2026-07-01T15:00", "2026-07-01T16:00"],
--   "a2a_task_id": "task_abc123",
--   "a2a_status": "running"
-- }
```

The `body` field carries the human-readable version ("Can I book a haircut at 3pm Tuesday?"). The `metadata` field carries the structured payload that agents parse. Same message, two audiences.

### How Google A2A Fits

The **Agent-to-Agent (A2A) protocol** (now under Linux Foundation governance, v1.0 stable as of April 2026) is designed for agents that need to communicate **across organizational boundaries**. It uses HTTP + SSE + JSON-RPC.

**For DittoDatto's internal Ditto↔Datto communication:** You don't need A2A. Both agents are yours. They share the same database. A2A is for when Ditto needs to talk to *someone else's* agent — like a third-party scheduling service, or when DittoDatto agents need to communicate with a Google Gemini agent or a Microsoft Copilot agent.

**Key A2A concepts that inform your design:**

| A2A Concept | DittoDatto Internal Equivalent |
|---|---|
| **Agent Card** (`.well-known/agent.json`) — advertises capabilities | Not needed internally. Datto's capabilities are defined by its ADK tools. Useful when you expose Datto externally. |
| **Task lifecycle** (created → running → completed/failed) | Model this in `metadata.a2a_status` on messages. Maps to your existing booking hold→booking lifecycle. |
| **Opaque delegation** (requesting agent doesn't see internal logic) | Ditto sends a request; Datto handles it using MercuryEngine + SurrealDB. Ditto doesn't care how. |

**When you need A2A proper:**
- When DittoDatto agents need to interoperate with other platforms' agents (e.g., a restaurant POS agent)
- When you want third-party agents (Gemini Extensions, GPT Actions) to book through DittoDatto
- The MercuryEngine API is already designed to be agent-callable. A2A Agent Cards would be a thin layer on top.

### Architecture Recommendation

```
Phase 1 (Now):     Same message table, sender_type distinguishes human/agent
Phase 2 (Datto):   Datto reads message metadata, uses ADK tools to process intents
Phase 3 (External): A2A Agent Cards on MercuryEngine for third-party agent access
```

**Bottom line:** Unified message bus for human + agent is the industry standard, not a hack. Your existing schema supports it with one field addition.

---

## 6. Norwegian Considerations

### 6.1 SMS Providers

| Provider | Origin | Best For | Price Range | GDPR |
|---|---|---|---|---|
| **Sveve** | Norway 🇳🇴 | SMEs, Norway-first, simple API | 0.41–0.90 NOK/SMS + 139 NOK/mo base + 150 NOK/mo API | Norwegian servers, full GDPR |
| **LINK Mobility** | Norway 🇳🇴 (Nordic enterprise) | High volume (10k+/mo), enterprise | 0.40–0.50 NOK/SMS (negotiated) | EU-compliant |
| **Twilio** | USA 🇺🇸 | Global reach, developer-first | ~0.50–0.70 NOK/SMS (varies) | CLOUD Act concerns |
| **GatewayAPI** | Denmark 🇩🇰 | Cost-competitive EU alternative | Competitive tiers | EU-based |

**Recommendation:** **Sveve** for launch. Norwegian company, Norwegian servers, transparent pricing, simple REST API. At your volume (maybe 100-500 SMS/month initially), the total cost is ~300-500 NOK/month. Switch to LINK Mobility only if you exceed 10,000 SMS/month.

**Integration point:** MercuryEngine (FastAPI) as the notification sender. `DEFINE EVENT` on booking creation writes to a `notification_schedule` table. A cron job in MercuryEngine reads pending notifications and calls the Sveve API.

### 6.2 Email Providers

| Provider | Origin | EU Data Residency | Price |
|---|---|---|---|
| **MailerSend** | Belgium 🇧🇪 | Yes (EU hosting) | Free tier: 3,000/mo |
| **Brevo** | France 🇫🇷 | Yes (EU-based) | Free tier: 300/day |
| **Mailgun** | US (EU region option) | EU region available | Pay-as-you-go |
| **Postmark** | US 🇺🇸 | No EU-only option | $15/mo for 10k |
| **Resend** | US 🇺🇸 | No EU-only option | Free tier: 3,000/mo |

**Recommendation:** **MailerSend** for launch. EU-headquartered (Belgium), EU data residency, generous free tier, good API, GDPR-native. Avoids US CLOUD Act concerns entirely.

**Why not Postmark/Resend?** Both are excellent technically but US-based. Under the US CLOUD Act, US companies can be compelled to disclose data to US authorities even if stored in EU data centers. For a Norwegian platform handling Norwegian PII, an EU-native provider is the defensible choice.

### 6.3 GDPR Message Retention

**Key rules (Datatilsynet / Personopplysningsloven):**
- **No fixed retention period** — GDPR doesn't say "delete after X days." You must define and justify your own retention policy.
- **Purpose limitation:** Keep messages only as long as they serve a purpose (active conversation, booking reference, dispute resolution).
- **Document your policy:** If Datatilsynet audits you, you must explain *why* you chose your retention periods.

**Recommended retention policy for DittoDatto:**

| Data Type | Retention | Justification |
|---|---|---|
| Active B2C message threads | Keep while booking relationship exists | Performance of service contract |
| Closed B2C threads | 12 months after last message | Dispute resolution window |
| Platform feedback tickets | Until resolved + 24 months | Product improvement, legal claims |
| SMS/email delivery logs | 6 months | Delivery verification |
| Booking confirmation messages | 5 years (with booking) | Norwegian Accounting Act (regnskapsloven) |

**Implementation:** Add a `retention_expires_at` field to `message_thread`. A periodic cleanup job (monthly) deletes/anonymizes expired threads. The booking's fiscal snapshot (already immutable per Norwegian law) is separate from the message thread.

### 6.4 Norwegian Consumer Communication Preferences

Based on market research:
- **SMS is king for time-sensitive operational messages** — booking confirmations, reminders (24h and 1h before), cancellation notices. Norwegians expect SMS for these.
- **Email for detailed information** — booking summaries with service details, receipts, follow-ups with links to rebook.
- **Push notifications** — "nice to have" but not expected. Many Norwegians aggressively manage notification permissions. In-app notifications are more reliable.
- **In-app messaging** — preferred for non-urgent back-and-forth (rescheduling requests, questions about a service).
- **Timing sweet spot for reminders:** 24 hours before + 1-2 hours before. Two reminders, not three.
- **Vipps integration** — Norwegians trust Vipps. If you can send booking confirmations via Vipps notifications in the future, that's a strong differentiator.

---

## 7. What NOT to Build (Yet)

### Definitely Overkill Right Now (< 100 companies)

| Technology | Why It's Premature | When to Revisit |
|---|---|---|
| **Apache Kafka / event streaming** | You have one database and three apps. Kafka is for coordinating dozens of microservices processing millions of events. | 1000+ companies with independent analytics, ML, and compliance pipelines |
| **RabbitMQ / dedicated message broker** | SurrealDB `DEFINE EVENT ASYNC` handles your background tasks. | When async task volume exceeds what DB events can handle (~10k+/min) |
| **Dedicated notification microservice** | A cron job in MercuryEngine reading a `notification_schedule` table is simpler and sufficient. | When notifications need complex routing (multi-channel, A/B testing, throttling) |
| **Push notification infrastructure (APNs/FCM)** | No mobile app in production yet. Add when Marketplace app launches on app stores. | App store launch |
| **Email marketing platform (Mailchimp, etc.)** | You don't have enough customers for marketing campaigns to matter. | 500+ bookings/month, customer segments worth targeting |
| **Custom chat protocol** | WebSocket + LIVE SELECT + message table = chat. Done. | Never (unless you need end-to-end encryption) |
| **Redis for real-time** | SurrealDB's LIVE SELECT already provides real-time subscriptions. Adding Redis adds operational complexity for zero benefit at your scale. | If you need ephemeral Pub/Sub for typing indicators at massive scale |

### Build This, But Later (100-1000 companies)

| Capability | When | How |
|---|---|---|
| **SMS reminders** | When you have paying businesses who want to reduce no-shows | Sveve API + `notification_schedule` table + MercuryEngine cron |
| **Email confirmations** | When booking flow is complete and tested | MailerSend API + booking `DEFINE EVENT` |
| **Push notifications** | When Marketplace app is on app stores | Firebase Cloud Messaging (FCM) — works from Cloud Run |
| **Consumer inbox aggregation** | When consumers have 10+ active threads across companies | `inbox_reference` table in `users/users` + sync events |

### Buy, Don't Build

| Capability | Buy From | Why Not Build |
|---|---|---|
| **SMS delivery** | Sveve | Carrier relationships, delivery optimization, number management |
| **Transactional email** | MailerSend | Deliverability reputation, SPF/DKIM, bounce handling |
| **Push notifications** | Firebase Cloud Messaging | Free, reliable, handles APNs+FCM, already in your GCP stack |
| **Customer identity** | BankID/Vipps | Norwegian legal requirement, you can't build identity verification |

---

## 8. Migration Path — v1 to v3 Without Rewrites

### v1: SurrealDB-Native (Now → First 100 Companies)

```
┌─────────────────────────────────────────────────────────────┐
│                     SurrealDB 3.1                           │
│                                                             │
│  companies/{slug}          companies/registry               │
│  ┌─────────────────┐       ┌──────────────────┐            │
│  │ message_thread   │       │ feedback          │            │
│  │ message          │       │ feedback_response  │            │
│  │                  │       │ system_alert       │            │
│  └────────┬─────────┘       └──────────┬────────┘            │
│           │ LIVE SELECT                │ LIVE SELECT          │
│           ▼                            ▼                     │
│  ┌─────────────┐              ┌──────────────┐              │
│  │ BP Inbox     │              │ Admin Inbox   │              │
│  │ (Flutter WS) │              │ (Flutter WS)  │              │
│  └─────────────┘              └──────────────┘              │
│                                                             │
│  Marketplace → connects to company DB for thread view       │
└─────────────────────────────────────────────────────────────┘
```

**What this gives you:** Real-time B2C chat, platform feedback, all within existing infrastructure. Zero new services to deploy.

### v2: External Notifications (100 → 500 Companies)

```
┌─────────────────────────────────────────────────────────────┐
│  SurrealDB 3.1 (same as v1)                                │
│                                                             │
│  DEFINE EVENT on booking → notification_schedule table       │
│                                                             │
└──────────────────────────┬──────────────────────────────────┘
                           │ cron reads pending
                           ▼
              ┌──────────────────────┐
              │   MercuryEngine       │
              │   (notification job)  │
              ├──────────┬───────────┤
              │          │           │
              ▼          ▼           ▼
         ┌────────┐ ┌────────┐ ┌─────┐
         │ Sveve  │ │Mailer  │ │ FCM │
         │ (SMS)  │ │Send    │ │     │
         └────────┘ └────────┘ └─────┘
```

**What changes:** MercuryEngine gains a notification scheduler. External providers handle delivery. The DB still owns the truth — `notification_schedule` tracks what was sent, when, and delivery status.

**No rewrites needed** — you're adding a cron job and API calls to MercuryEngine, not restructuring the database.

### v3: Agent Layer + A2A (500+ Companies, AI Launch)

```
┌─────────────────────────────────────────────────────────────┐
│  SurrealDB 3.1 (same schema, sender_type extended)          │
│                                                             │
│  message.sender_type IN ['customer','staff','datto','ditto']│
│  message.metadata = { intent, a2a_task_id, ... }            │
│                                                             │
└────────────────┬───────────────────────┬────────────────────┘
                 │                       │
    ┌────────────▼─────────┐  ┌─────────▼──────────────┐
    │  Datto (Business AI)  │  │  Ditto (Consumer AI)    │
    │  Google ADK            │  │  Google ADK              │
    │  Tools: MercuryEngine  │  │  Tools: MercuryEngine    │
    │  Reads message metadata│  │  Reads message metadata  │
    └──────────┬────────────┘  └──────────┬───────────────┘
               │                          │
               │   (internal: same DB)    │
               │◄─────────────────────────┘
               │
               │   (external: A2A protocol)
               ▼
    ┌──────────────────────────┐
    │  A2A Agent Cards          │
    │  on MercuryEngine         │
    │  /.well-known/agent.json  │
    │  HTTP + SSE + JSON-RPC    │
    └──────────────────────────┘
```

**What changes:** Agents read/write to the same message table with structured metadata. External agents connect via A2A endpoints on MercuryEngine. The core messaging infrastructure is unchanged.

**The key insight:** Every version uses the same `message_thread` + `message` tables. The upgrade path adds *senders* and *delivery channels*, not new messaging infrastructure.

---

## 9. Summary Decision Table

| Decision | Choice | Rationale |
|---|---|---|
| B2C message storage | Company DB (`companies/{slug}`) | Tenant-scoped, matches isolation model |
| Platform feedback storage | `companies/registry` | Platform-level concern, not tenant data |
| Real-time transport | SurrealDB LIVE SELECT (WebSocket) | Already proven in BP, zero added infra |
| SMS provider | Sveve (Phase 2) | Norwegian, GDPR-native, simple API |
| Email provider | MailerSend (Phase 2) | EU-based, free tier, GDPR-native |
| Push notifications | FCM (Phase 3) | Free, in GCP stack, standard |
| Message broker | None (DEFINE EVENT ASYNC) | DB events sufficient at current scale |
| Agent messaging | Same message table, extended sender_type | Industry standard (bot-as-teammate) |
| External agent protocol | Google A2A (Phase 3) | Standard, ADK-native, Linux Foundation |
| Message retention | Custom policy per type (6mo-5yr) | GDPR storage limitation principle |
