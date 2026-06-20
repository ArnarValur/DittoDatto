# SurrealDB Namespace Topology

> **Recorded:** 2026-05-29 17:32
> **Status:** accepted

## Context

To support multi-tenancy, platform discovery, global system operations, and GDPR compliance, platform data must be logically segmented. GDPR specifically mandates strict separation of user PII from business operational data.

## Decision

We organize SurrealDB into two distinct namespaces and four database scopes:

```
companies (namespace)
├── {slug}                  ← One DB per company (isolated business operations)
├── discovery               ← Public search aggregator (listings, categories)
└── registry                ← Platform registry (companies, system alerts, audit logs)

users (namespace)
└── users                   ← GDPR-isolated consumer profiles (PII)
```

## Consequences

- Namespace users enforce strict security boundaries at the database level.
- Each company database is completely isolated; no query cross-talk can occur.
- Cross-namespace references (e.g. referencing a profile from a company database) are resolved at the application layer using string-based IDs.
