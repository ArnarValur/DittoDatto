# ADR-0011: Real-Time Connection Handling over Local Sync

> **Recorded:** 2026-06-08
> **Status:** accepted
> **Domain:** business-portal

## Context

Unlike Firebase Firestore, which offers client-side offline replication and queued offline mutation writes out of the box, SurrealDB operates primarily on a live WebSocket connection. Designing a robust offline-first synchronization engine with conflict resolution and mutation queues in Flutter is complex and prone to visual synchronization drift.

## Decision

The Business Portal will operate in a **real-time only** mode over active SurrealDB WebSocket connections. 

- **Connection-Loss UI:** If the WebSocket connection drops, the application will display a prominent, non-intrusive connection-loss warning banner or overlay (using `DittoErrorView`).
- **Mutation Lock:** All forms, button actions, and database mutations will be disabled/locked while the connection is offline.
- **Auto-Reconnect:** The client will run exponential backoff reconnection attempts automatically. Upon reconnection, the active Riverpod providers will refresh to synchronize the latest live database state.

## Consequences

- Dramatically simplifies the client-side data layer by eliminating local write queues and conflict-resolution logic.
- Avoids state desynchronization issues that could lead to double-booking or scheduling conflicts in a multi-user merchant environment.
- Places the UX focus on network resilience, warning merchants instantly when they are disconnected rather than giving a false impression of offline functionality.
