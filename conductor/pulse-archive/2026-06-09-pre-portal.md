# Pulse Archive — Pre-Business Portal Era

> Archived: 2026-06-09 16:30
> Reason: Entering Business Portal territory — fresh relay and session memory.

---

## Archived Relay Entries

### 2026-06-09 15:43 — Code Quality Safeguards (Security Incident Resolved)

- **Session:** Responded to post-mortem on hardcoded credentials in admin bin/ scripts. Created ADR-0015 + code-safety agent rule. Remediated all 7 scripts. Deleted 5 obsolete one-time scripts. Audited and trimmed agent-rules from 5→3 files.
- **Tracks touched:** None (cross-cutting infrastructure)
- **Status:** Security incident fully resolved. 115→0 lint warnings. All commits clean.
- **Decisions:** ADR-0015 (No Hardcoded Secrets or Record IDs)

### 2026-06-09 15:04 — BP Scaffold Closed + Security Incident in bin/ Scripts

- **Session:** Closed BP scaffold track (Phase 3 verification). Discovered hardcoded credentials in `apps/admin/bin/` scripts from Gemini 3.5 session.
- **Tracks touched:** `business_portal_scaffold_20260608` (closed)
- **Status:** Scaffold track complete (`eadc310`). Security issue open.
- **Decisions:** None

### 2026-06-09 01:15 — Business Portal Phase 2 Complete (Router & Shell)

- **Session:** Implemented all Phase 2 tasks of the Business Portal scaffold track using strict TDD workflow.
- **Tracks touched:** `business_portal_scaffold_20260608`
- **Status:** Phase 2 complete. 22 tests passing, 0 lint issues. Checkpoint: `4a24f3f`.

### 2026-06-08 20:55 — Business Portal Login & Tenant RBAC Spec

- **Decisions:** ADR-0013 (Business Portal Multi-Tenant Authentication and Routing)

### 2026-06-08 20:17 — Administrative Roles Support

- **Tracks touched:** `admin_panel_20260527`
- **Status:** Completed. All 4 roles exposed. Deployed to Saturn.

### 2026-06-08 12:25 — Business Portal Scaffold Track Created

- **Tracks touched:** Created `business_portal_scaffold_20260608`

### 2026-06-08 12:05 — Business Portal Domain Refinement & PRD

- **Decisions:** ADR-0010, ADR-0011, ADR-0012

### 2026-06-08 03:10 — Business Portal Audits & Flutter Architecture Blueprint

- **Status:** Completed audit reports saved to artifacts.

### 2026-06-05 02:45 — Category Screen Material Icons & Validation

- **Tracks touched:** `admin_panel_20260527`

### 2026-06-03 20:05 — User Email & Role Dialog Restructuring

- **Tracks touched:** `admin_panel_20260527`

### 2026-06-03 15:40 — Company Owner Update Sync & Optional Phone Clearing

- **Tracks touched:** `admin_panel_20260527`

### 2026-06-01 13:40 — Staging Timezone & Recursive Null Coercion Fix

- **Tracks touched:** `admin_panel_20260527`

### 2026-06-01 00:50 — User Dialog Staging NULL Sweep & Safe Transitions

- **Tracks touched:** `admin_panel_20260527`

### 2026-06-01 00:20 — Users Premium Redesign + Staging Web Crypto Fix

- **Tracks touched:** `admin_panel_20260527`
- **Decisions:** ADR-0008, ADR-0009

### 2026-05-30 17:44 — Auth infrastructure + persistence

- **Tracks touched:** `admin_panel_20260527`
- **Decisions:** ADR-0007

### 2026-05-30 14:49 — Admin Panel audit + conductor cleanup

- **Tracks touched:** `admin_panel_20260527`

### 2026-05-30 13:35 — Conductor standardization + Admin Panel revert

- **Tracks touched:** `admin_panel_20260527`

---

## Archived Session Memory

- *2026-06-09 - 15:43* — ✅ Security incident RESOLVED. ADR-0015 settled.
- *2026-06-09 - 15:04* — 🚨 Security: hardcoded credentials discovered in admin bin/.
- *2026-06-09 - 08:53* — Completed Phase 3 of Business Portal scaffold.
- *2026-06-09 - 01:15* — Completed Phase 2 of Business Portal scaffold.
- *2026-06-08 - 20:17* — Manage all roles in Admin UI.
- *2026-06-08 - 20:17* — Conditional SurrealQL role protection.
- *2026-06-08 - 12:25* — Closed interface: Business Portal always requires Login first.
- *2026-06-05 - 02:45* — Chosen static curated set of Google Material Icons.
- *2026-06-03 - 20:05* — Added Email and Role dropdown editing to Edit User dialog.
- *2026-06-01 - 13:38* — Implemented recursive JSON null-remover.
- *2026-06-01 - 13:21* — Form-filled datetime columns standardized to UTC.
- *2026-06-01 - 00:10* — Restricted back-office Users screen to customer/business only.
- *2026-06-01 - 00:12* — Bypass Web Crypto secure-context crashes.
- *2026-06-01 - 00:44* — Sweep null-valued entries from database query maps.
- *2026-06-01 - 00:47* — Removed unused Company Slug fields from User dialogs.
- *2026-06-01 - 00:49* — Transition list notifier state updates to fetch in-place.
