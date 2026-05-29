# SurrealDB as Sole Platform Database

> **Recorded:** 2026-05-29 17:32
> **Status:** accepted

## Context

The DittoDatto ecosystem requires a high-performance database capable of document, graph, full-text (BM25), geospatial, and vector search. Traditional stacks require multiple databases (e.g. PostgreSQL, Neo4j, Qdrant, Meilisearch) and complex synchronization pipelines, which introduce significant operational overhead and potential consistency issues.

## Decision

We use **SurrealDB 3.0** as the single source of truth and sole platform database for all services. All secondary databases and external sync pipelines are deprecated.

## Consequences

- Highly simplified single-binary deployment footprint.
- Built-in multi-model features (graph relationships, vector indices, geo queries) are used directly via SurrealQL.
- Services connect to SurrealDB via native client SDKs or WebSockets.
