# Pulse — Current Project State

**Last Updated:** 2026-05-30 17:05
**Session Focus:** Admin Panel — live SurrealDB wiring, mock removal, autofill fix

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Mocks removed. App now connects directly to SurrealDB on Saturn. Login verified working. CRUD screens need browser verification against empty database. Autofill fix deployed.

## ✅ Recently Completed

- **2026-05-30** — **Live SurrealDB wiring.** Removed MockAdminRepository, MockAuthService, USE_MOCKS flag. Fixed login autofill (AutofillGroup + autofillHints + finishAutofillContext). Migrated schemas from DittoDatto-old to project root with namespace rename (titan→companies, enceladus→users). Purged fake seed data from Saturn. Built and deployed to Saturn. Login verified working.
- **2026-05-30** — **Grill admin-panel.** PRD updated to v1.2. Dashboard deprioritized. Category model confirmed correct. ADR subdirectories created for domain separation. ADR audit: all 6 existing ADRs consistent with current decisions.
- **2026-05-30** — **Admin Panel audit + conductor cleanup.** Three-subagent audit. Purged informal language. Trimmed context.md glossary.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto.tailb251cd.ts.net:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnar` and `hoddi` (ROLES OWNER on both `companies` and `users` namespaces)
- **Database is empty** — no user/company/category records. User will create real data via Admin Panel.
- **Schemas source of truth:** `schemas/` at project root (migrated from DittoDatto-old, namespaces renamed)
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`. Global sequential numbering.

## 📋 Next Session Suggestions

1. 🖥️ **Browser-verify all CRUD screens** — Dashboard stats, Users list, Companies list+CRUD, Categories CRUD. Test with empty DB, then create real records.
2. 🧹 **Clean up stale test file** — `test/login_screen_test.dart` has unused import warning and references old mock patterns.
3. 📦 **Inbox real data path** — Currently hardcoded app-local. Needs repository pattern when messaging is grilled.
