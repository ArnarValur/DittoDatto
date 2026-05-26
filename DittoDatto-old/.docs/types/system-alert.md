---
schema: SystemAlertSchema
domain_term: System Alert
firestore_path: systemAlerts/{alertId}
status: active
version: v1.0
related: [activity]
noona_equivalent: N/A
tags: [platform, admin-panel]
---

# System Alert

A zero-fan-out broadcast mechanism. Admin writes ONE document → all matching users see it. No per-user writes, no fan-out. Client-side composable queries for active alerts matching the user's audience.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `title` | `string` | ✅ | Alert title (1–200 chars) |
| `body` | `string` | ✅ | Alert body (max 1000 chars) |
| `severity` | `enum: info, warning, critical` | ✅ | Visual treatment |
| `targetAudience` | `enum: all, business, customers, admin` | ✅ | Who sees it |
| `isActive` | `boolean` | ✅ | Whether visible. Default: `true` |
| `startsAt` | `Timestamp` | ❌ | Auto-show time |
| `expiresAt` | `Timestamp` | ❌ | Auto-hide time |
| `actionUrl` | `string (url)` | ❌ | Link for more info |
| `actionLabel` | `string` | ❌ | Button text (max 50 chars) |
| `createdBy` | `string` | ❌ | Admin UID |
| `createdAt` | `Timestamp` | ✅ | Creation timestamp |
| `updatedAt` | `Timestamp` | ❌ | Last modification |

## Design Notes

- **Zero fan-out** is the key architectural decision. Alerts are read-side filtered — the client queries `systemAlerts` where `isActive === true && targetAudience in [user's role, "all"]`. No per-user documents needed.
- `startsAt` / `expiresAt` enable scheduled maintenance windows: "System maintenance Friday 22:00–02:00."
- Severity maps to visual treatment: `info` (blue), `warning` (amber), `critical` (red banner).
