# SurrealDB as Message Bus — Deep Dive

> Research conducted June 2026.
> Purpose: Push SurrealDB 3.1 to its limits as DittoDatto's messaging backbone before considering external infrastructure.

---

## 1. Executive Summary

SurrealDB 3.1 can serve as a **complete message bus** for DittoDatto's current and near-future scale. Between LIVE SELECT (real-time push), DEFINE EVENT (server-side triggers), and Changefeeds (durable CDC), you get the three pillars of a messaging system without any external infrastructure:

| Pillar | SurrealDB Feature | What It Replaces |
|--------|------------------|-----------------|
| Real-time delivery | LIVE SELECT (WebSocket) | Redis Pub/Sub, Socket.io |
| Side-effect triggers | DEFINE EVENT (sync + ASYNC) | RabbitMQ, SQS task queues |
| Durable event replay | CHANGEFEED | Kafka, CDC pipelines |

**The boundary:** SurrealDB stops at the database edge. It cannot send SMS, email, or push notifications to external services reliably. For that, MercuryEngine acts as the bridge — consuming changefeeds and calling external APIs. But the message *truth* stays in SurrealDB.

---

## 2. LIVE SELECT — Real-Time Push

### Basic Syntax

```sql
-- Subscribe to new messages in a specific thread
LIVE SELECT * FROM message WHERE thread = message_thread:thread_001;

-- Subscribe to thread list updates for an establishment
LIVE SELECT * FROM message_thread WHERE establishment = establishment:salong_kroll;

-- Include related data in notifications
LIVE SELECT * FROM message FETCH thread;
```

Each `LIVE SELECT` returns a UUID. Kill it with `KILL $uuid;`.

### LIVE SELECT DIFF — Bandwidth Optimization

Instead of receiving the full record on every change, receive only JSON Patch (RFC 6902) deltas:

```sql
LIVE SELECT DIFF FROM message_thread WHERE establishment = establishment:salong_kroll;
```

**Payload example** (when `unread_count` increments):
```json
{
  "action": "UPDATE",
  "result": [
    { "op": "replace", "path": "/unread_count", "value": 3 },
    { "op": "replace", "path": "/last_message", "value": "Takk for bestillingen!" },
    { "op": "replace", "path": "/last_message_at", "value": "2026-06-27T15:00:00Z" }
  ]
}
```

Operations: `add`, `remove`, `replace`, `copy`, `move`, `test`. Huge savings for large records with frequent partial updates (like thread metadata).

### Graph Traversal in WHERE

YES — you can filter LIVE SELECT using graph operators:

```sql
-- Only threads where a specific staff member works at the establishment
LIVE SELECT * FROM message_thread
  WHERE <-works_at<-staff CONTAINS staff:lars_hansen;

-- Messages from a specific customer across all their threads
LIVE SELECT * FROM message WHERE thread.customer = customer:kari_nordmann;
```

**Caveat:** Complex traversals re-evaluate on every change to the table. Keep WHERE clauses simple and use indexed fields for performance.

### Reconnection Behavior

- **Missed events are NOT replayed.** On disconnect, the subscription is invalidated.
- On reconnect, re-issue the `LIVE SELECT` to get current state.
- **Gap handling pattern:**
  ```sql
  -- On reconnect, query what you missed
  SELECT * FROM message
    WHERE thread = $thread_id
      AND created_at > $last_seen_at
    ORDER BY created_at ASC;
  -- Then re-subscribe
  LIVE SELECT * FROM message WHERE thread = $thread_id;
  ```

### Multiple Subscriptions Per Connection

- YES — multiple concurrent LIVE SELECTs on a single WebSocket connection.
- No hard limit — resource-bound (memory/CPU per subscription on server).
- **Best practice:** Use specific WHERE filters with indexed fields. Never `LIVE SELECT * FROM message;` on an entire table.

---

## 3. DEFINE EVENT — Server-Side Triggers

### Synchronous vs ASYNC

```sql
-- SYNCHRONOUS (default): runs in same transaction
-- If event fails → original write rolls back
DEFINE EVENT validate_message ON TABLE message
  WHEN $event = "CREATE" AND string::len($after.body) = 0
  THEN {
    THROW "Message body cannot be empty";
  };

-- ASYNC: runs in separate background transaction
-- Original write commits regardless of event success/failure
DEFINE EVENT update_thread_preview ON TABLE message
  ASYNC
  WHEN $event = "CREATE"
  THEN {
    UPDATE $after.thread SET
      updated_at = time::now(),
      last_message = string::slice($after.body, 0, 100),
      last_message_at = time::now(),
      unread_count += 1;
  };
```

**Rule of thumb:**
- Synchronous → data integrity (validation, constraints)
- ASYNC → side effects (notifications, counters, external calls)

### http::post() in Events

```sql
DEFINE EVENT notify_mercury ON TABLE message
  ASYNC
  WHEN $event = "CREATE" AND $after.sender_type = "customer"
  THEN {
    http::post("https://mercury.dittodatto.no/hooks/new-message", {
      thread_id: $after.thread,
      sender_type: $after.sender_type,
      preview: string::slice($after.body, 0, 100)
    });
  };
```

**⚠️ No built-in retry.** If the HTTP call fails, the event is lost. For reliable external delivery, prefer writing to a `notification_schedule` table and having MercuryEngine poll/consume it.

### Event Chaining

Events CAN trigger other events. Creating a record in table X from Event A will fire events defined on table X.

```sql
-- Chain: message created → notification created → (notification event fires)
DEFINE EVENT on_message ON TABLE message ASYNC
  WHEN $event = "CREATE"
  THEN {
    CREATE notification SET
      type = 'new_message',
      thread = $after.thread,
      body = string::slice($after.body, 0, 100);
  };

-- This fires because the CREATE above triggers it
DEFINE EVENT on_notification ON TABLE notification ASYNC
  WHEN $event = "CREATE"
  THEN {
    UPDATE notification_count SET total += 1 WHERE user = $after.recipient;
  };
```

**MAXDEPTH controls recursion** (range 0–16, default 3):
```sql
DEFINE EVENT ... ASYNC MAXDEPTH 5 WHEN ... THEN ...;
```

Exceeding depth → transaction rollback + error. Be careful with exponential growth.

### $before and $after Context

| Variable | CREATE | UPDATE | DELETE |
|----------|--------|--------|--------|
| `$event` | "CREATE" | "UPDATE" | "DELETE" |
| `$before` | `{}` (empty) | Previous state | Full record |
| `$after` | New record | Updated record | `{}` (empty) |

### Conditional Field-Change Firing

```sql
DEFINE EVENT on_thread_closed ON TABLE message_thread
  WHEN $event = "UPDATE"
    AND $before.status != "closed"
    AND $after.status = "closed"
  THEN {
    CREATE notification SET
      type = 'thread_closed',
      thread = $after.id,
      customer = $after.customer;
  };
```

Only fires when `status` actually *changes* to "closed" — not on every update.

---

## 4. Changefeeds — Durable Event Replay (CDC)

### What They Are

Changefeeds are SurrealDB's Change Data Capture system — a durable, ordered log of all changes to a table, retained for a configurable period.

```sql
-- Enable on a table with 7-day retention
DEFINE TABLE message CHANGEFEED 7d;

-- Read changes since a timestamp
SHOW CHANGES FOR TABLE message SINCE d"2026-06-27T00:00:00Z" LIMIT 100;

-- Read changes since a versionstamp (cursor-based pagination)
SHOW CHANGES FOR TABLE message SINCE 1 LIMIT 100;
```

### Changefeeds vs LIVE SELECT

| Feature | LIVE SELECT | Changefeed |
|---------|-------------|------------|
| Delivery model | Push (WebSocket) | Pull (query) |
| Missed events | Lost on disconnect | **Retained** for configured duration |
| Ordering | Best-effort | **Strict, durable** |
| Best consumer | Client app (Flutter) | Backend service (MercuryEngine) |
| Use case | Real-time UI updates | Event replay, CDC, notification pipeline |
| Filters | WHERE clause | Post-query filtering |

### MercuryEngine as Changefeed Consumer

This is the key pattern for reliable cross-namespace messaging:

```
MercuryEngine (Python/FastAPI):
  1. Poll SHOW CHANGES FOR TABLE message SINCE $last_versionstamp LIMIT 100
  2. For each new message:
     a. If sender_type = 'customer' → send SMS/email confirmation
     b. If cross-namespace → write inbox_reference to users/users
     c. Update $last_versionstamp
  3. Sleep 2 seconds, repeat
```

**This replaces Kafka** for your scale. Changefeeds give you durable, ordered, replayable events. MercuryEngine gives you the processing logic. No Kafka cluster needed.

### Retention Configuration

```sql
DEFINE TABLE message CHANGEFEED 7d;   -- 7 days of history
DEFINE TABLE booking CHANGEFEED 30d;  -- 30 days (financial audit)
DEFINE TABLE feedback CHANGEFEED 90d; -- 90 days (support context)
```

Only changes within the retention window are available. After that, they're pruned.

---

## 5. Cross-Namespace Messaging

### The Constraint

ADR-0002: No cross-namespace queries. Company DB (`companies/company_{slug}`) cannot query `users/users`. Events cannot write to other databases.

### Recommended Pattern: Changefeed → MercuryEngine → Fan-Out

```
┌─────────────────────────────────────────────────────────┐
│  Company DB (companies/company_salong_kroll)            │
│                                                         │
│  message table ──CHANGEFEED 7d──┐                       │
│  message_thread                 │                       │
│  DEFINE EVENT (thread updates)  │                       │
│  LIVE SELECT ──→ BP Flutter     │                       │
└─────────────────────────────────┼───────────────────────┘
                                  │ SHOW CHANGES (poll)
                                  ▼
                    ┌──────────────────────┐
                    │   MercuryEngine       │
                    │   (changefeed reader) │
                    └──────┬───────┬───────┘
                           │       │
              ┌────────────▼┐  ┌───▼────────────────┐
              │ users/users  │  │ External APIs      │
              │ inbox_ref    │  │ Sveve, MailerSend   │
              └──────────────┘  └────────────────────┘
                     │
                     ▼
              ┌──────────────┐
              │ Marketplace   │
              │ (Flutter WS)  │
              │ LIVE SELECT   │
              │ on inbox_ref  │
              └──────────────┘
```

**Why this works:**
- Company DB stays isolated (ADR-0002 respected)
- MercuryEngine is the **only** cross-namespace bridge
- Changefeeds ensure no missed events (unlike http::post() which has no retry)
- Consumer gets near-real-time updates via LIVE SELECT on `inbox_reference` in `users/users`

**Latency:** 2-5 seconds for cross-namespace (polling interval). Acceptable for message notifications. Real-time within same company DB via LIVE SELECT (milliseconds).

---

## 6. Real-Time Inbox Aggregation

### The Problem

A consumer may have threads across multiple company databases. A single WebSocket connection is scoped to one namespace+database.

### Solutions by Scale

**1-5 companies (Phase 1):** Multiple WS connections. Consumer app opens one connection per company where they have active threads. Simple, direct, works.

**5-50 companies (Phase 2):** Inbox reference table in `users/users`:
```sql
-- In users/users namespace
DEFINE TABLE inbox_reference SCHEMAFULL;
DEFINE FIELD company_slug   ON inbox_reference TYPE string;
DEFINE FIELD thread_id      ON inbox_reference TYPE string;  -- serialized record ID
DEFINE FIELD last_message    ON inbox_reference TYPE option<string>;
DEFINE FIELD last_message_at ON inbox_reference TYPE option<datetime>;
DEFINE FIELD unread_count    ON inbox_reference TYPE int DEFAULT 0;
DEFINE FIELD updated_at      ON inbox_reference TYPE datetime VALUE time::now();

DEFINE INDEX idx_inbox_user ON inbox_reference FIELDS user_id;
DEFINE INDEX idx_inbox_updated ON inbox_reference FIELDS updated_at;
```

Consumer subscribes to ONE LIVE SELECT on `inbox_reference` filtered by their `user_id`. Gets a unified inbox view. Opens targeted company DB connections only when they tap into a thread.

**50+ companies (Phase 3 — far future):** Fan-in proxy in MercuryEngine with WebSocket forwarding. Not needed until you have power-users with dozens of active threads.

---

## 7. Message Ordering & Consistency

**LIVE SELECT ordering:** Best-effort, not strictly guaranteed globally. Concurrent writes from different clients may arrive out of order.

**For chat messages:** Not a problem. Messages are append-only. Sort by `created_at` on the client. Occasional out-of-order arrival is corrected by the sort.

**For thread metadata** (unread_count, last_message): Eventual consistency is fine. The thread will settle to correct state within milliseconds.

**No `version` field needed** for messages — they're immutable once created (no updates, no deletes in normal flow).

---

## 8. Permissions & Access Control

### RECORD ACCESS for Message Scoping

```sql
-- Customer access: sees only their own threads
DEFINE TABLE message_thread SCHEMAFULL
  PERMISSIONS
    FOR select WHERE customer = $auth.id
                  OR establishment IN $auth.store_ids
    FOR create WHERE customer = $auth.id
    FOR update NONE
    FOR delete NONE;

-- Message permissions: thread participants only
DEFINE TABLE message SCHEMAFULL
  PERMISSIONS
    FOR select WHERE thread.customer = $auth.id
                  OR thread.establishment IN $auth.store_ids
    FOR create WHERE
      (sender_type = 'customer' AND thread.customer = $auth.id)
      OR (sender_type = 'staff' AND thread.establishment IN $auth.store_ids)
    FOR update, delete NONE;
```

**How $auth works:**
- `$auth.id` = the record ID of the authenticated entity (customer, staff)
- `$auth.store_ids`, `$auth.email`, etc. = any field on the authenticated record
- PERMISSIONS are evaluated on **every query result row** — built-in row-level security

**Staff in BP:** Uses `bp_portal` service user with EDITOR role (ADR-0016). All staff see all threads for the company. Finer-grained per-establishment filtering can be added via `establishment IN $auth.assigned_establishments`.

**Agents (Datto/Ditto):** Use service accounts with appropriate roles. Datto uses BP service account context. Ditto would use a consumer-scoped access.

---

## 9. Limitations & Boundaries

### Where SurrealDB Stops

| Capability | SurrealDB Can | SurrealDB Cannot |
|------------|--------------|-------------------|
| Real-time in-app messaging | ✅ LIVE SELECT | |
| Message persistence | ✅ Tables | |
| Event-driven side effects | ✅ DEFINE EVENT | |
| Durable event replay | ✅ CHANGEFEED | |
| Row-level security | ✅ PERMISSIONS | |
| Send SMS | | ❌ Needs Sveve/Link |
| Send email | | ❌ Needs MailerSend |
| Push to mobile (APNs/FCM) | | ❌ Needs Firebase |
| Cross-namespace writes | | ❌ ADR-0002 |
| Guaranteed HTTP delivery | | ❌ No retry on http::post() |
| Rate limiting | | ❌ Application layer |
| Rich text / file attachments | | ❌ Store URLs, not files |

### The Golden Rule

> **SurrealDB is the truth. External services are delivery channels.** Messages are created, stored, queried, and subscribed to in SurrealDB. SMS/email providers just *copy* a message to an external channel. If Sveve goes down, the message still exists in SDB. If the email bounces, the message is still readable in-app.

---

## 10. Architecture Diagram — SurrealDB-Native Messaging

```
┌─────────────────────────────────────────────────────────────────┐
│                        SurrealDB 3.1                            │
│                                                                 │
│  ┌───────────────────────────────────────────────┐             │
│  │  companies/company_{slug}                     │             │
│  │                                               │             │
│  │  message_thread ──┐                           │             │
│  │  message ─────────┤  LIVE SELECT ──→ BP App   │             │
│  │                   │                           │             │
│  │  DEFINE EVENT ────┤  (thread updates,         │             │
│  │                   │   unread counts)           │             │
│  │  CHANGEFEED 7d ───┤                           │             │
│  │                   │  ──→ MercuryEngine polls   │             │
│  │  notification_    │                           │             │
│  │    schedule ──────┘  ──→ MercuryEngine reads   │             │
│  └───────────────────────────────────────────────┘             │
│                                                                 │
│  ┌───────────────────────────────────────────────┐             │
│  │  users/users                                  │             │
│  │                                               │             │
│  │  inbox_reference ─── LIVE SELECT ──→ PM App   │             │
│  │  (synced by MercuryEngine from company DBs)   │             │
│  └───────────────────────────────────────────────┘             │
│                                                                 │
│  ┌───────────────────────────────────────────────┐             │
│  │  companies/registry                           │             │
│  │                                               │             │
│  │  feedback ────────── LIVE SELECT ──→ Admin App│             │
│  │  feedback_response                            │             │
│  └───────────────────────────────────────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                          │
              MercuryEngine (cross-namespace bridge)
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
          ┌───────┐  ┌────────┐  ┌──────┐
          │ Sveve │  │Mailer  │  │ FCM  │
          │ (SMS) │  │Send    │  │(push)│
          └───────┘  └────────┘  └──────┘
```

---

## 11. Performance Considerations

| Metric | Saturn Capacity | DittoDatto Need (100 companies) |
|--------|-----------------|-------------------------------|
| Concurrent WS connections | Thousands | ~200-500 |
| LIVE SELECT subscriptions | Thousands | ~500-1000 |
| Messages/second | Hundreds | ~1-10 |
| Changefeed retention | Configurable | 7 days |
| Event processing | Near-instant | Sub-second sufficient |
| Memory per subscription | ~KB each | ~1-5 MB total |

**Saturn (20-core ARM64, 122GB RAM)** is massively overprovisioned for this workload. You could run the entire messaging system for 1000 companies on Saturn without breaking a sweat.
