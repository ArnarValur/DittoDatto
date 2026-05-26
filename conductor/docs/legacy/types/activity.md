---
schema: ActivitySchema, ThreadSchema, MessageSchema, BroadcastSchema
domain_term: Activity / Thread / Message / Broadcast
firestore_path: activities/{activityId}, threads/{threadId}, threads/{threadId}/messages/{messageId}, broadcasts/{broadcastId}
status: active
version: v1.0
related: [user, company, store, booking, event]
noona_equivalent: Notifications + Messaging
tags: [comms, v1.4]
---

# Activity & Communications System

Smart card-based notification and messaging system. Four interconnected schemas handle all platform communications: Activity cards (notifications), Threads (conversations), Messages (individual messages), and Broadcasts (business promotions).

## Activity

A notification card in the user's Activity Hub.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `recipientId` | `string` | ✅ | User who sees this card |
| `type` | `enum` | ✅ | Card type (see below) |
| `title` | `string` | ✅ | Card title (1–200 chars) |
| `body` | `string` | ✅ | Card body (max 1000 chars) |
| `icon` | `string` | ❌ | Icon name (e.g., `"i-lucide-calendar"`) |
| `context` | `object` | ❌ | Links: `companyId`, `storeId`, `bookingId`, `eventId`, `threadId` |
| `isRead` | `boolean` | ✅ | Default: `false` |
| `isArchived` | `boolean` | ✅ | Default: `false` |
| `requiresAction` | `boolean` | ✅ | Whether user action is needed. Default: `false` |
| `respondedBy` | `enum: human, datto, system` | ❌ | Who handled the response (AI tracking) |
| `createdAt` | `Timestamp` | ✅ | Creation timestamp |
| `expiresAt` | `Timestamp` | ❌ | Auto-expire timestamp |

### Activity Types

| Type | Description |
|------|-------------|
| `booking_reminder` | Appointment today |
| `booking_change` | Store needs to reschedule (actionable) |
| `broadcast` | Promotion from favorited store |
| `staff_invite` | Invited to join a company |
| `staff_claimed` | Staff invite was claimed |
| `staff_reply` | Response from store/support |
| `feedback` | User-initiated feedback |
| `support` | User-initiated support request |
| `event_upcoming` | Event reminder |
| `system_alert` | Platform announcement |

## Thread

Metadata for a conversation thread. Agent-ready with mode control.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `type` | `enum: booking_comment, inquiry, support, feedback` | ✅ | Thread type |
| `mode` | `enum: agent, human, hybrid, disabled` | ✅ | Who responds. Default: `"human"` |
| `participantIds` | `string[]` | ✅ | User IDs in this conversation |
| `companyId` | `string` | ❌ | Company context |
| `storeId` | `string` | ❌ | Store context |
| `bookingId` | `string` | ❌ | Related booking |
| `subject` | `string` | ❌ | Thread subject (max 200 chars) |
| `lastMessagePreview` | `string` | ❌ | Preview text (max 100 chars) |
| `unreadByUser` | `Record<userId, count>` | ❌ | Per-user unread counts |
| `status` | `enum: open, closed, archived` | ✅ | Default: `"open"` |
| `lastMessageAt` | `Timestamp` | ✅ | Latest message time |
| `lastMessageBy` | `string` | ✅ | Who sent the last message |
| `createdAt` | `Timestamp` | ✅ | Creation timestamp |

### Thread Mode (Agent Integration)

| Mode | Description |
|------|-------------|
| `agent` | Ditto/Datto handles all responses |
| `human` | Staff responds manually |
| `hybrid` | Agent responds first, escalates to human |
| `disabled` | Thread closed for responses |

## Message

Individual message in a thread.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `threadId` | `string` | ✅ | Parent thread |
| `senderId` | `string` | ✅ | Sender user ID |
| `senderType` | `enum: user, staff, admin, datto` | ✅ | Who sent it |
| `content` | `string` | ✅ | Message text (1–2000 chars) |
| `attachments` | `string[]` | ❌ | Attachment URLs |
| `createdAt` | `Timestamp` | ✅ | Send timestamp |
| `editedAt` | `Timestamp` | ❌ | Edit timestamp |

## Broadcast

Company-to-users promotional message.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `companyId` | `string` | ✅ | Sending company |
| `storeIds` | `string[]` | ❌ | Target specific stores (or all) |
| `title` | `string` | ✅ | Broadcast title |
| `body` | `string` | ✅ | Broadcast body |
| `imageUrl` | `string (url)` | ❌ | Promo image |
| `targetAudience` | `enum: all_favorites, store_favorites` | ✅ | Who receives it |
| `recipientCount` | `number (int)` | ✅ | How many received. Default: `0` |
| `createdAt` | `Timestamp` | ✅ | Send timestamp |
| `scheduledFor` | `Timestamp` | ❌ | Delayed send time |

## Design Notes

- **Thread.mode** is the foundation for Ditto↔Datto communication (v1.4/v1.5). The schema is agent-ready today even though v1.0 only uses `"human"` mode.
- **`respondedBy`** on Activity tracks whether a response came from a human, Datto agent, or system. Essential for measuring AI effectiveness later.
- **`senderType: "datto"`** on Message distinguishes AI-generated responses from human ones. The UI can style these differently.
- **Broadcasts** target users who favorited the business — opt-in by nature. No spam.
- **`unreadByUser`** is a per-user counter map. Avoids per-user sub-documents for unread tracking.
