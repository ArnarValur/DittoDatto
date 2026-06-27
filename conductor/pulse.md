# Pulse — Current Project State

**Last Updated:** 2026-06-27 23:34
**Session Focus:** Research review + SDB message bus deep dive delivery

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.

## ✅ Recently Completed

- **2026-06-27 23:34** — **All 4 research docs delivered.** Noona CRM, CRM architecture, Communication architecture, SDB message bus deep dive + experiment script. User reviewed all reports.
- **2026-06-27 19:52** — **Marketplace Foundation graduated.** Phase 4 complete: 32 tests green. Track closed.
- **2026-06-27 17:10** — **CRM + Communication research dispatched.** 3 research agents + SDB deep dive.
- **2026-06-27 16:39** — **Business Portal Chapter 1 graduated.** 2 tracks merged. Confirmed on Saturn.
- **2026-06-27 16:33** — **Admin Panel Chapter 1 graduated.** 50 integration tests green. Confirmed on Saturn.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- ✅ ~~**No post-deploy verification.**~~ Resolved.
- ✅ ~~**Deploy path confusion.**~~ Resolved — `deploy-to-saturn.sh` with hash verification.
- ✅ ~~**Deploy missing dart-defines.**~~ Resolved — `DART_DEFINES` map in deploy script + AGENTS.md rules.
- ✅ ~~**No marketplace-level tests.**~~ Resolved — 32 tests (7 integration + 25 widget).

## 🧠 Session Memory

### Session 2026-06-27 23:34 — Research Review + Firebase Decision
- **User read all 4 research docs:** Noona CRM, CRM Architecture, Communication Architecture, SDB Message Bus Deep Dive
- **Decision: Firebase for SMS/email** — user already has Firebase project registered. Replaces Sveve + MailerSend recommendation from comms research.
- **SDB message bus deep dive delivered** — LIVE SELECT, DEFINE EVENT, Changefeeds, cross-namespace patterns, permissions. Plus runnable experiment script with Norwegian test data.
- **User digesting everything** — "finding a ground where to continue from" — multiple threads knotting together (CRM, messaging, Ditto/Datto, marketplace discovery)

### Session 2026-06-27 19:52 — Marketplace Foundation Phase 4 Closure (other conversation)
- 32 tests created (7 integration + 25 widget). Row→Wrap overflow fix. Track closed.
- Auth Service Phase 4 unblocked — consumer auth is live in marketplace

> 📦 Full history: `conductor/pulse-archive/2026-06-27-pre-graduations.md`

## 📋 Next Session Suggestions

1. 🔴 **Review Auth Service Phase 4** — consumer auth live in marketplace. Review and potentially graduate.
2. 🔴 **CRM `/grill` or `/new-track`** — 4 research docs digested. User ready to define the next domain track.
3. 🟡 **SDB message bus experiment** — run `sdb-message-bus-experiment.surql` against local SDB to validate patterns.
4. 🟡 **EstablishmentPage UI polish grill** — bento/showcase/spotlight distinct layouts.
5. 🟡 **Marketplace Discovery + Home** — next feature track (ADR-0020 anonymous browsing).
6. 🟢 **E2E checklist** — user working through 45 scenarios gradually.
7. 🟢 **Logo:** User is working on a logo — swap when ready.
