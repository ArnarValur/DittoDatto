# Plan: Communications & Notifications (Unified Track)

> **Merged from:** `notifications_mvp_20260217` + `messaging_service_20251229` (Archived-Cancelled)
> **Merged on:** 2026-02-18 by Captain's directive

## Captain's Decisions

- **User-scoped subcollection** `users/{uid}/notifications/` (not flat `activities`)
- **Broadcasts → pub-to-one** model: write one doc, composable subscribes (no fan-out writes)
- **Profile Messages page** is the UI home for notifications
- **Phase 1 only**: In-app, no FCM, no email
- **Existing schemas** in `shared-types/src/activity.ts` are the foundation
- **Email invitations** via Firebase Extension: `firestore-send-email` (firebase-maintained)

---

## 🏗️ Open Architectural Questions

> These MUST be answered before Phase 3+ work begins.

### 1. Notification Lifecycle & Storage

- Do we store **all** notifications permanently, or TTL/auto-prune after X days?
- Do we store what Stores are broadcasting to their favorites? (audit trail?)

### 2. Admin Escalation Pipeline

- Should notifications trickle all the way up to Admin Panel?
- Do we need a centralized logging/monitoring pipeline? (GCP Cloud Logging? Custom dashboard?)
- What triggers admin-level alerts? (e.g., high error rate, user reports, flagged content)

### 3. Feedback & Support System

- Can business owners send messages up the ladder to Arnar/Admin?
- Can Admin reply? (Thread model: `support_threads` collection?)
- Can registered users send feedback or report bugs from public marketplace?
- UI: Feedback form → creates support thread? Or just fires an email?

### 4. Business → Staff Communication

- Can business owners broadcast to their own staff? (Company-internal notifications/alerts)
- Staff party announcements? Shift change alerts?
- Collection path: `companies/{id}/announcements/` or reuse notifications?

### 5. Data Export & Compliance

- Can business owners export internal company/staff data? (CSV? PDF?)
- GDPR considerations for notification/message storage?

### 6. Cross-App Notification Routing

- How does the same user (customer on marketplace, staff on portal) see the right notifications?
- Are notifications app-scoped or universal? Current: universal (user-scoped), app filters by type.

---

## Phase 1: In-App Notification Feed ✅

### Task 1.1: Firestore Rules ✅

### Task 1.2: Cloud Function — Booking Notification Trigger ✅

### Task 1.3: Composable — `useNotifications.ts` ✅

### Task 1.4: UI — Profile Messages Page ✅

### Task 1.5: Notification Bell (Navbar) ✅

### Task 1.6: Archived Notifications Toggle ✅

---

## Phase 1.5: Business Portal Notifications ✅

### Task 1.5.1: Extend CF — Store Owner Notification ✅

### Task 1.5.2: Business Portal Composable ✅

### Task 1.5.3: NotificationsSlideover Rewrite ✅

### Task 1.5.4: Dashboard Bell Badge ✅

### Task 1.5.5: Cleanup ✅

---

## Phase 2: Staff Invite Notifications ✅

### Task 2.1: Diagnostic Logging on booking_received CF ✅

- Added branch logging for: missing companyId, null ownerId, self-booking, company not found
- Deployed 2026-02-17 ~22:30

### Task 2.2: Staff Invite → In-App Notification (Option B) ✅

- [x] Firestore trigger on `companies/{companyId}/staff/{staffId}` create → `on-staff-created.ts`
- [x] If user already exists (lookup by email), create notification at `users/{uid}/notifications/`
- [x] Type: `staff_invite` — "Du er invitert til {companyName}"
- [x] Owner notification on claim: `staff_claimed` added to `claim-invite.ts`

### Task 2.3: Staff Invite → Email (Option A) ✅

- [x] Install Firebase Extension: `firestore-send-email`
- [x] Configure SMTP: Google Workspace relay (`arnarvalur@avj.info` → `noreply@dittodatto.no`)
- [x] Create email template for staff invitations (inline HTML, Norwegian)
- [x] Trigger: write to `mail` collection when staff doc created
- [x] Email contains: company name, role, portal link, branded design

### Task 2.4: Verify booking_received notification ✅

- [x] Create test booking as anoupz (non-owner)
- [x] Check CF logs for diagnostic output
- [x] Confirm notification appears in business portal for owner (Arnar)
- Verified live 2026-02-18 ~19:48 — notification appeared "Akkurat nå" in both slideover and Messages page

---

## Phase 3: Email Templates & Transactional Emails ✅

### Task 3.1: Extension Installation ✅

- [x] Install `firebase/firestore-send-email` extension
- [x] Configure SMTP transport (Google Workspace SMTP relay)
- [x] Test with a manual `mail` collection write — delivered to inbox ✅
- [x] **Fixed SMTP relay 421 errors** — switched from `smtp-relay.gmail.com` to `smtp.gmail.com` with app password (2026-02-18)

### Task 3.2: Email Template System ✅

- [x] Created `emails/base-layout.ts` — shared DittoDatto brand wrapper (gradient header, dark body, CTA, footer)
- [x] Created `emails/staff-invite.ts` — purple scheme, "Du er invitert!"
- [x] Created `emails/booking-confirmed.ts` — green scheme, customer receipt with date/time/price/ref
- [x] Created `emails/booking-received.ts` — blue scheme, owner notification with customer info
- [x] Created `emails/index.ts` — barrel export

### Task 3.3: Transactional Email Integration ✅

- [x] `on-staff-created.ts` — now uses shared `renderStaffInviteEmail()` template
- [x] `notifications/index.ts` — booking confirmation email to customer + booking received email to owner
- [x] `MercuryEngine/booking.ts` — fetches real user data (name, email) from Auth + store name from Firestore
- [x] Fixed email URLs → `portal.dittodatto.no` / `dittodatto.no` (not raw Cloud Run URLs)
- [x] **All emails verified live** — staff invite, booking confirmed, booking received ✅

---

## Phase 3.5: Staff Invite Enhancements ✅

### Task 3.5.1: Auto-link existing users on invite ✅

- [x] Extended `on-staff-created.ts` — when invited user exists in Auth, auto-link:
  - Sets `userId`, `status: active`, `joinedAt` on staff doc
  - Adds `companyId` to user doc's `companyIds` array, sets `role: business`
  - Sets custom claims (`companyId`, `companyIds`, `role: business`)
- [x] Handles multi-company scenario (merges existing claims)
- [x] Notification copy changed: "Du er lagt til" (added) vs "Du er invitert" (invited)

### Task 3.5.2: Resend Invite ✅

- [x] `staff/resend-invite.ts` — callable CF (`staff_resendInvite`)
  - Auth guard: caller must be company owner
  - Status guard: staff must be `status: invited`
  - Re-queues email via `mail` collection using shared template
- [x] UI: "Resend Invite" button in `StaffFormSlideover.vue` footer
  - Visible only when editing staff with `status === 'invited'`
  - Loading state + success/error toast

### Task 3.5.3: Email Debugging Scripts ✅

- [x] `scripts/check-mail.ts` — reads delivery status of recent mail docs
- [x] `scripts/resend-failed.ts` — re-queues all ERROR state mail docs


---

## Phase 4: FCM Push Notifications (Future)

- [ ] FCM token registration on login
- [ ] Cloud Function sends push alongside in-app notification
- [ ] Notification preferences page (per-type opt-in/out)

---

## Phase 5: Messaging Threads Foundation ✅

### Task 5.1: Enhanced ThreadSchema ✅

- [x] `ThreadModeSchema` — agent / human / hybrid / disabled
- [x] Expanded `type`: booking_comment, inquiry, support, feedback
- [x] New fields: `mode`, `bookingId`, `subject`, `lastMessagePreview`, `unreadByUser`

### Task 5.2: useThreads Composable ✅

- [x] Real-time thread list (participantIds array-contains, status filter, ordered by lastMessageAt)
- [x] Active thread messages subscription with auto-mark-as-read
- [x] `sendMessage()` with per-user unread increment for other participants
- [x] `totalUnread` computed for badge display

### Task 5.3: useInboxHelpers Composable ✅

- [x] Modularized display utilities (icons, colors, labels, time formatting)
- [x] Handles Firestore Timestamps, Dates, and ISO strings

### Task 5.4: Portal Inbox Dual-Mode ✅

- [x] "Varsler" (Notifications) tab — fully preserved
- [x] "Samtaler" (Conversations) tab — thread list + message detail panel
- [x] Message bubbles with sender alignment, agent/human icons, relative timestamps
- [x] Reply input with Enter-to-send
- [x] Agent mode badges (Datto bot icon)

### Task 5.5: Booking Comment Threads (CF) ✅

- [x] `onBookingCreated` creates `booking_comment` thread when `booking.notes` exists
- [x] Customer + owner as participants, first message = customer's note
- [x] Owner notification links to thread via `context.threadId`
- [x] `mercury_createBooking` and `createBookingFromHold` pass through `notes` field

### Task 5.6: Booking Notes Input ✅

- [x] Optional notes `UTextarea` in `BookingSlideover` (flow view, placeholder "Valgfritt...")
- [x] Notes included in confirm emit → parent page → `confirmBooking()` API call

### Task 5.7: Firestore Rules & Indexes ✅

- [x] Composite index: threads (participantIds + status + lastMessageAt)
- [x] Composite index: messages (threadId + createdAt)
- [x] Rules: messages read/create requires thread participation

---

## Phase 5.5: Cancellation & Rebooking (Next — Pre-Agent)

- [ ] `onBookingUpdated` CF — notify other party on cancellation
- [ ] `CancellationPolicy` schema on store model (freeCancelHours threshold)
- [ ] Customer-side cancel from marketplace (with policy check)
- [ ] Store-side cancel with reason (auto-notify + full refund intent)

## Phase 6: Ditto AI Agent Integration (Future — Agent Sprint)

- [ ] Agent auto-response logic in threads (mode: agent)
- [ ] Rebooking conversations via Datto ("Your appointment was cancelled, want to rebook?")
- [ ] Inquiry threads from marketplace (pre-booking questions)
- [ ] Thread mode toggle in store settings
- [ ] Smart summary of unread, suggested replies, sentiment analysis

## Phase 7: Broadcasts (Future)

- [ ] Zero-fan-out broadcast architecture (store-scoped docs)
- [ ] `useBroadcasts` composable for favorited stores
- [ ] Rotating message ticker component

## Phase 8: Feedback & Support System (Future)

- [ ] Support thread model: `support_threads/{threadId}`
- [ ] Business → Admin escalation
- [ ] User → Admin feedback/bug reports
- [ ] Admin reply capability

