# Plan: Smart Activity Hub MVP

## Phase 1: Data Foundation
*Goal: Schema and collections setup*

- [x] **Task 1.1:** Create `packages/shared-types/src/activity.ts`
  - ActivityTypeSchema, ActivitySchema
  - MessageSchema  
  - BroadcastSchema
- [x] **Task 1.2:** Export from `packages/shared-types/index.ts`
- [x] **Task 1.3:** Add Firestore rules for `activities`, `messages`, `threads`, `broadcasts`

---

## Phase 2: Backend Logic
*Goal: Cloud Functions for core operations*

- [ ] **Task 2.1:** Create `firebase/functions/src/services/activity/` module
- [ ] **Task 2.2:** Implement `activity_create` callable
- [ ] **Task 2.3:** Implement `activity_markRead` and `activity_archive`
- [ ] **Task 2.4:** Implement `message_send` for threaded replies
- [ ] **Task 2.5:** Implement `broadcast_send` (Company → Favorites)

---

## Phase 3: Triggers
*Goal: System-generated activity cards*

- [ ] **Task 3.1:** Booking trigger → `booking_reminder` card (same-day)
- [ ] **Task 3.2:** Booking status change → `booking_change` card
- [ ] **Task 3.3:** Broadcast publish → Create cards for recipients

---

## Phase 4: Demo Testing Pages
*Goal: Test connection between Business Portal (Haru) ↔ Admin Panel (Super Admin)*

- [x] **Task 4.1:** Create `admin-panel/pages/sandbox/activity-hub.vue` - Admin demo page
- [x] **Task 4.2:** Create `business-portal/pages/sandbox/activity-hub.vue` - Business demo page
- [ ] **Task 4.3:** Test support thread: Business Owner → Admin
- [ ] **Task 4.4:** Test reply flow: Admin → Business Owner
- [ ] **Task 4.5:** Test card types: booking_reminder, broadcast, etc.

---

## Phase 5: Business Portal Integration
*Goal: Quick access via NotificationsSlideover*

- [ ] **Task 5.1:** Adapt NotificationsSlideover for Today's cards
- [ ] **Task 5.2:** Link to full activity when appropriate

---

## Future (Post-MVP)

- [ ] Public Marketplace: User's Activity Hub page
- [ ] Admin Panel: Support/Feedback inbox (full UI)
- [ ] FCM push notifications
- [ ] Datto AI integration (January)
- [ ] Event cards integration
