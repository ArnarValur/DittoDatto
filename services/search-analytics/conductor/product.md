# SearchAnalytics — Product Definition

> The intelligence layer behind DittoBar. Every keystroke is a signal.

---

## Purpose

SearchAnalytics is a standalone dashboard that visualizes search event data captured by DittoDatto's DittoBar. Its primary mission is **keyword intelligence** — understanding what users search for, and more importantly, what they search for and **don't find**.

Zero-result queries are the most valuable signal: they reveal unmet demand, missing service categories, and untapped market opportunities. This data drives marketing strategy, customer acquisition, and platform expansion decisions.

## Problem Statement

DittoBar (Phase 2.1) already captures all search events to a Firestore `searchEvents` collection — queries, result counts, click-throughs, and session data. But this data sits unread. There is no interface to:

- See what users are searching for
- Identify zero-result queries (unmet demand)
- Track conversion: search → click → booking
- Detect trending or declining search terms

SearchAnalytics closes this gap.

## Target Users

- **Captain (super_admin)** — Primary consumer. Strategic decisions around marketplace offerings and marketing.
- Future: business-facing stakeholders who need search intelligence.

## Core Value Propositions

1. **Zero-Result Intelligence** — Flagged list of queries that returned no results, ranked by frequency. Each one is a potential new service category or store onboarding opportunity.
2. **Top Queries Dashboard** — What are people looking for? Time-windowed (7d/30d) view of the most popular search terms.
3. **Conversion Funnel** — Query → Click → Booking pipeline. Which searches convert? Which don't?
4. **Real-Time Activity Feed** — Live stream of incoming search events for monitoring.

## Data Source

- **Collection:** `searchEvents` in DittoDatto's Firebase project (staging/production)
- **Access:** Direct Firestore reads, authenticated as super_admin
- **Schema:** `query`, `resultCount`, `selectedResult`, `userId`, `sessionId`, `source`, `createdAt`
- **Write path:** Cloud Function `analytics_logSearchEvent` (read-only consumer — SearchAnalytics never writes)

## Relationship to DittoDatto

SearchAnalytics is a **read-only satellite** of DittoDatto. It shares:
- Firebase project (auth + Firestore)
- `searchEvents` collection schema (defined in `packages/shared-types/src/search-event.ts`)

It does NOT share:
- Codebase, build pipeline, or deployment
- Monorepo dependencies
- Release cycle

This independence allows rapid experimentation with data visualization and analytics approaches without impacting DittoDatto's sprint cadence.

## Scope Boundaries

**In scope (MVP):**
- Dashboard with KPIs, top queries, zero-result queries, recent activity
- Firebase Auth gate (super_admin only)
- Time-windowed filtering (7d / 30d / custom)

**Out of scope (future):**
- Exporting data (CSV, BigQuery)
- Automated alerts (e.g., "new zero-result query spiking")
- DattoBar analytics (business portal search — `source: dattobar`)
- A/B testing or query suggestion management

## Success Metrics

1. Zero-result queries are visible and actionable within 24h of deployment
2. Captain can identify top 10 search terms at a glance
3. Click-through rate is computable per query
