# User Profile Page - UI/UX & Architecture Audit

This document outlines the architectural makeup, component hierarchy, and UX patterns of the User Profile section in the `public-marketplace` application.

## 1. Page Structure & Layout

**Main Wrapper (`app/pages/profile.vue`)**
- **Architecture**: Acts as the parent shell, injecting authentication middleware (`definePageMeta({ middleware: "auth" })`).
- **UX Layout**: 
  - **Header**: Displays user avatar (`<UAvatar>`), name, and email.
  - **Navigation**:
    - **Desktop/Tablet**: A sticky left sidebar (`w-56` or `w-64`) with active state highlights and notification badges.
    - **Mobile**: A collapsible dropdown menu utilizing `<Transition>` for smooth height/opacity changes.
  - **Content Area**: Utilizes `<NuxtPage />` to render subpages dynamically.
- **Navigation Nodes**: Overview (`/profile`), Bookings, Notifications, Favorites, Settings.

---

## 2. Subpages (Features)

### Overview (`app/pages/profile/index.vue`)
- **Focus**: Dashboard-style snapshot of the user's schedule.
- **Key UI Elements**:
  - **Hero Card**: Highlights the immediate *next* appointment with a relative countdown (e.g., "in 2 hours"). Uses a green left border for emphasis and includes a quick cancel action.
  - **Upcoming List**: A compact list of the next upcoming bookings.
  - **Interactive Calendar**: A customized `<UCalendar>` component utilizing `<UChip>` to indicate days that have bookings. Clicking a day filters bookings for that specific date below the calendar.
- **State Management**: Drives data via the `useUserBookings()` composable.

### Bookings History (`app/pages/profile/bookings.vue`)
- **Focus**: Detailed view of all past and future bookings.
- **Key UI Elements**:
  - **Upcoming Section**: Renders `<BookingCard>` for future appointments.
  - **Past Section**: Includes a sophisticated **Date Range Filter** within a `<UPopover>`. It features quick presets (Last 7 days, Last 30 days, etc.) and a 2-month calendar range picker.
  - **Cancellation Flow**: Utilizes `<ProfileCancelModal>` to handle cancellations interactively.

### Notifications (`app/pages/profile/messages.vue`)
*(Note: Route is `/profile/messages` but UI primarily serves Notifications)*
- **Focus**: System alerts, booking reminders, and updates.
- **Key UI Elements**:
  - **Filtering**: Toggle between Active and Archived views.
  - **List**: Animated `<TransitionGroup>` for notification cards.
  - **Visuals**: Dynamic icons and colors based on notification `type` (e.g., green calendar for reminders, blue megaphone for broadcasts).
  - **Interactions**: Mark as read (on click), mark all read, archive/unarchive (hover actions).

### Favorites (`app/pages/profile/favorites.vue`)
- **Focus**: Grid layout of a user's saved businesses/stores.
- **Key UI Elements**:
  - **Cards**: Rich visual cards displaying cover images, overlapping logo badges, ratings, and city locations.
  - **Hover Effects**: Image scale-up, primary border highlights, and reveal of a top-right "Remove" button.
  - **Empty State**: Friendly CTA directing users to explore the marketplace.

### Settings (`app/pages/profile/settings.vue`)
- **Focus**: Account management and preferences.
- **Key UI Elements**:
  - Utilizes `<UCard>` to group settings into logical sections: Profile Details, Appearance, Notifications, Security, Danger Zone.
  - **Appearance**: Visual theme selector (Light, Dark, System) and integration with the custom **Solar Theme** (`useSolarTheme`), including a dynamic sun altitude indicator.
  - Uses reusable micro-components (`<ProfileSectionHeader>`, `<ProfileNotificationRow>`) for consistent typography and spacing.

---

## 3. Dedicated Components (`app/components/profile/*`)

- **`ProfileCancelModal.vue`**: 
  - Standardized cancellation flow.
  - **UX Intelligence**: Evaluates the `canCancel` prop. If false (e.g., cancellation deadline passed), it displays a blocking amber alert explaining the reason. If true, displays a standard red warning before confirming deletion.
- **`ProfileNotificationRow.vue`**: 
  - A layout primitive coupling a label and description with a `<USwitch>`, used extensively in the Settings page for toggle preferences.
- **`ProfileSectionHeader.vue`**: 
  - Ensures uniform section headers across settings cards, supporting a `danger` prop to highlight critical sections (like account deletion).

---

## 4. Composables (Business Logic & State)

- **`useUserBookings.ts`**: 
  - **Domain Logic**: Fetches standard bookings and table reservations (via Firestore `collectionGroup`), normalizing them into a single `Booking` interface so they can be rendered seamlessly side-by-side.
  - **Policy Enforcement**: Fetches business-specific `BookingPolicy` to determine if a user is allowed to cancel an appointment based on rules like `minCancelNoticeHours`.
- **`useUserThreads.ts`**: 
  - Prepares the groundwork for real-time messaging between users and businesses (Agent-ready configuration).
- **`useNotifications.ts`**, **`useFavorites.ts`**, & **`useSolarTheme.ts`**: Dedicated domain composables encapsulating Firebase operations and local UI state.

---

## 5. UX Critique & Recommendations

1. **Naming Inconsistency**: The route `/profile/messages` currently serves the Notifications UI. If a separate chat feature (using `useUserThreads`) is planned for real user-business communication, consider renaming this current route to `/profile/notifications` to avoid future collisions.
2. **Mobile Navigation**: The mobile menu toggle in `profile.vue` is functional, but as the app grows, consider integrating horizontal swipe gestures or a sticky bottom navigation bar on mobile for quicker switching between core tabs.
3. **Cancel Policy Handling**: The UI elegantly blocks cancellations if the deadline has passed (via `ProfileCancelModal`), providing a great user experience. However, a developer note indicates `firestore.rules` currently denies client-side writes to bookings entirely. Moving cancellation logic fully to the `MercuryEngine` backend API (as currently attempted via `fetchFromMercury`) is the correct architectural choice to enforce these policies securely.
4. **Empty States**: Empty states are well executed across the board (e.g., Favorites and Bookings), providing clear next actions ("Find Services", "Explore") rather than dead ends.