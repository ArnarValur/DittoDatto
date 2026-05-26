# Specification: Smart Activity Hub

> **Vision:** A card-based activity feed that serves as the user's "smart inbox" - showing bookings, events, broadcasts, support threads, and system notifications in a unified day-view timeline.

## Core Principles

1. **Domain-Driven Design** - Isolated, modular, decoupled from Nuxt apps
2. **AI-Ready** - Schema designed for Ditto/Datto agent integration (January)
3. **Card-Based** - Not chat bubbles, but actionable PostIt-style cards
4. **Timeline View** - Day-view calendar-like UI for "Today's" activity

---

## Card Types

| Type | Description | Actionable? | Source |
|------|-------------|-------------|--------|
| `booking_reminder` | Appointment today notification | View | System trigger |
| `booking_change` | Store needs to reschedule | Yes (respond) | Staff/Datto |
| `broadcast` | Promo from favorited store | Dismiss/Save | Company → Favorites |
| `staff_reply` | Response from store/support | Reply | Human staff |
| `feedback` | User-initiated platform feedback | Thread | User |
| `support` | User-initiated support request | Thread | User |
| `event_upcoming` | Event reminder (store event, platform event) | View | System trigger |
| `system_alert` | Platform announcements | Dismiss | Admin |

---

## Data Model

### Collection: `activities`
The main cards visible in the user's Activity Hub.

```typescript
ActivityTypeSchema = z.enum([
  'booking_reminder',
  'booking_change', 
  'broadcast',
  'staff_reply',
  'feedback',
  'support',
  'event_upcoming',
  'system_alert',
]);

ActivitySchema = z.object({
  id: IdSchema,
  recipientId: IdSchema,           // User who sees this card
  type: ActivityTypeSchema,
  
  // Display
  title: z.string(),
  body: z.string(),
  icon: z.string().optional(),     // e.g., 'i-lucide-calendar'
  
  // Context linking
  context: z.object({
    companyId: IdSchema.optional(),
    storeId: IdSchema.optional(),
    bookingId: IdSchema.optional(),
    eventId: IdSchema.optional(),
    threadId: IdSchema.optional(), // Links to messages collection
  }).optional(),
  
  // State
  isRead: z.boolean().default(false),
  isArchived: z.boolean().default(false),
  requiresAction: z.boolean().default(false),
  
  // AI readiness
  respondedBy: z.enum(['human', 'datto', 'system']).optional(),
  
  createdAt: TimestampSchema,
  expiresAt: TimestampSchema.optional(),
});
```

### Collection: `messages`
For threaded content (feedback, support, staff conversations).

```typescript
MessageSchema = z.object({
  id: IdSchema,
  threadId: IdSchema,              // Groups messages in a thread
  senderId: IdSchema,
  senderType: z.enum(['user', 'staff', 'admin', 'datto']),
  
  content: z.string().max(2000),
  attachments: z.array(z.string().url()).optional(),
  
  createdAt: TimestampSchema,
  editedAt: TimestampSchema.optional(),
});
```

### Collection: `broadcasts`
Company → Favorited Users promotions.

```typescript
BroadcastSchema = z.object({
  id: IdSchema,
  companyId: IdSchema,
  storeIds: z.array(IdSchema).optional(), // Specific stores or all
  
  title: z.string(),
  body: z.string(),
  imageUrl: z.string().url().optional(),
  
  // Targeting
  targetAudience: z.enum(['all_favorites', 'store_favorites']),
  
  // Stats
  recipientCount: z.number().default(0),
  
  createdAt: TimestampSchema,
  scheduledFor: TimestampSchema.optional(),
});
```

---

## Backend Functions

| Function | Description | MVP? |
|----------|-------------|------|
| `activity_create` | Create activity card for user | ✅ |
| `activity_markRead` | Mark card as read | ✅ |
| `activity_archive` | Archive card | ✅ |
| `message_send` | Send message in thread | ✅ |
| `broadcast_send` | Company sends to favorited users | ✅ |
| `datto_respond` | AI agent responds (stub) | TODO |

---

## Triggers

| Event | Creates Activity |
|-------|-----------------|
| Booking created (for today) | `booking_reminder` |
| Booking status changed | `booking_change` |
| Broadcast published | `broadcast` for each recipient |
| Staff replies to thread | `staff_reply` |
| Event approaching | `event_upcoming` |

---

## UI Locations

| App | Component |
|-----|-----------|
| **Public Marketplace** | `/messages` - User's Activity Hub (future) |
| **Business Portal** | NotificationsSlideover + sandbox demo page |
| **Admin Panel** | Support inbox + sandbox demo page |

---

## UI/UX Patterns

### Card Interaction
```
┌─────────────────────────────────┐
│ 📅 Booking Reminder       12:30 │  ← Card (collapsed)
│ Your haircut at Viking Barbers  │
└─────────────────────────────────┘
        ↓ (click to expand)
┌─────────────────────────────────┐
│ 📅 Booking Reminder       12:30 │
│ Your haircut at Viking Barbers  │
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ Staff: Hi! Just confirming  │ │  ← Nested thread
│ │ your appointment...         │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ You: Yes, I'll be there!    │ │
│ └─────────────────────────────┘ │
│ [ Type a reply...           📤 ]│
└─────────────────────────────────┘
```

### Viewport & Scroll
- **Fixed height:** Activity Hub fills Y viewport (no page scroll)
- **Infinite scroll:** Seamless load-more as user scrolls up (older) or down (newer)
- **Sticky header:** "Today", "Yesterday", date groupings
- **Pull to refresh:** Mobile-friendly refresh gesture

### States
| Visual | Meaning |
|--------|---------|
| **Bold title** | Unread |
| **Colored border** | Requires action (e.g., booking_change) |
| **Muted/gray** | Archived or expired |
| **Collapsed** | Default card view |
| **Expanded** | Shows thread content inline |

---

## AI Integration Notes (January)

- `respondedBy` field tracks human vs AI responses
- `senderType: 'datto'` for AI-generated messages
- Thread context provides Datto with full conversation history
- Activity Hub becomes Ditto's "window" into user's day

---

## Edge Cases & Corner Considerations

### Threading Model
| Scenario | Behavior |
|----------|----------|
| User opens support thread | Creates activity card + first message in `messages` |
| Staff replies | New message added to thread, new `staff_reply` activity for user |
| User replies back | Message added to thread (no new activity for user, but for staff?) |
| Thread closed | Activity marked `requiresAction: false`, thread archived |

### Activity Lifecycle
| State | Meaning |
|-------|---------|
| `isRead: false` | Unread card (bold/highlighted in UI) |
| `isRead: true` | User has seen it |
| `isArchived: true` | Hidden from main view, in "Archive" |
| `expiresAt` set | Auto-archive after date (e.g., booking_reminder next day) |

### Broadcast Limits
- **Rate limit:** Max 1 broadcast per company per day? (anti-spam)
- **Opt-out:** User can unfavorite store to stop receiving
- **Targeting:** `all_favorites` vs specific `store_favorites`

### Security Rules
| Collection | Read | Write |
|------------|------|-------|
| `activities` | `recipientId == auth.uid` | System only (via Functions) |
| `messages` | Participant in thread | Participant in thread |
| `broadcasts` | Company members + Admin | Company members + Admin |

### Who Can See What
| Actor | Can See |
|-------|---------|
| **User** | Their own activities, messages in their threads |
| **Business Staff** | Support/feedback threads for their company |
| **Admin** | All threads (for compliance), all broadcasts |

---

## Design Decisions

### 1. Activities vs Messages Split
Activities are the **cards** (UI surface). Messages are the **thread content** (deep dive). This allows:
- Fast activity feed queries (just cards)
- Lazy-load thread content only when user expands

### 2. Thread ID Generation
When user initiates `support` or `feedback`:
1. Create new document in `messages` with auto-ID as `threadId`
2. Create activity card with `context.threadId` pointing to it

### 3. Business Staff Activity
Should staff see an activity card when user sends support message?
- **Option A:** Yes, staff gets `support_request` card in their hub
- **Option B:** No, staff views via dedicated "Support" page
- **Decision:** TBD - test with demo pages

### 4. Booking → Activity Card Timing
- `booking_reminder`: Created morning-of (8am?) or at booking creation?
- **Decision:** Create at booking time with `expiresAt` = end of day

### 5. Real-time Updates
- Activities and messages use Firestore listeners for real-time
- No WebSocket needed, Firestore handles it

---

## Open Questions (For Testing)

1. ~~When staff replies, does user get new `staff_reply` card, or does existing card update?~~
   - **Resolved:** Thread expands inline, nested collapse/expand creates "messaging" feel

2. ~~Thread pagination: Load last N messages, then "load more"?~~  
   - **Resolved:** Infinite scroll, fixed viewport height, seamless scroll up/down

3. Notification badge count: Unread activities only, or unread + requiresAction?
   - **Pending:** Options:
     - A) Count of unread only
     - B) Count of unread + requiresAction
     - C) Separate indicators (number + dot)

4. Archive: Soft delete or separate UI view?
   - **Pending:** User is thinking about this...


