# Admin Panel Scope & Access Model

> **Recorded:** 2026-05-26 22:30
> **Status:** accepted
> **Resolves:** ADR-0005 open questions (all 4)
> **Refines:** ADR-0006 §4 (platform targets), §7 (auth flow), §2 (scope)

## Context

ADR-0006 defined the Flutter Admin Panel with 5 screens + Inbox stub, cross-platform targets (Android/iOS/Linux/Web), and an auth flow involving dev-login + Vipps + biometric re-auth. ADR-0005 left 4 open questions about admin tier security (BankID re-auth, device restrictions, impersonation, audit depth) deferred to `/grill admin-panel`.

The `/grill admin-panel` session (2026-05-26) resolved all open questions and tightened the scope based on a fundamental reframing: the Admin Panel is a **"breaker box"** — a 2-user private tool for platform infrastructure, not a multi-role management surface. Business relationship management (establishments, services, bookings) lives in the Business Portal, which Merkurial Studio itself dogfoods as a company on the platform.

## Decisions

### 1. Two-User Private Tool

The Admin Panel is exclusively for Arnar Valur (founder) and Höddi (team member). No other users. No public access. No multi-tenant admin workflows. This eliminates the need for role-based UI gating within the panel itself.

### 2. ADR-0005 Open Questions — All Resolved

| Question | Resolution | Rationale |
|----------|-----------|-----------|
| BankID re-auth for super-admin actions? | **No** | 2-user private tool; BankID overhead unjustified |
| Device restrictions for super-admin? | **No** | No iOS compilation, but no device-level access restrictions |
| Super-admin → operator impersonation? | **No** | Only 2 users; direct database access via Surrealist if needed |
| Audit log depth for admin/super-admin actions? | **Current level sufficient** | `audit_log` table in `companies/registry` is adequate for a 2-user tool |

### 3. Login — Maximum Opacity

Email + password + Sign In button only. Lock icon for visual identity. Moody Blue dark theme. **No text identifying the application** — no "DittoDatto Admin", no branding. No error feedback on failed login (wrong password produces no distinguishing visual response). Styled consistently with Material 3 dark theme.

### 4. Platform Targets — Android + Linux Desktop + Web

Same Flutter codebase compiles to all three. **No iOS compilation.** The web build will replace `panel.dittodatto.no` (current Nuxt admin) when ready. No separate webapp codebase — Flutter web IS the webapp.

### 5. Screen Scope — 5 + Inbox (v1.0 Locked)

| Screen | Purpose |
|--------|---------|
| Login | Lock icon + email + password + Sign In |
| Dashboard | Stat cards (users, companies, categories, engine health) |
| Users | Paginated table, role management |
| Companies | Paginated table, create/edit dialog (provisioning, tier management) |
| Categories | Full CRUD for platform-wide service taxonomy |
| Inbox | Within-platform messaging — feedback, support, notifications |

**Explicitly out of scope for Admin Panel:**

- Establishments, Services, Staff → Business Portal domain
- Booking oversight → Business Portal domain (privacy boundary: admin should not inspect company–customer bookings)
- Reviews, Media → future
- Search Analytics / Shadow Demand → separate project (`predict.dittodatto.no`)
- Settings → unnecessary for 2 users
- MasterDatto AI agent → future concept; Inbox is the human precursor

### 6. Responsive Shell — From Day One

`LayoutBuilder` + Material 3 adaptive navigation (`NavigationRail` on wide screens, `NavigationBar` or `Drawer` on narrow). Works on phone, tablet, desktop, browser. The old code's fixed 240px sidebar is replaced with a responsive shell.

### 7. Migration — Fresh Flutter Create

Clean `flutter create` at `apps/admin/`, port patterns and code from `DittoDatto-old/apps/admin/`. Version bump to Flutter 3.44 / Dart 3.12, all dependencies updated to latest stable.

## Consequences

- ADR-0005's 4 open questions are **resolved** (all "no" or "sufficient").
- ADR-0006 §4 (platform targets) is **refined**: no iOS.
- ADR-0006 §7 (auth flow) is **simplified** for Admin Panel: no Vipps OIDC, no biometric re-auth (those remain relevant for Business Portal and Marketplace).
- The "breaker box" framing establishes a clear domain boundary: Admin Panel = platform infrastructure ops. Business Portal = business relationship management (including Merkurial Studio's own usage).
- Responsive shell from day one eliminates the old tablet-locked assumption.
- Fresh Flutter create avoids inheriting stale dependencies and dead code from the pre-crash codebase.

---

*Origin: `/grill admin-panel` session 2026-05-26. Resolves ADR-0005 open questions; refines ADR-0006 scope, targets, and auth.*
