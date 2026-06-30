# Spec: Booking Flow UI

## Overview

Build the 5-step native booking flow for the Marketplace app, matching the Stitch design system screens. The flow launches from the EstablishmentPage "Book" button and guides the consumer through service selection → staff → date/time → review → payment.

**Step 1 uses real data** from House of the North (services + service groups via `EstablishmentDebugService`). Steps 2–3 use mock data (staff, time slots). Step 4 aggregates prior steps. Step 5 is a visual-only payment placeholder.

When MercuryEngine's availability engine ships, Step 3 will be wired to real slots. When the payment provider (Vipps) ships, Step 5 becomes functional and the full flow can create demo bookings.

## Stitch Design Reference

Design screens at `conductor/docs/assets/bookingslides/stitch_dittodatto_design_system/`:

| Step | Screen | Description |
|------|--------|-------------|
| 1 | `service_selection_step_1/screen.png` | Service groups with item counts, service cards (image + title + duration + price), checkboxes, sticky bottom bar (total + Continue) |
| 2 | `staff_selection_step_2/screen.png` | "No Preference" default, staff cards (avatar + name + title + rating), radio selection |
| 3 | `date_time_step_3/screen.png` | Calendar month view, available time slots (Morning/Afternoon groups), chip selection |
| 4 | `booking_overview_step_4/screen.png` | Summary cards (service, staff, date/time, location) with edit icons, optional note, payment summary (fee + taxes + total) |
| 5 | `payment_step_5/screen.png` | Total amount, card form (number/expiry/CVV/name), secure payment badge, "Pay X Kr" CTA |

## Functional Requirements

### Package Structure
- New shared package: `packages/booking_ui/`
- Consumed by `apps/marketplace/` initially, future-proofed for BP Bookings tab
- Depends on `packages/establishment_ui/` (for `Service`, `ServiceGroup`, `EstablishmentData` models)

### Step Progress Indicator
- 5-step horizontal stepper at top (matching Stitch: numbered circles with connecting lines)
- Labels: Service → Staff → Time → Review → Payment
- Completed steps show checkmark, active step is filled, future steps are greyed

### Step 1 — Service Selection
- **Real data** from `EstablishmentData.services` + `EstablishmentData.serviceGroups`
- Groups displayed with group name header + item count chip (e.g. "Hair Men — 3 items")
- Service cards: cover image (if available) + title + duration + price + checkbox
- **Multi-select logic:** Respects `ServiceGroup.multiSelect` flag per group. Groups with `multiSelect=false` allow only one service from that group (radio behavior). Groups with `multiSelect=true` allow multiple.
- Sticky bottom bar: running total price + "Continue" button (disabled until ≥1 service selected)
- Only groups with `showOnBookingPanel=true` appear

### Step 2 — Staff Selection
- "No Preference" option (default, always first, radio behavior)
- Staff cards: avatar (or initials fallback) + name + title + rating + review count
- **Mock data** — hardcode 2-3 staff members for demo
- Single selection (radio)
- "Continue to Time →" CTA

### Step 3 — Date & Time Selection
- Calendar month view (Material `TableCalendar` or custom)
- Past dates greyed out
- Selected date shows time slots grouped by Morning / Afternoon
- Time slot chips: 30-min intervals (matching `booking_policy.slot_interval`)
- **Mock data** — generate synthetic available slots for selected date
- "Review Booking" CTA (disabled until date + time selected)

### Step 4 — Review & Confirm
- Summary cards with edit pencil icons (tap goes back to the relevant step):
  - **Service:** title + duration + booking mode icon
  - **Professional:** name + title (or "Ingen preferanse")
  - **Date & Time:** formatted date + time range
  - **Location:** establishment name + address
- Optional note text field ("Legg til en melding")
- Payment summary: service fees + MVA (25%) + total in NOK
- "Proceed to Payment →" CTA

### Step 5 — Payment (Placeholder)
- Visual-only: renders the Stitch payment form layout
- All inputs disabled (Card Number, Expiry, CVV, Name on Card)
- "Secure Payment" badge
- **Disabled** "Pay X Kr" button with overlay message: **"Betaling kommer snart"**
- No form validation, no backend integration

### Navigation
- Back button on each step goes to previous step (or closes flow from Step 1)
- X button (top-right) closes entire flow with confirmation dialog if selections exist
- Step indicator allows tapping completed steps to navigate back

## Non-Functional Requirements

- Norwegian labels throughout (bokmål primary)
- Material 3 + Moody Blue brand tokens (from `ditto_design`)
- Smooth page transitions between steps
- Must work on Android phone (Galaxy S21 test device)

## Acceptance Criteria

1. Tapping "Book" on EstablishmentPage opens the booking flow
2. Step 1 displays real services/groups from House of the North
3. Multi-select respects per-group `multiSelect` flag
4. Running total updates as services are selected/deselected
5. All 5 steps are navigable forward and backward
6. Step 4 shows correct aggregate of all selections
7. Step 5 renders payment form layout with disabled state
8. Package tests cover step navigation, selection state, and price calculation

## Edge Cases & Constraints

- Establishment with zero services → "Book" button should not appear (already handled by EstablishmentPage)
- Services with `coverImage=null` → show placeholder or icon
- `ServiceGroup` with 0 active services → hide the group
- Very long service titles → truncate with ellipsis
- Price edge cases: free services (Kr 0.00), high prices, mixed currencies (only NOK for now)

## Dependencies

- `packages/establishment_ui/` — `Service`, `ServiceGroup`, `EstablishmentData` models (✅ exists)
- `packages/ditto_design/` — theme tokens, shared widgets (✅ exists)
- `EstablishmentDebugService` — real data pipe to Saturn (✅ exists)
- Auth Service — user must be logged in to book (✅ auth gate exists)

## Out of Scope

- Real availability engine (MercuryEngine — separate track)
- Staff model/CRUD in BP (future track)
- Payment provider integration (Vipps — future track)
- Writing bookings to the `booking` table (deferred until ME + payment)
- "My Bookings" tab content (separate track)
- Pre-selection from featured ServiceCard tap (noted, will be wired later)
- Booking confirmation emails/notifications
