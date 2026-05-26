# Booking Panel Slideover Audit

This document provides a comprehensive audit of the Booking Panel slideovers across the DittoDatto platform, specifically analyzing the differentiations between the **Standard Bookings** and **Table Reservations** processes. It also proposes strategies for compartmentalizing these into a unified DittoDatto Component in the next iteration.
	
## 1. Component Architecture & Overview

The Booking Panel relies heavily on the `<USlideover>` component from Nuxt UI, utilizing dynamic rendering to switch between views and processes.

### Core Shell: `BookingSlideover.vue` (`packages/ui`)
This is the primary customer-facing shell that opens when a user wants to make a new booking.
- **State Management**: Uses a `view` state (`'services' | 'flow' | 'confirmation' | 'login'`).
- **Routing**: Determines the booking process via the `bookingMode` property on the selected service (`'standard'` vs `'tableReservation'`).
- **Template Makeup**:
  - `<USlideover>` wrapper with conditional rendering for its `<template #body>`.
  - Service selection list with support for accordion groups and multi-select.
  - Dynamically mounts either `<StandardBookingFlow>` or `<ReservationBookingFlow>` based on the `bookingMode`.

---

## 2. Process Differentiations (Creation Flow)

### Standard Bookings (`StandardBookingFlow.vue`)
Designed for 1:1 appointments, services, and time-based bookings.
- **Steps**: `[ 'staff' (optional), 'date', 'time', 'confirm' ]`
- **Key Features**:
  - **Staff Selection**: Injects a staff selection step if multiple staff members are available.
  - **Multi-Service Support**: Displays a summary of all selected services with aggregated duration and total price.
  - **Hold Expiration**: Implements a live countdown timer (`holdExpiresAt`) indicating when the slot reservation will be released.
- **Tag Makeup**: 
  - Heavy use of flexbox containers for summaries (`<div class="flex items-center gap-4">`).
  - Uses `<NuxtImg>` for cover images.
  - Interactive grid for time slots.

### Table Reservations (`ReservationBookingFlow.vue`)
Designed for restaurant, venue, or event seating where capacity constraints apply.
- **Steps**: `[ 'guests', 'date', 'time', 'confirm' ]`
- **Key Features**:
  - **Guest Count First**: Starts with an interactive guest counter instead of staff/date.
  - **Capacity Rules**: Governed by `reservationConfig` (e.g., `maxGuestsPerReservation`).
  - **Large Party Handling**: Displays conditional warnings and instructions (e.g., "call us" or "email us") if the guest count exceeds maximum standard limits.
- **Tag Makeup**:
  - Emphasizes large typography for numbers (`<span class="text-5xl font-bold">`).
  - Progress indicator uses `bg-primary` for active steps.

---

## 3. Process Differentiations (Management / Business Portal)

For the business side, there are separate components for managing existing entries.

### Standard Booking Management (`BookingDetailSlideover.vue`)
- **Focus**: Extensive metadata, payment, and staff management.
- **Sections**: Customer Info, Schedule, Payment (with formatted currency), Staff Assignment, Notes, and Service Items.
- **Permissions**: Heavily integrated with RBAC (`useStaffPermissions`).
- **Actions**: Detailed lifecycle buttons (Confirm, Complete, No-Show, Cancel).

### Reservation Management (`ReservationSlideover.vue`)
- **Focus**: Table assignment and fast access to critical guest info.
- **Sections**: Key Info Grid (Guests, Time, Contact) inside a stylized `bg-muted/30` box, Table Assignment (`<USelectMenu>` linked to resources), and Internal/Guest Notes.
- **Actions**: Simpler lifecycle (Cancel, Save Changes) with a dedicated `<UModal>` for cancel confirmation.

---

## 4. Style Considerations

Across both flows, the styling strictly adheres to the DittoDatto Tailwind ecosystem and Nuxt UI constraints:
- **Containers**: Extensive use of `p-4`, `rounded-xl`, `border border-default`, and `bg-muted/20` to create floating cards within the slideover body.
- **Typography**: Uses `text-muted` for labels and secondary info, `font-semibold` for primary data.
- **Icons**: Standardized on `lucide` icons (e.g., `i-lucide-users`, `i-lucide-calendar-check`, `i-lucide-clock`).
- **Feedback**: Color mapping is consistent (`success` for confirmed, `warning` for pending, `error` for no-show/cancelled).
- **Transitions**: Uses `Transition name="slide-up"` for sticky footers and smooth conditional rendering.

---

## 5. Strategies for Compartmentalization (Next Iteration)

Currently, the logic is slightly fragmented. `BookingSlideover.vue` is a monolith shell, and the management components in the Business Portal duplicate structural boilerplate.

To unify this into a cohesive **DittoDatto Component**:

### Strategy 1: Unified Base Layout Component (`<SlideoverLayout>`)
Create a base component `BaseEntitySlideover.vue` in `packages/ui` that standardizes the shell.
- **Slots**: `#header`, `#subheader` (for staff banner or status pills), `#body`, `#footer`.
- **Props**: `title`, `status` (renders unified badge), `loading`.
- **Benefit**: Both the creation flow and the business management slideovers will use the exact same structural wrapper, ensuring padding, close buttons, and transitions are 100% identical.

### Strategy 2: Modularized Step Engine
Instead of hardcoding `steps = ['date', 'time', 'confirm']`, build a composable `useBookingSteps()` that dynamically computes the pipeline based on `mode`.
- Create discrete atomic components: `<StepGuestCount>`, `<StepDateSelect>`, `<StepTimeSelect>`, `<StepStaffSelect>`, `<StepConfirm>`.
- **Benefit**: If a new booking mode is introduced (e.g., "Event Ticketing"), you just assemble the required atomic step components in the required order.

### Strategy 3: Abstracted Management Views
The `BookingDetailSlideover.vue` and `ReservationSlideover.vue` share 70% of their UI (Customer info, Notes, Footer actions).
- Create a `<EntityDetailsCard>` for common customer info.
- Pass `bookingMode` to a generic `<EntityManagementSlideover>` that uses `<component :is="resolveModeSpecificComponent(mode)">` to inject only the differences (e.g., Table Assignment vs. Service Items List).

### Strategy 4: Shared Store State / Composable
Lift the API fetching (slots, holds, resources) out of the components.
- Use a `useBookingFlow(serviceId, config)` composable that manages `selectedDate`, `selectedTime`, `guestCount`, and `holdStatus` universally, making the Vue files purely presentational.