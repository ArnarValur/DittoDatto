# Product Requirements — Business Portal v1.0

> **Created:** 2026-06-08
> **Version:** 1.0
> **Surface:** Business Portal (`apps/business-portal/`)
> **Domain:** Merchant Operations & Booking Management

---

## 1. Overview

The Business Portal is the primary operator surface for merchants using DittoDatto. It empowers service businesses, restaurants, and venues to manage their day-to-day operations, including staff rotas, service menus, real-time client booking streams, resource allocation, and direct messaging.

- **Stack:** Flutter (Dart), Riverpod, GoRouter, `ditto_design`
- **Targets:** Web, Linux desktop, Android, iOS (future)
- **Design System:** `packages/ditto_design/` (`DittoDashboardShell`, tokens)

---

## 2. Bounded Context & Scope

### 2.1 In Scope (v1.0)

#### Screens and Capabilities

| Component / Screen | Capabilities |
|--------------------|--------------|
| **Login / Auth** | Native OIDC-based login via Vipps, direct-to-database token session initialization scoped to the user's `company_slug` (tenant isolation). |
| **Appointments (Service-Based)** | Vertical calendar timeline where columns represent active `StaffMember`s and rows represent timeslots. Features inline booking status management. |
| **Table Reservations (Resource-Based)** | Horizontal timeline grid plotting physical `Resource`s (e.g. Tables/Rooms) as rows against a horizontal time scale. Supports collapsible room categories. |
| **Establishment Management** | Settings configuration for physical locations. Integrates `flutter_map` (OpenStreetMap) for location pinpointing and the free Nominatim REST API for address-to-coordinate geocoding. |
| **Staff Management** | Managing company employees, invitations, and soft-deletes (`status: archived`). Fine-grained authorization via `StaffCapability` array attributes stored directly on the `works_at` graph edge. |
| **Services Menu** | CRUD operations for Services and ServiceGroups. Supports duration rules, custom pricing tiers, and assignment matrices mapping services to staff. |
| **Inbox & Messaging** | Real-time thread-based communication between merchant (Datto) and customer (Ditto), driven by SurrealDB Live Queries (WebSockets). Includes diagnostic sandbox alert simulator. |

#### Navigation & Core Shell

- **UI Shell:** Extension of `DittoDashboardShell` from the shared `ditto_design` system. Dynamically displays a permanent navigation sidebar on wide viewports (Expanded) and transitions to a responsive bottom navigation bar / drawer on small viewports (Compact).
- **Responsive Adaptation:** Navigation options dynamically adapt based on active services (e.g., hiding the Table Reservations view if the establishment does not offer restaurant/table booking modes).

---

## 2.2 Out of Scope

| Item | Bounded Context / Rationale | Target Surface |
|------|-----------------------------|----------------|
| Platform-wide User Moderation | Belongs to administrative operations | Admin Panel |
| Company Database Provisioning | Belongs to administrative operations | Admin Panel |
| System Taxonomy CRUD | Belongs to administrative operations | Admin Panel |
| Public Search Projections | Handled automatically by database triggers/events | N/A |
| Offline Mutation Queueing | Real-time only WebSocket constraints | N/A |

---

## 3. Non-Functional Requirements

- **Real-Time Synchronization:** Replaces legacy Firestore listeners with native SurrealDB Live Queries over WebSocket connections for instant screen updates.
- **Network Resilience:** The UI must display a prominent connection-loss warning if the WebSocket drops, automatically attempt reconnection, and lock all mutation forms while disconnected.
- **Performance:** Complex layout loads (such as the Appointments grid and Reservations timeline) must compile and render smoothly at 60fps on mobile and web viewports.
- **Accessibility:** Fully WCAG 2.1 AA compliant. High contrast support, custom accessibility semantics, and keyboard navigation.

---

## 4. Bounded Context & Data Models

- **DB Tenant Routing:** On successful login, the client executes `USE NS companies DB company_{slug};` to guarantee multi-tenant security.
- **String References:** Links between the `users` namespace and the tenant database use plain string references (`user_id`) to allow clean database exports.
- **Capabilities Matrix:** Granular capabilities (`StaffCapability`) are stored directly on the `works_at` edge for location-specific permission checks.
