# SurrealDB Schema Blueprints

**Version:** 0.1.0  
**Last Updated:** 2026-05-03  
**Source Decisions:** [Session 8](../.docs/grill/session-8-surrealdb-namespace-architecture.md) + [Session 9](../.docs/grill/session-9-surrealdb-schema-sequencing.md)

## Architecture

```
companies (namespace)
├── company_{slug}           ← Per-company DB (from company-blueprint.surql)
│   ├── Core: establishment, service, service_group, staff, customer
│   ├── Booking: booking, hold
│   ├── Schedule: date_override
│   ├── Resources: resource, resource_group
│   ├── Edges: offers, works_at, assigned_to
│   ├── Comms (v1.4): message_thread, message
│   └── Agent Memory: entity, fact, relates_to
├── discovery                ← Public aggregator (from discovery.surql)
│   ├── category, area, establishment_listing, search_event
│   └── Edges: categorized_as, located_in
└── platform                 ← System ops (from platform.surql)
    └── company, system_alert, icon_collection, audit_log

users (namespace)
└── users                    ← GDPR-isolated PII (from users.surql)
    └── user, favorite, booking_ref
```

## Files

| File | Target | Description |
|------|--------|-------------|
| `init.surql` | Root | Namespace + database creation + service accounts |
| `company-blueprint.surql` | `companies/company_{slug}` | Template applied per company onboard |
| `discovery.surql` | `companies/discovery` | DittoBar search, categories, areas, demand signals |
| `users.surql` | `users/users` | Consumer profiles, favorites, booking refs |
| `platform.surql` | `companies/registry` | Company registry, system alerts, audit log |

## Apply Order

```bash
# 1. Bootstrap namespaces and databases
surreal sql --endpoint http://localhost:8000 -u root -p <pw> < schemas/init.surql

# 2. Apply static database schemas
surreal sql --endpoint http://localhost:8000 -u root -p <pw> --ns companies --db discovery < schemas/discovery.surql
surreal sql --endpoint http://localhost:8000 -u root -p <pw> --ns companies --db platform < schemas/platform.surql
surreal sql --endpoint http://localhost:8000 -u root -p <pw> --ns users --db users < schemas/users.surql

# 3. Provision a company (example: Sawasdee)
surreal sql --endpoint http://localhost:8000 -u root -p <pw> --ns companies -c "DEFINE DATABASE IF NOT EXISTS company_sawasdee"
surreal sql --endpoint http://localhost:8000 -u root -p <pw> --ns companies --db company_sawasdee < schemas/company-blueprint.surql
```

## Zod → SurrealQL Translation Rules

| Zod | SurrealQL |
|-----|-----------|
| `z.string()` | `TYPE string` |
| `z.number()` | `TYPE number` |
| `z.number().int()` | `TYPE int` |
| `z.boolean()` | `TYPE bool` |
| `DateTimeSchema` | `TYPE datetime` |
| `z.enum([...])` | `TYPE string ASSERT $value IN [...]` |
| `IdSchema` (FK) | `TYPE record<table>` |
| `IdSchema` (cross-DB) | `TYPE string` (can't cross namespaces) |
| `.optional()` | `TYPE option<T>` |
| `.default(v)` | `DEFAULT v` |
| `z.array(z.string())` | `TYPE array<string>` |
| `z.object({...})` (embedded) | `TYPE object` + nested DEFINE FIELD |
| `gmapCoord` | `TYPE geometry<point>` (native) |
| `geoHash` | Dropped (SurrealDB handles geo natively) |

## Key Design Decisions

- **companyId dropped** — implicit via database isolation
- **Cross-DB refs as strings** — SurrealDB can't do cross-namespace record links
- **Soft delete** — `deleted_at` field on all major tables (GDPR audit trail)
- **Embedded vs separate** — booking_policy, opening_schedule stay embedded in establishment (1:1, always co-fetched). date_override extracted to own table (grows over time).
- **Graph edges** — `offers`, `works_at`, `assigned_to` carry metadata. Pure ownership uses `record<T>` links.
- **Full-text search** — Norwegian snowball stemmer on discovery listings

## Phase 1.2 Enrichments

Patterns from the [SurrealDB industry schemas](https://surrealdb.com/docs/learn/schema-management/schema-design/sample-industry-schemas) to apply when building the SurrealDB adapter. These deepen the blueprint without changing table structure.

### 1. `VALUE` + `READONLY` (timestamps)

Current blueprints use `DEFAULT time::now()` for both `created_at` and `updated_at`. Fix:

```sql
-- created_at: set once, never mutated
DEFINE FIELD created_at ON booking TYPE datetime VALUE time::now() READONLY;

-- updated_at: auto-updates on every write
DEFINE FIELD updated_at ON booking TYPE datetime VALUE time::now();
```

**Apply to:** All tables with timestamp pairs.

### 2. `COMPUTED` fields (derived data)

Zero-cost derived values calculated on every SELECT:

```sql
DEFINE FIELD duration ON booking COMPUTED end_time - start_time;
DEFINE FIELD is_active ON staff COMPUTED deleted_at IS NONE;
DEFINE FIELD service_count ON establishment COMPUTED count(<-offers<-service);
```

**Candidates:** booking duration, staff active status, establishment service count, hold expiry check.

### 3. `REFERENCE` (referential integrity)

Prevents dangling record links at the DB level:

```sql
DEFINE FIELD establishment ON service TYPE record<establishment> REFERENCE;
DEFINE FIELD staff ON booking TYPE record<staff> REFERENCE;
```

**Apply to:** All `TYPE record<T>` fields that must not dangle.

### 4. `DEFINE EVENT` (database-level reactivity)

Auto-populate audit logs, flag demand signals, cascade state changes:

```sql
DEFINE EVENT booking_audit ON booking WHEN $event IN ["CREATE", "UPDATE"] THEN {
    CREATE audit_log SET
        entity_type = "booking",
        entity_id = string::from($after.id),
        action = $event,
        timestamp = time::now(),
        snapshot = $after;
};

DEFINE EVENT flag_zero_result ON search_event WHEN $event = "CREATE" AND $after.result_count = 0 THEN {
    UPDATE $after SET is_zero_result = true;
};
```

**Candidates:** Booking lifecycle → audit_log, search_event zero-result flagging, hold expiry cleanup.

### 5. `DEFINE FUNCTION` (atomic operations)

Encapsulate transactional business logic in the database:

```sql
DEFINE FUNCTION fn::create_hold($service: record<service>, $staff: record<staff>, $start: datetime, $end: datetime) {
    BEGIN;
    -- Check no overlapping holds/bookings
    LET $conflicts = SELECT * FROM hold
        WHERE service = $service AND staff = $staff
        AND start_time < $end AND end_time > $start
        AND status = 'active';
    IF $conflicts.len() > 0 { THROW "Slot conflict"; };
    LET $hold = CREATE hold SET service = $service, staff = $staff,
        start_time = $start, end_time = $end, status = 'active';
    COMMIT;
    RETURN $hold;
};
```

**Candidates:** `fn::create_hold()`, `fn::confirm_booking()`, `fn::cancel_booking()`, `fn::provision_company()`.

### 6. Pre-computed table views (materialized analytics)

Aggregated views auto-maintained by SurrealDB:

```sql
DEFINE TABLE monthly_bookings TYPE NORMAL SCHEMAFULL AS
    SELECT count() AS total,
           time::format(created_at, '%Y-%m') AS month,
           status
    FROM booking GROUP BY month, status;

DEFINE TABLE search_demand TYPE NORMAL SCHEMAFULL AS
    SELECT count() AS query_count,
           query AS search_term,
           math::mean(result_count) AS avg_results
    FROM search_event GROUP BY search_term;
```

**Candidates:** Monthly booking summaries, search demand heatmaps, popular categories.

### 7. `DEFINE PARAM` (global constants)

Shared constants referenced across functions and events:

```sql
DEFINE PARAM $HOLD_TTL_MINUTES VALUE 10;
DEFINE PARAM $BOOKING_MODES VALUE ["standard", "tableReservation", "ticketSystem"];
DEFINE PARAM $MAX_PARTY_SIZE VALUE 20;
```

**Candidates:** Hold TTL, booking modes enum, max party size, cancellation deadlines.

---

### Enrichment Priority

| Priority | Pattern | Impact |
|----------|---------|--------|
| 🔴 High | `VALUE`/`READONLY` timestamps | Correctness — `updated_at` is currently broken |
| 🔴 High | `REFERENCE` | Data integrity — prevents orphaned records |
| 🟡 Medium | `COMPUTED` fields | DX — reduces app-layer derivation |
| 🟡 Medium | `DEFINE EVENT` audit | Automation — audit log populated without app code |
| 🟢 Low | `DEFINE FUNCTION` | Phase 3 — when write adapter is built |
| 🟢 Low | Pre-computed views | Phase 4 — when analytics matter |
| 🟢 Low | `DEFINE PARAM` | Phase 3 — when functions need constants |

> **Source:** [SurrealDB sample industry schemas](https://surrealdb.com/docs/learn/schema-management/schema-design/sample-industry-schemas) — patterns from project planning, banking, e-commerce, and healthcare schemas.

