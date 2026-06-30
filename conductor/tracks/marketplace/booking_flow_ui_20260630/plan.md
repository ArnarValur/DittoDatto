# Plan: Booking Flow UI

## Phase 1 — Package Scaffold + Step Progress + Navigation Shell

- [ ] Task: Create `packages/booking_ui/` package scaffold
    - [ ] `pubspec.yaml` with dependencies on `establishment_ui`, `ditto_design`, `flutter`
    - [ ] `lib/booking_ui.dart` barrel export
    - [ ] `lib/src/` directory structure
- [ ] Task: Build `BookingFlowPage` — the shell widget
    - [ ] `PageView` or `IndexedStack` with 5 pages
    - [ ] `BookingStepIndicator` — 5-step horizontal stepper (numbered circles + lines + labels)
    - [ ] Forward/back navigation controller
    - [ ] AppBar with back arrow + "Book Service" title + X close button
    - [ ] Close confirmation dialog when selections exist
- [ ] Task: Create `BookingState` model
    - [ ] Selected services list (with running total)
    - [ ] Selected staff (nullable)
    - [ ] Selected date + time slot (nullable)
    - [ ] Optional customer note
    - [ ] Computed `totalPrice`, `totalDuration`, `taxAmount` (25% MVA)
- [ ] Task: Write tests for BookingStepIndicator + BookingState
    - [ ] Step indicator renders 5 steps with correct states (completed/active/future)
    - [ ] BookingState price calculation with MVA
    - [ ] BookingState multi-service total aggregation

## Phase 2 — Step 1: Service Selection (Real Data)

- [ ] Task: Build `ServiceSelectionStep` widget
    - [ ] Receives `List<Service>` + `List<ServiceGroup>` from EstablishmentData
    - [ ] Groups services by `ServiceGroup`, filters by `showOnBookingPanel=true`
    - [ ] Group headers: name + item count chip
    - [ ] `BookingServiceCard` — image + title + duration + price + checkbox/radio
    - [ ] Multi-select logic: per-group `multiSelect` flag (radio for single, checkbox for multi)
    - [ ] Ungrouped services section (services with null groupId)
- [ ] Task: Build sticky bottom bar
    - [ ] Total price display (updates live)
    - [ ] "Continue →" button (disabled until ≥1 service)
- [ ] Task: Wire Step 1 to real data in Marketplace
    - [ ] `BookingFlowPage` receives `EstablishmentData` from provider
    - [ ] Route from EstablishmentPage "Book" button → booking flow
- [ ] Task: Write tests for ServiceSelectionStep
    - [ ] Renders service groups with correct item counts
    - [ ] Checkbox selection updates running total
    - [ ] Radio behavior for `multiSelect=false` groups
    - [ ] Groups with 0 active services are hidden
    - [ ] Bottom bar shows correct total + disabled state

## Phase 3 — Steps 2-3: Staff + Date/Time (Mock Data)

- [ ] Task: Build `StaffSelectionStep` widget
    - [ ] "No Preference" card (default selected, radio behavior)
    - [ ] "OR CHOOSE SPECIFIC STAFF" divider
    - [ ] `StaffCard` — avatar/initials + name + title + rating stars + review count
    - [ ] Mock staff data (2-3 hardcoded entries)
    - [ ] "Continue to Time →" CTA
- [ ] Task: Build `DateTimeSelectionStep` widget
    - [ ] Calendar month view (custom or `table_calendar` package)
    - [ ] Past dates greyed out, today highlighted
    - [ ] Month navigation (< / > arrows)
    - [ ] Time slots section: "Available Times for {date}"
    - [ ] Slots grouped by Morning / Afternoon
    - [ ] Time chip selection (single select)
    - [ ] Mock slot generator (30-min intervals, 09:00-16:00)
    - [ ] "Review Booking" CTA (disabled until date + time selected)
- [ ] Task: Write tests for Steps 2-3
    - [ ] Staff selection defaults to "No Preference"
    - [ ] Staff radio behavior (only one selected)
    - [ ] Calendar renders current month
    - [ ] Past dates are not selectable
    - [ ] Slot selection enables continue button
    - [ ] Mock slots generate correct Morning/Afternoon grouping

## Phase 4 — Steps 4-5: Review + Payment Placeholder

- [ ] Task: Build `ReviewStep` widget
    - [ ] Summary cards (service, professional, date/time, location) with edit icons
    - [ ] Edit icon taps navigate back to the relevant step
    - [ ] Optional note text field ("Legg til en melding")
    - [ ] Payment summary card: service fee + MVA (25%) + total
    - [ ] "Proceed to Payment →" CTA
- [ ] Task: Build `PaymentPlaceholderStep` widget
    - [ ] Total amount header
    - [ ] Disabled card form fields (number, expiry, CVV, name)
    - [ ] "Secure Payment" badge with lock icon
    - [ ] Disabled "Pay X Kr" button
    - [ ] "Betaling kommer snart" overlay/message
- [ ] Task: Write tests for Steps 4-5
    - [ ] Review step shows correct service/staff/time summary
    - [ ] Edit icon navigation targets correct step
    - [ ] MVA calculation (25%)
    - [ ] Payment step renders disabled form
    - [ ] "Betaling kommer snart" message visible

## Phase 5 — Verification + Deploy

- [ ] Task: Integration testing
    - [ ] Full flow navigation (Step 1 → 5 and back)
    - [ ] Real data loads from House of the North
    - [ ] Selection state persists across step navigation
- [ ] Task: Visual polish
    - [ ] Match Stitch design spacing, colors, typography
    - [ ] Smooth page transitions
    - [ ] Norwegian labels verified
- [ ] Task: Deploy to phone
    - [ ] `flutter run --release -d R5CR61FGVPN`
    - [ ] E2E walkthrough on Galaxy S21
