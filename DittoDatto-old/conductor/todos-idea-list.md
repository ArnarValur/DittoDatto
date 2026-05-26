# Ideas & Todos Backlog

A space for quick ideas, thoughts, and potential features that don't yet warrant a full track.

**Last Updated:** 2026-05-05

---

## 💡 Ideas

### 1. Tag System
> Ideas using tags for helping bridge Owners' intentions and organizations with Datto. Tags could serve as a semantic layer that Datto understands to better assist owners in organizing, filtering, and managing their business entities.
>
> **Chapter 2 note:** Tags can be SurrealDB graph edges — natural fit for `RELATE` queries.

### 2. DattoBar Global Integration
> Make the DattoBar global within **Business Portal** and **Admin Panel**. The super-admin (Lead Dev) will also have Datto as a personal digital assistant (PDA) — demonstrating product usage internally for organizing, managing bookings, sending invitations, etc. "Eat your own dog food" approach.
>
> **Chapter 2 note:** Depends on Datto agent (v1.5 roadmap). Flutter or web TBD.

### 3. Timetable System ⭐ PRIORITY
> **Current state:** Timeslot settings are buried in store settings.
> **Proposed:** Dedicated "Timetable" page linked from sidebar (between Staff and Bookings).
>
> **Key concepts:**
> - Store timetables are the "parent" — one level above staff timetables in hierarchy
> - Per-store basis: 2 stores = 2 timetables (can be synced if desired)
> - Gives owners a clear view and control over store operating hours
> - Foundation for Datto to help manage hours and coordinate with staff
>
> **Chapter 2 note:** Backend support exists in MercuryEngine V2 via establishment open_hours model. UI in Flutter.

### ~~4. Service Creation & Store Linking~~ ✅ RESOLVED
> **Fixed:** 2026-02-17 — Chapter 1 (Nuxt) bug resolved.

### 5. Admin Panel Resource Management
> If Company is removed that has a User, the User needs rights revoked before removing the Company. If Company has Stores, Stores need to be resolved before that. Currently there is no deletion warning or protocols.
>
> **Chapter 2 note:** Relevant for V2 — implement as MercuryEngine cascade-delete or soft-delete guard.

### 6. Cancellation & Rebooking Policy Engine — PARTIALLY DONE ✅
> **Engine-level:** Cancellation policy enforcement is DONE (MercuryEngine V2, per-establishment, 4 controls).
> **Still needed:** Rebook endpoint (atomic cancel-old + hold-new), waitlist, reschedule enforcement.
> **Dependencies:** Vipps integration (for actual refunds).

### 7. Notification Preferences & Lifecycle
> **Open questions:**
> - TTL/auto-prune notifications after X days? Or permanent?
> - Per-type opt-in/out settings page?
> - Cross-app routing (same user as customer + staff)?
> - Admin escalation pipeline?

---

## 📝 Quick Todos

<!-- Small tasks that don't belong to any track -->

- [x] ~~**Messaging Service Planning:** Specs are available, need to refine and finalize the plan.~~ → Absorbed into comms track Phase 5, live-tested 2026-02-18
- [ ] **Booking lifecycle notifications** — Notify the other party when a booking is cancelled/completed/no-showed (MercuryEngine route, not CF)
- [ ] **Customer-side cancel** — Cancel button in Flutter marketplace (with policy check)
- [ ] **English email templates** — Currently Norwegian-only; add i18n based on user language preference
- [ ] **Search event geolocation** — IP-based city/country lookup in search route (server-side, zero UX impact)

---

## 🔮 Future Considerations

<!-- Long-term vision items or "someday/maybe" thoughts -->

- **Vipps MobilePay integration** — Required for real payment + refund logic in cancellation flows
- **SurrealDB graph analytics** — Business insights dashboards via graph aggregation queries
- **Ditto/Datto agents** — v1.5 roadmap, Google ADK, Saturn-powered

---

*Updated for Chapter 2 — 2026-05-05*
