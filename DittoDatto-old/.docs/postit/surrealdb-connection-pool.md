---
title: "SurrealDB Connection Pool — Fix Shared Connection Race Condition"
priority: high
affects: mercury-engine
created: 2026-05-05
session: 14
status: open
tags: [surrealdb, concurrency, multi-tenancy, security]
---

# SurrealDB Connection Pool

## Problem

`SurrealDBClient._titan_conn` is a **single shared `AsyncSurreal` WebSocket connection**.
Every request calls `db.use("titan", f"company_{slug}")` to switch database context.

**`db.use()` mutates connection-level state — it is NOT coroutine-safe.**

Under concurrent load, Request A's `use()` can be overwritten by Request B's `use()` before A's query executes. Result: **company A reads company B's data**.

This is a **data isolation violation**, not just a performance issue.

> Confirmed by SurrealDB documentation: `.use()` sets context on the connection object itself, not per-query.

## Severity

**High** — any concurrent requests targeting different company slugs can leak tenant context. Doesn't require 1000 companies — reproducible with 2 under async load.

## Recommended Fix

**Per-tenant connection pool with LRU eviction** (SDB-endorsed pattern):

```python
from surrealdb import AsyncSurreal

class SurrealDBClient:
    def __init__(self):
        self._pool: dict[str, AsyncSurreal] = {}  # keyed by company slug
        self._max_pool_size = 50  # LRU evict beyond this

    async def titan(self, company_slug: str) -> AsyncSurreal:
        if company_slug not in self._pool:
            conn = AsyncSurreal(settings.surrealdb_url)
            await conn.connect()
            await conn.signin({"NS": "titan", "user": ..., "password": ...})
            await conn.use("titan", f"company_{company_slug}")
            self._pool[company_slug] = conn
        return self._pool[company_slug]
```

Each connection is scoped to exactly one database — no shared mutable state.

### Scale Considerations

| Concern | Mitigation |
|---------|-----------|
| Memory per connection | LRU eviction — cap pool at N connections, evict idle |
| File descriptors | Monitor with `ulimit -n`, raise if needed |
| SurrealDB server load | Each connection is lightweight (WS frame) |
| 1000+ companies | Not all active simultaneously — LRU handles the long tail |

## Not Recommended

| Pattern | Why |
|---------|-----|
| Shared connection + `use()` per request | ❌ Race condition (current bug) |
| Connection-per-request (no pool) | ✅ Safe but wasteful — reconnect overhead on every request |
| Single DB + tenant column | Loses namespace isolation, rewrites all queries |

## References

- SurrealDB Python SDK: [Create a new connection](https://surrealdb.com/docs/sdk/python/concepts/create-a-new-connection)
- SurrealDB Rust SDK: [Multi-tenancy patterns](https://surrealdb.com/docs/sdk/rust/concepts/multi-tenancy)
- Session 14 walkthrough — current implementation in `mercury_engine/db/client.py`
