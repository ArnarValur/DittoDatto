# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

## 2026-05-30 17:44 — Auth infrastructure + persistence

- **Tracks:** `admin_panel_20260527` (in progress)
- Fixed GoRouter recreation bug → single instance with refreshListenable
- Switched AuthNotifier from Notifier to AsyncNotifier (eliminates restore race)
- Added JWT persistence via FlutterSecureStorage (survives page reload, 1h TTL)
- Created namespace users `arnarvalur` and `gurkudrengur` on both namespaces
- Cleaned bootstrap.surql to schema-only
- Tests green (3/3), deployed to Saturn
- **Decisions:** ADR-0007 (admin auth infrastructure)
- **Next:** Browser-verify CRUD screens. Remove legacy `arnar`/`hoddi` namespace users if no longer needed.

---

- **Tracks:** `admin_panel_20260527` (in progress)
- Removed all mock code: MockAdminRepository, MockAuthService, USE_MOCKS flag
- Fixed login autofill: AutofillGroup, autofillHints, finishAutofillContext
- Migrated schemas to `schemas/` at project root (titan→companies, enceladus→users)
- Purged fake seed data from Saturn Hub (all tables empty)
- Built + deployed to Saturn. Login verified working via browser.
- Grilled admin-panel: PRD v1.2, dashboard deprioritized, category model confirmed
- Created ADR subdirectories (admin-panel, business-portal, marketplace, mercury-engine)
- Audited all 6 ADRs — no contradictions with current decisions
- 0 ADRs
- **Next:** Fix auth bug: SurrealDB Dart signin() doesn't throw on bad creds — any email gets past login but queries fail. Test with `arnar@dittodatto.no`/`admin123` first. Then browser-verify CRUD screens, create real records, clean up test file.

---

## 2026-05-30 14:49 — Admin Panel audit + conductor cleanup

- **Tracks:** `admin_panel_20260527` (in progress)
- Full audit: 3 subagents audited auth, CRUD/data layer, SurrealDB infrastructure
- Audit artifact produced with truth table of what's real vs mock vs fiction
- Purged informal language from 8 files
- Trimmed context.md glossary to one-line entries
- Rewrote relay.md to bullet-point facts
- Removed all legacy references from context.md
- Fixed metadata.json description to reflect actual state
- 0 ADRs
- **Next:** User regrilling project context, then Admin Panel implementation

---

## 2026-05-30 13:35 — Conductor standardization + Admin Panel revert

- **Tracks:** `admin_panel_20260527` (in progress)
- Standardized `.agents/workflows/` with v2.1 templates
- Removed redundant `conductor-init.md` from workspace
- Reverted `metadata.json` status to `in_progress`
- 0 ADRs
- **Next:** `/grill admin-panel` to align scope and verify progress
