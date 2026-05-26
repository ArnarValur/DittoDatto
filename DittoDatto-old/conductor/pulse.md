**Last Updated:** 2026-05-06 13:33

**Session Focus:** S21 Planning — Admin Panel Architecture Deepening (4 candidates identified)

> 📋 See also: [Captain's Log](./captains-log.md) — personal context & working style

---

## 🚀 Chapter 2: Flutter-First Rebuild

DittoDatto has entered Chapter 2 — transitioning from Nuxt web apps to Flutter native, with agentic infrastructure arriving via Saturn (GX10).

### Key Decisions Made (Grill Session 1 — 2026-05-02)

| Decision | Outcome | Documented |
|----------|---------|------------|
| Flutter = the product, web = shell | **Public Marketplace** is Flutter native (iOS + Android). Nuxt becomes **Web Shell** (landing + SEO). | `.docs/CONTEXT.md` |
| DittoBar search on TheOracle | Server-side via TheOracle microservice (supersedes ADR-0001). SurrealDB on Saturn. | `.docs/adr/0007-dittobar-search-on-theoracle.md` |
| SurrealDB as platform graph DB | Unified graph+search+geo+vector engine. Replaces Qdrant. No tvíverknað. | `.docs/adr/0008-surrealdb-platform-graph-database.md` |
| "Establishment" not "Store" | User-facing terminology. Firestore remains `stores` — repo layer maps. | `.docs/CONTEXT.md` |

### Version Roadmap

| Version | Focus | Status |
|---------|-------|--------|
| **v1.0** | Core tracer bullet (Auth+BankID, Home+Map+DittoBar, Browse, Book, My Bookings) | `[ ]` PRD in progress |
| **v1.1** | Stickiness (Favorites, profile polish) | `[ ]` Not started |
| **v1.2** | Restaurant vertical (Table reservations) | `[ ]` Not started |
| **v1.3** | Payment (Vipps) | `[ ]` Not started |
| **v1.4** | Comms layer (Messages, notifications — Ditto↔Datto neural foundation) | `[ ]` Not started |
| **v1.5** | Agentic path (Ditto agent interface, voice/text, Saturn-powered) | `[ ]` Not started |

---

## 🔄 Active Tracks

| Domain | Track | Status | Next |
|--------|-------|--------|------|
| MercuryEngine | **V2 Python Migration** | `[✓]` S18 complete. 377 tests. Admin routes live. | Stable — admin consumes it |
| Flutter Admin Panel | **Screens** | `[✓]` S20 complete. All 4 screens wired to live engine. | Visual review on tablet, then polish |
| Shared Packages | **`mercury_client`** | `[✓]` S19 complete. 9 tests, 11 admin endpoints + auth. | Consumed by admin — marketplace next |
| Public Marketplace (Flutter) | **PRD Grilling** | `[✓]` PRD synthesized | On hold — admin validates patterns first |
| ~~TheOracle~~ | **Absorbed into MercuryEngine** | `[✓]` ADR-0007 revised | N/A |
| Infrastructure | **Saturn (GX10) arrival** | `[ ]` Hardware incoming | Day-1 checklist + SurrealDB Dome |

> 📦 Chapter 1 (Nuxt web era) archived. TypeScript codebase frozen as reference.
> 🐍 Chapter 2.5: MercuryEngine V2 = Python/FastAPI/Pydantic/SurrealDB

---

## ⚠️ Blockers

| Blocker | Affects | Priority |
|---------|---------|----------|
| Saturn (GX10) not yet delivered | Agentic infrastructure, local staging stack | ETA **2026-05-07** (tomorrow) |
| BankID/Vipps integration design | Auth flow for Flutter v1.0 | PostIT created (.docs/postit/bankid-vipps-auth.md) |
| Vipps merchant registration | Payment + auth | Not started — need portal signup |

---

## 🧠 Session Memory

### 2026-05-05 25:00–25:16 – Post-S16.5 Grill: Flutter Admin Panel (Antigravity)

**Type:** `/grill-me` → Architecture grill (10 decisions resolved)

**What was accomplished:**

1. ✅ **ADR-0011 written** — Flutter Admin Panel architecture, 10 decisions locked
2. ✅ **Scope defined** — Login, Dashboard, Users, Companies, Categories, Inbox (stub). 5 screens from 24.
3. ✅ **Platform target** — Android-first (LineageOS tablet), desktop + web as freebies
4. ✅ **Shared package** — `packages/mercury_client/` from day one, consumed by admin + marketplace + business portal
5. ✅ **Tech stack** — Riverpod, Material 3 dark, `#6f71cc` Moody Blue, GoRouter
6. ✅ **Auth flow** — Extend dev-login with `ADMIN`/`SUPER_ADMIN`, biometric re-auth via `local_auth`
7. ✅ **Execution plan** — S18 (engine admin routes) → S19 (Flutter scaffold + mercury_client) → S20 (screens)
8. ✅ **Tracks updated** — Admin panel is Step 2, marketplace renumbered to Step 3
9. ✅ **Decisions.md updated** — 10-row decision table + ADR link

**Key insight:** Surrealist UI eliminates the need for database-level admin pages. Flutter admin only handles business-logic orchestration (user management, company provisioning, taxonomy).

**Captain is:** Ready for S19. Let's build the Flutter scaffold.

### 2026-05-06 12:45–13:33 – S21 Planning: Architecture Deepening (Antigravity)

**Type:** `/improve-architecture` → Architecture exploration (4 candidates)

**What was accomplished:**

1. ✅ **Tablet identified** — Lenovo TB125FU (Apollo): no fingerprint sensor, PIN/pattern only via `local_auth`
2. ✅ **4 deepening candidates** — Session gate (login friction), shared scaffolding, provider topology, type safety
3. ✅ **Plan stored** — `conductor/tracks/s21-admin-deepening/plan.md` (4 slices, 15 files, 0 new deps)
4. ✅ **Race condition identified** — `_tryRestore()` fire-and-forget causes login screen flash on every cold start
5. ✅ **Token lifetime confirmed** — 7-day JWT, so restore should work across sessions

**Open decisions (for next session):**

- Server URL visibility on login screen (gear icon only, or subtle label too?)
- PIN unlock vs silent restore (recommended: silent)
- Saturn default swap (deferred until GX10 is running)

**Captain is:** Restarting session. Skeptical on quality — wants fresh context.

### 2026-05-06 01:05–01:50 – Session 20: Flutter Admin Screens (Antigravity)

**Type:** `/conductor` → Pair-engineering execution (3 vertical slices)

**What was accomplished:**

1. ✅ **Shared widgets** — `StatCard`, `ConfirmDialog`, `RoleBadge`/`TierBadge`/`OnboardingBadge`
2. ✅ **Dashboard screen** — 4 stat cards (users, companies, categories, engine health), pull-to-refresh, `FutureProvider`
3. ✅ **Categories screen** — Full CRUD table (create/edit dialogs, delete confirmation, slug auto-generation), `AsyncNotifier`
4. ✅ **Users screen** — Paginated table, role badges (gold/blue/gray/green), inline role editing via `PopupMenuButton`
5. ✅ **Companies screen** — Paginated table, tier/onboarding badges, 7-section create/edit dialog (core/contact/address/tier/features/store-policy/social)
6. ✅ **13 new files**, `dart analyze` clean on both packages
7. ✅ **Web verified** — App runs in Chrome, login screen renders

**Key decisions:**

- Built-in `DataTable` over `data_table_2` (sufficient for admin use case)
- `AsyncNotifier` + `invalidateSelf()` for CRUD (simple, consistent)
- `DropdownButtonFormField.initialValue` (Flutter 3.33 deprecation fix)
- Slug auto-generation with manual override

**Captain is:** Going to rest. Visual review on tablet pending.

### 2026-05-06 00:25–00:38 – Session 19: Flutter Scaffold + mercury_client (Antigravity)

**Type:** `/conductor` → Pair-engineering execution (7 vertical slices)

**What was accomplished:**

1. ✅ **`packages/mercury_client/`** — Shared Dart package (API client, auth, models)
2. ✅ **Dart models** — User, Company, Category, TokenResponse, AdminStats, PaginatedResponse with `@JsonValue` enum annotations
3. ✅ **HTTP client** — `MercuryApi` with JWT injection, 15s timeout, typed error mapping
4. ✅ **11 admin API methods** — Stats, Users (list/get/role), Companies (list/create/update), Categories (CRUD)
5. ✅ **Auth service** — Login → `flutter_secure_storage` → token restore on restart → expiry detection
6. ✅ **`apps/admin/`** — Flutter app scaffold (GoRouter, Riverpod, Material 3 dark, Moody Blue `#6f71cc`)
7. ✅ **Login screen** — Server URL presets (Pluto/Saturn LAN/Saturn Internet), email+password, error handling
8. ✅ **App shell** — Permanent sidebar drawer matching Chapter 1 Nuxt layout, 5 nav items, user profile + logout
9. ✅ **5 stub screens** — Dashboard, Users, Companies, Categories, Inbox (all S20 placeholders)
10. ✅ **Inter font bundled** — Offline-first (4 weights from v4 release)
11. ✅ **9 tests**, dart analyze clean on both projects, running on LineageOS tablet

**Key decisions:**

- `http` over `dio` (lighter, sufficient for REST)
- `@JsonValue` annotations for SurrealDB enum string parity
- Port 5002 for dev presets (matches engine config.py)
- `--no-enable-impeller` required for LineageOS tablet GPU drivers

**Captain is:** Seeing the app on the tablet. Ready for S20.

### 2026-05-06 00:00–00:08 – Session 18: Engine Admin Routes (Antigravity)

**Type:** `/conductor` → Pair-engineering execution (7 vertical slices)

**What was accomplished:**

1. ✅ **ActorRole extended** — Added `ADMIN` and `SUPER_ADMIN` (matches `users.surql` assertion)
2. ✅ **`require_admin` middleware** — New 4th auth tier, platform-wide (no company slug)
3. ✅ **Category model** — `titan/discovery.category` with slug, icon, count
4. ✅ **Company model** — `titan/platform.company` with full schema (tier, features, policies, social)
5. ✅ **2 new repository ABCs** — `CategoryRepository`, `CompanyRepository` (slug lookup)
6. ✅ **2 new SurrealDB adapters** — `SurrealCategoryRepo` (hard-delete), `SurrealCompanyRepo`
7. ✅ **DB client extended** — `platform()` and `discovery()` methods on `SurrealDBClient`
8. ✅ **11 admin endpoints** — Stats, Users (list/get/role), Companies (list/create/update), Categories (CRUD)
9. ✅ **Dev-login updated** — Admin users get `allowed_companies: ["*"]`
10. ✅ **73 new tests** — Middleware (5), model validation (21), route auth (44+2 escalation)
11. ✅ **377 total tests**, lint clean

**Key decisions:**

- Company provisioning = registry CRUD only; Surrealist handles DB creation
- Admin router always-on (middleware-protected, not dev-gated)
- Role escalation guard: only `super_admin` can grant admin roles
- Categories use hard-delete (no soft-delete for taxonomy)

**Captain is:** Checkpointing. Ready for S19.

> 📦 Full history: [archive/2026-05-part1.md](./archive/2026-05-part1.md) — Sessions 2–16.5

---

## 📋 Next Session Suggestions

1. 🏗️ **S21 Execute** — Architecture deepening (plan at `conductor/tracks/s21-admin-deepening/plan.md`). 4 slices, 15 files.
2. 📱 **S20 Visual Review** — Test all 4 screens on LineageOS tablet against live MercuryEngine. Fix any runtime issues.
3. 🎨 **UI Polish** — Micro-animations, loading shimmer, empty state illustrations.
4. 🪐 **When Saturn arrives (May 7th):** Execute Day-1 checklist + move V2 stack to Saturn.
5. 🔄 **Rebook Endpoint** — Atomic cancel-old + hold-new transaction (engine backlog).

---

## 🔗 Quick Links

- [CONTEXT.md](../.docs/CONTEXT.md) — Domain glossary (source of truth)
- [ADR-0011](../.docs/adr/0011-flutter-admin-panel.md) — Flutter Admin Panel architecture
- [ADR-0010](../.docs/adr/0010-auth-architecture.md) — Auth architecture
- [ADR-0007](../.docs/adr/0007-dittobar-search-on-theoracle.md) — TheOracle discovery microservice
- [ADR-0008](../.docs/adr/0008-surrealdb-platform-graph-database.md) — SurrealDB as platform graph database
- [Engine Bookshelf](../.docs/engine/README.md) — MercuryEngine documentation hub
- [Engine Verdict](../.docs/engine/verdict.md) — Session 3 audit & Noona comparison
- [vision.md](./vision.md) — Long-term agentic commerce vision & 5-year horizon
- [tracks.md](./tracks.md) — Full track list by domain
- [agent-profile.md](./agent-profile.md) — Agent conventions & warnings

---
