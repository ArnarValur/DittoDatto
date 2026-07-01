# Spec: BP Establishment Configuration

> **Track:** `bp_establishment_config_20260701`
> **Type:** feature
> **Domain:** business-portal (🔴 Tread Carefully)
> **Grilled:** 2026-07-01 — ADR-0027, ADR-0028, ADR-0029

---

## Overview

The BP establishment edit view currently handles identity/branding/location/contact/publish-toggle — but **zero** booking/scheduling configuration. The SurrealDB schema defines 6 major config blocks (33 fields) that are completely absent from both the Dart model and the BP edit UI:

- `opening_schedule` (per-weekday open/close) — full gap
- `booking_policy` (9 subfields) — full gap
- `social_links` (currently FB/IG/X, migrating to flexible array) — full gap
- `booking_form_type` → removed, superseded by `establishment_type` (ADR-0027)
- `reservation_config` (10 subfields, restaurant-only) — full gap
- `timezone` — full gap

This track closes the entire gap: schema migration + Dart model + BP edit UI + Marketplace display.

---

## Functional Requirements

### F1: Schema Migration
- Rename `store_type` → `establishment_type` with values `shop`/`restaurant`/`venue` (ADR-0027)
- Remove `booking_form_type` (superseded by `establishment_type`; ADR-0027)
- Redefine `social_links` from 3 hardcoded fields to `array<object>` with `platform` + `url` (ADR-0028)
- Update `large_party_handling` enum: `notify`/`email`/`call`/`form`/`disabled`, default `notify` (ADR-0029)
- Update `discovery.surql` field `store_type` → `establishment_type` on `establishment_listing`

### F2: Dart Model Layer
- Add to `Establishment` model: `establishmentType`, `openingSchedule`, `timezone`, `bookingPolicy`, `socialLinks`, `reservationConfig`
- Create model classes: `OpeningDay`, `BookingPolicy`, `SocialLink`, `ReservationConfig`
- Rename `BusinessType` enum: values `store`→`shop`, enum name → `EstablishmentType`
- Update `fromJson`/`toJson`/`copyWith` for all new fields
- Update all references from `BusinessType`/`store_type` → `EstablishmentType`/`establishment_type`

### F3: Opening Hours Editor (BP UI)
- New scrollspy section: "Åpningstider" (between Kontakt and Innstillinger)
- 7-day schedule: each day has `is_open` toggle + `open`/`close` time pickers
- Visual: compact row per day, toggle disables time pickers when closed
- "Kopier til alle" (copy to all) shortcut from any day

### F4: Social Links Editor (BP UI)
- New scrollspy section: "Sosiale medier" (after Kontakt)
- Platform dropdown (facebook, instagram, snapchat, tiktok, + "Annet"/"Other")
- URL text field per entry
- Add/remove links dynamically
- Known platforms → brand icon in dropdown

### F5: Booking Policy Editor (BP UI)
- New scrollspy section: "Bestillingsregler" (after Åpningstider)
- Three groups with subsections:
  - **Planlegging:** max_bookable_future_days, min_booking_notice_minutes, slot_interval
  - **Avbestilling:** client_cancel_enabled (toggle), min_cancel_notice_hours, client_reschedule_enabled (toggle), min_reschedule_notice_hours
  - **Ekstra:** booking_confirmation_message (text area), no_show_fee_percent (slider 0–100%)

### F6: Reservation Config Editor (BP UI)
- Shown ONLY when `establishmentType == restaurant` (ADR-0027)
- New scrollspy section: "Bordreservasjon" (after Bestillingsregler, conditional)
- Fields: max_guests, large_party_handling (dropdown), large_party_contact (conditional on handling != disabled), default_duration, slot_interval, buffer_between_slots, capacity_mode (dropdown), total_capacity (conditional on mode != pool), auto_confirm (toggle)

### F7: Establishment Type Selector (BP UI)
- Replace current `BusinessType` display in Generelt section with styled selector
- Changing type shows/hides relevant config sections (reservation_config for restaurant)

### F8: Marketplace Display
- Wire `openingSchedule` → derive `isOpen`/`openingStatus` on EstablishmentPage (replace placeholder TODOs)
- Display social link icons on EstablishmentPage (known platforms → brand icon, unknown → generic)

---

## Non-Functional Requirements

- All new model classes must have >80% test coverage
- Opening hours parsing must handle timezone correctly (Europe/Oslo DST)
- Social links URLs must be validated (basic URL format check)
- Booking policy defaults must match schema DEFAULTs exactly

---

## Acceptance Criteria

1. BP user can set opening hours for each day of the week with time pickers
2. BP user can add/remove social links with platform + URL
3. BP user can configure all 9 booking policy fields
4. BP user sees reservation config section ONLY for restaurant-type establishments
5. Changes persist to SurrealDB and survive page reload
6. Marketplace EstablishmentPage shows "Åpent til XX:XX" / "Stengt" based on real schedule
7. Marketplace EstablishmentPage shows social link icons
8. All new code has >80% test coverage
9. Deployed to Saturn and verified

---

## Edge Cases & Constraints

- Opening hours: midnight-crossing shifts (e.g., bar 20:00–02:00) — defer to split-shift track
- Timezone: Norway has one timezone — default `Europe/Oslo` without selector for v1
- Social links: duplicate platform entries (allow — user might have two Instagram accounts)
- Booking policy: `no_show_fee_percent` > 0 implies payment integration — display a warning that this requires Vipps (future)
- Schema migration: existing establishments have `store_type` data — value rename `store`→`shop` applied via migration

---

## Dependencies

- ADR-0027 (establishment_type) — locked ✅
- ADR-0028 (social links array) — locked ✅
- ADR-0029 (large_party_handling) — locked ✅
- `establishment_ui` package (EstablishmentPage display) — exists ✅
- `ditto_design` (DittoDashboardShell, tokens) — exists ✅

---

## Out of Scope

- Split-shift / multi-slot opening hours
- Seasonal schedules (summer/winter hours)
- Timezone selector (Norway is one timezone)
- Holiday / DateOverride management
- Staff shift scheduling
- Vipps payment integration for no-show fees
- `notify` push notification implementation (ADR-0029 — separate track)
- Large party request form in Marketplace (ADR-0029 — separate track)
