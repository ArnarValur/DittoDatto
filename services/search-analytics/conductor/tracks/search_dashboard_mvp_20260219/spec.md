# Search Dashboard MVP — Specification

**Track:** `search_dashboard_mvp_20260219`
**Author:** Arnar (Captain) + Hermes (Navigator)
**Date:** 2026-02-19
**Version:** 0.1

---

## 1. Summary

Build the first usable view of DittoBar search intelligence. The dashboard reads from the `searchEvents` Firestore collection (populated by DittoDatto's `analytics_logSearchEvent` Cloud Function) and presents actionable insights.

**Primary goal:** Make zero-result queries visible and actionable.

---

## 2. Data Contract

Source: `searchEvents/{autoId}` in DittoDatto's Firebase project.

```typescript
// From packages/shared-types/src/search-event.ts
{
  id: string,
  query: string,              // What the user typed
  resultCount: number,        // 0 = zero-result query (🔴 data gold)
  selectedResult?: {          // Only if user clicked a result
    type: "store" | "category",
    id: string,
    name: string,
  },
  userId?: string,            // null if anonymous
  sessionId: string,          // Anonymous session tracking
  source: "dittobar" | "discover" | "dattobar",
  createdAt: Timestamp,       // Server timestamp
}
```

---

## 3. Functional Requirements

### 3.1 Firebase Setup

- Add Firebase SDK (`firebase` package)
- Configure with DittoDatto's Firebase project credentials
- Auth gate: only `super_admin` can access (Firebase Auth)
- Simple login page (email/password)

### 3.2 Dashboard Layout

- Nuxt UI `UDashboardPage` structure
- Sidebar navigation (minimal — single "Search Analytics" section for now)
- Responsive: desktop-first, functional on tablet

### 3.3 KPI Cards (Top Row)

- **Total Searches** — Count of all events in time window
- **Unique Queries** — Distinct query strings
- **Zero-Result Rate** — % of queries where `resultCount === 0`
- **Click-Through Rate (CTR)** — % of queries that have a `selectedResult`

### 3.4 Zero-Result Queries Table

- Columns: Query, Frequency, Last Seen, Source
- Sorted by frequency (descending)
- 🔴 Visual indicator — these are the gold
- Filterable by time window (7d / 30d / all)

### 3.5 Top Queries Table

- Columns: Query, Search Count, Avg Results, CTR, Top Clicked Result
- Sorted by search count (descending)
- Filterable by time window

### 3.6 Recent Activity Feed

- Real-time list of latest search events (last 50)
- Shows: timestamp, query, result count, source, selected result (if any)
- Auto-refresh via Firestore `onSnapshot`

---

## 4. Non-Functional Requirements

- **Read-only** — SearchAnalytics never writes to Firestore
- **Performance** — Queries should use appropriate Firestore indexes
- **No SSR required** — Can be full CSR/SPA since it's an internal tool
- **Dark mode** — Default theme

---

## 5. Out of Scope (This Track)

- Export to CSV/BigQuery
- Automated alerts
- Time-series charts (future enhancement)
- DattoBar analytics (separate source filter)
- User segmentation (anonymous vs. authenticated)

---

## 6. Firestore Indexes Needed

```
Collection: searchEvents
- createdAt (DESC) — for time-windowed queries
- query + createdAt (DESC) — for grouping by query
- resultCount + createdAt (DESC) — for zero-result filtering
```

---

## 7. Acceptance Criteria

1. Captain can log in and see the dashboard
2. Zero-result queries are listed with frequency counts
3. Top queries are listed with CTR
4. Recent activity shows live search events
5. Time window filter (7d/30d) works on both tables
