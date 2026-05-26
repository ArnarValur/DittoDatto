# Communications & Notifications System Audit
*Between Public Marketplace and Business Portal*

This document provides an architectural teardown, audit, and improvement roadmap for the real-time communications and notification pipelines connecting the `public-marketplace` and `business-portal`.

---

## 1. Architectural Overview

The system is built on Firebase Firestore utilizing two distinct pipelines:
1. **Asynchronous System Alerts:** User-scoped **Notifications** (`users/{uid}/notifications`).
2. **Real-time Chat / Support:** Top-level **Threads & Messages** (`threads/` and `messages/`).

Both pipelines utilize Vuefire and direct Firestore Snapshot listeners for real-time reactivity. The current implementation represents a "Phase 1: In-App Only" design, prioritizing rapid delivery over background/offline capabilities (like Push/Email).

---

## 2. Notification System

### Data Structure & Sourcing
- **Location:** `users/{uid}/notifications/`
- Both `business-portal` and `public-marketplace` utilize almost identical composables (`useNotifications.ts`) to listen to this subcollection.
- **Schema:** Contains `id`, `type`, `title`, `body`, `icon`, `isRead`, `isArchived`, and a `context` map (`bookingId`, `companyId`, `storeId`, `threadId`).

### Application Implementations
- **Public Marketplace:** Rendered as a full page list (`/profile/messages` route). Allows toggling between active/archived.
- **Business Portal:** Rendered globally as a `<NotificationsSlideover>`. Designed for quick peripheral checks without interrupting workflow.

### Audit Insights
1. **Unified Pipeline:** Because the Business Portal listens to `users/{uid}/notifications`, notifications for a staff member/business owner are tied to their *personal UID*, not an isolated company inbox. While efficient, this means notifications across multiple companies an owner manages are pooled together. 
2. **Route Naming (Public):** The public route is named `/profile/messages` but actually powers the Notification feed. This will inevitably collide when the Thread/Chat UI is built. 

---

## 3. Real-Time Messaging (Threads)

### Data Structure & Sourcing
- **Location:** `threads/` (Top-level collection) and `messages/` (Top-level collection).
- **Security Context:** Threads use a `participantIds` array containing the UIDs of the customer and the staff members. Access is controlled via array-contains queries.
- **Agent-Ready Design:** The metadata explicitly supports AI handoffs. Threads have a `mode` concept (human → hybrid → agent/datto) dictating who responds.

### Application Implementations
- **Public Marketplace:** `useUserThreads.ts` – Sends messages hardcoded as `senderType: 'user'`.
- **Business Portal:** `useThreads.ts` – Sends messages hardcoded as `senderType: 'staff'`.
- **Unread Counting:** Both composables fetch the parent Thread document, iterate through `participantIds`, and increment an `unreadByUser` map for the *other* participants whenever a message is sent.

### Audit Insights
1. **Lack of Message Pagination:** The query fetching messages inside a thread (`query(..., orderBy('createdAt', 'asc'))`) lacks a `limit()`. A long support thread will fetch hundreds of documents immediately, degrading performance and increasing Firestore read costs.
2. **Client-Side Fan-out (Critical Issue):** When sending a message, the client app manually fetches the thread, calculates the new unread counts, and updates the thread metadata (`lastMessageAt`, `lastMessagePreview`, `unreadByUser`). This is a security and concurrency risk:
   - **Race Conditions:** Two users typing at once will overwrite each other's thread metadata updates.
   - **Security:** Requires Firestore rules to grant clients broad update permissions on the Thread document.

---

## 4. Proposed Improvements & Next Steps

### Immediate Fixes (UI & Architecture)
- **Rename Public Route:** Change the public marketplace route `/profile/messages.vue` to `/profile/notifications.vue` to reserve space for the actual chat interface.
- **Implement Message Pagination:** Add a `limit(50)` to the active thread message queries in both `useThreads.ts` composables. Implement an IntersectionObserver to load previous messages when scrolling up.
- **Workspace Filtering for Business Portal:** In the Business Portal `useNotifications.ts`, apply a client-side filter (or update the query) to only show notifications where `context.companyId` matches the currently active workspace, preventing cross-company notification bleeding.

### Backend Offloading (Cloud Functions)
- **Move Thread Metadata to Backend:** Refactor the `sendMessage` function. The client should **only** write to the `messages` collection. A Firebase Cloud Function (triggered by `onDocumentCreated` in `messages/{messageId}`) should handle updating the parent thread's `lastMessageAt`, `lastMessagePreview`, and atomic incrementing of `unreadByUser`.
- **Notification Triggers:** Currently, notifications are assumed to be injected directly. Create standard Cloud Functions that listen to booking state changes (e.g., `onBookingCreated`) and automatically fan out notification documents to the relevant `users/{uid}/notifications/` paths.

### Expanding the Communications Pipeline (Phase 2)
- **FCM (Firebase Cloud Messaging):** Integrate FCM to convert critical `system_alert` or `booking_change` notifications into push notifications for mobile/PWA users.
- **Agent Handoff Engine:** Build a backend listener for threads where `mode == 'agent'`. When a user writes a message to an agent-managed thread, the backend intercepts it, invokes the AI Logic, and writes the response back as `senderType: 'datto'`.