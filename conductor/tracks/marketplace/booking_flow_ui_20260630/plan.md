# Plan: Booking Flow UI

## Phase 1 — Package Scaffold + Step Progress + Navigation Shell

- [x] Task: Create `packages/booking_ui/` package scaffold
    - [x] `pubspec.yaml` with dependencies on `establishment_ui`, `ditto_design`, `flutter`
    - [x] `lib/booking_ui.dart` barrel export
    - [x] `lib/src/` directory structure
- [x] Task: Build `BookingFlowPage` — the shell widget
    - [x] `PageView` or `IndexedStack` with 5 pages
    - [x] `BookingStepIndicator` — 5-step horizontal stepper (numbered circles + lines + labels)
    - [x] Forward/back navigation controller
    - [x] AppBar with back arrow + "Book Service" title + X close button
    - [x] Close confirmation dialog when selections exist
- [x] Task: Create `BookingState` model
    - [x] Selected services list (with running total)
    - [x] Selected staff (nullable)
    - [x] Selected date + time slot (nullable)
    - [x] Optional customer note
    - [x] Computed `totalPrice`, `totalDuration`, `taxAmount` (25% MVA)
- [x] Task: Write tests for BookingStepIndicator + BookingState
    - [x] Step indicator renders 5 steps with correct states (completed/active/future)
    - [x] BookingState price calculation with MVA
    - [x] BookingState multi-service total aggregation

## Phase 2 — Step 1: Service Selection (Real Data)

- [x] Task: Build `ServiceSelectionStep` widget
    - [x] Receives `List<Service>` + `List<ServiceGroup>` from EstablishmentData
    - [x] Groups services by `ServiceGroup`, filters by `showOnBookingPanel=true`
    - [x] Group headers: name + item count chip
    - [x] `BookingServiceCard` — image + title + duration + price + checkbox/radio
    - [x] Multi-select logic: per-group `multiSelect` flag (radio for single, checkbox for multi)
    - [x] Ungrouped services section (services with null groupId)
- [x] Task: Build sticky bottom bar
    - [x] Total price display (updates live)
    - [x] "Continue →" button (disabled until ≥1 service)
- [x] Task: Wire Step 1 to real data in Marketplace
    - [x] `BookingFlowPage` receives `EstablishmentData` from provider
    - [x] Route from EstablishmentPage "Book" button → booking flow
- [x] Task: Write tests for ServiceSelectionStep
    - [x] Renders service groups with correct item counts
    - [x] Checkbox selection updates running total
    - [x] Radio behavior for `multiSelect=false` groups
    - [x] Groups with 0 active services are hidden
    - [x] Bottom bar shows correct total + disabled state

## Phase 3 — Steps 2-3: Staff + Date/Time (Mock Data)

- [x] Task: Build `StaffSelectionStep` widget
    - [x] "No Preference" card (default selected, radio behavior)
    - [x] "OR CHOOSE SPECIFIC STAFF" divider
    - [x] `StaffCard` — avatar/initials + name + title + rating stars + review count
    - [x] Mock staff data (2-3 hardcoded entries)
    - [x] "Continue to Time →" CTA
- [x] Task: Build `DateTimeSelectionStep` widget
    - [x] Calendar month view (custom or `table_calendar` package)
    - [x] Past dates greyed out, today highlighted
    - [x] Month navigation (< / > arrows)
    - [x] Time slots section: "Available Times for {date}"
    - [x] Slots grouped by Morning / Afternoon
    - [x] Time chip selection (single select)
    - [x] Mock slot generator (30-min intervals, 09:00-16:00)
    - [x] "Review Booking" CTA (disabled until date + time selected)
- [x] Task: Write tests for Steps 2-3
    - [x] Staff selection defaults to "No Preference"
    - [x] Staff radio behavior (only one selected)
    - [x] Calendar renders current month
    - [x] Past dates are not selectable
    - [x] Slot selection enables continue button
    - [x] Mock slots generate correct Morning/Afternoon grouping

## Phase 4 — Steps 4-5: Review + Payment Placeholder

- [x] Task: Build `ReviewStep` widget
    - [x] Summary cards (service, professional, date/time, location) with edit icons
    - [x] Edit icon taps navigate back to the relevant step
    - [x] Optional note text field ("Legg til en melding")
    - [x] Payment summary card: service fee + MVA (25%) + total
    - [x] "Proceed to Payment →" CTA
- [x] Task: Build `PaymentPlaceholderStep` widget
    - [x] Total amount header
    - [x] Disabled card form fields (number, expiry, CVV, name)
    - [x] "Secure Payment" badge with lock icon
    - [x] Disabled "Pay X Kr" button
    - [x] "Betaling kommer snart" overlay/message
- [x] Task: Write tests for Steps 4-5
    - [x] Review step shows correct service/staff/time summary
    - [x] Edit icon navigation targets correct step
    - [x] MVA calculation (25%)
    - [x] Payment step renders disabled form
    - [x] "Betaling kommer snart" message visible

## Phase 5 — Verification + Deploy

- [/] Task: Integration testing
    - [/] Full flow navigation (Step 1 → 5 and back)
    - [/] Real data loads from House of the North
    - [/] Selection state persists across step navigation
- [ ] Task: Visual polish
    - [ ] Match Stitch design spacing, colors, typography
    - [ ] Smooth page transitions
    - [ ] Norwegian labels verified
- [/] Task: Deploy to phone
    - [/] `flutter run --release -d R5CR61FGVPN`
    - [ ] E2E walkthrough on Galaxy S21
