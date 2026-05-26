---
schema: AppSettingsSchema
domain_term: App Settings
firestore_path: settings/app
status: active
version: v1.0
related: []
noona_equivalent: N/A
tags: [platform, admin-panel]
---

# App Settings

Global platform configuration. A single document at `settings/app`. Controls maintenance mode and debug flags.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `maintenanceMode` | `boolean` | ✅ | Whether the platform is in maintenance. Default: `false` |
| `maintenanceMessage` | `string` | ❌ | Message displayed during maintenance |
| `solarDebugEnabled` | `boolean` | ✅ | Whether Solar debug panel is active. Default: `false` |
| `updatedAt` | `Date` | ✅ | Last modification |
| `updatedBy` | `string` | ❌ | Admin who made the change |

## Design Notes

- Singleton document — only one exists at `settings/app`.
- `maintenanceMode: true` shows a full-screen maintenance overlay on all apps.
- `solarDebugEnabled` is an internal debug tool for the Admin Panel.
