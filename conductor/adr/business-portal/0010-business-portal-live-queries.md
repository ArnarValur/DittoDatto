# ADR-0010: Business Portal Live Queries

> **Recorded:** 2026-06-08
> **Status:** accepted
> **Domain:** business-portal

## Context

The legacy Business Portal web application relied on Firebase/Firestore for client-side collections binding and real-time streams. With the platform transition to a direct-to-database SurrealDB 3.1 architecture (ADR-0006), we need a performant, WebSocket-driven replacement to synchronize rotas, appointments, table availability, and thread messages in real-time in the new Flutter Business Portal.

## Decision

We will connect the Flutter Business Portal directly to the tenant database (`companies/company_{slug}`) via WebSockets, and utilize SurrealDB's native **Live Queries** (`LIVE SELECT`) to drive real-time data sync in the user interface. 

- **WebSocket Connection:** The client establishes a single long-lived WebSocket connection to the tenant database.
- **Riverpod stream providers:** We will use Riverpod's `StreamProvider` to manage the lifecycle of Live Queries, ensuring subscriptions are automatically opened and closed when UI screens mount and unmount.

## Consequences

- Completely eliminates legacy Firebase/Firestore dependencies from the Business Portal.
- Real-time updates inherit SurrealDB's database-level row and table-level permissions and tenant boundary isolations.
- Reduces network overhead and simplifies frontend data bindings by treating SurrealDB as the single source of truth for both query rendering and mutation streams.
