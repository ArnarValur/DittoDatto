# Specification: TableReservation Booking System

## 1. Goal

To implement MercuryEngine's **2nd pillar** (capacity-based reservations) enabling restaurants and food establishments to manage table bookings with guest count selection, menu-based services, and flexible capacity management.

## 2. Core Features

### 2.1 Multi-Type Booking Support
- `bookingFormTypes` as **array** (not single value)
- **Company level:** `defaultBookingFormTypes` (defaults for all stores)
- **Store level:** `bookingFormTypes` (optional override)
- Logic: `store.bookingFormTypes ?? company.defaultBookingFormTypes`

### 2.2 Menu as Service Type
- Extend `ServiceSchema` with `serviceType: "menu"`
- Menu items = dining experiences (Lunch, Dinner, Brunch, etc.)
- Each has: title, operating window, default duration, optional deposit

### 2.3 Hybrid Table Model
- **Default:** Capacity pools (total seats per time window)
- **Optional:** Physical tables with names, capacities, sections
- Business chooses their level of complexity

### 2.4 Guest Count Logic
- Guest-first booking flow (1-8, configurable max)
- **Strict mode:** Guest count affects slot availability
- Large parties: "Contact us directly" pattern for max+

### 2.5 Reservation Flow
```
User → Guest Count → Menu/Experience → Date → Time Slot → Hold → Book
```

## 3. Technical Implementation

### 3.1 Schema Updates

**CompanySchema addition:**
```typescript
defaultBookingFormTypes: z.array(z.enum([
  "standard",
  "tableReservation", 
  "ticketSystem"
])).default(["standard"])
```

**StoreSchema update:**
```typescript
bookingFormTypes: z.array(z.enum([
  "standard",
  "tableReservation",
  "ticketSystem"
])).optional()
```

**ServiceSchema extension:**
```typescript
serviceType: z.enum([
  "standard",     // Appointments
  "menu",         // Restaurant dining experiences
  "class",        // Future: group classes
  "rental"        // Future: equipment/space rental
]).default("standard")
```

**New TableSchema:**
```typescript
const TableSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  companyId: IdSchema,
  name: z.string().min(1),
  capacity: z.number().int().min(1),
  minGuests: z.number().int().min(1).default(1),
  section: z.string().optional(),
  isActive: z.boolean().default(true),
  createdAt: IsoDateSchema,
  updatedAt: IsoDateSchema
});
```

### 3.2 MercuryEngine Integration

> 📌 **PostIt:** Refactor these into `MercuryEngine/shared/` during implementation:
> - `getAvailableSlots()` 
> - `createHold()`
> - `createBooking()`
> - `cleanExpiredHolds()`

### 3.3 File Structure
```
packages/shared-types/src/
├── table.ts              # NEW: TableSchema
├── service.ts            # UPDATE: Add serviceType
├── store.ts              # UPDATE: bookingFormTypes array
├── company.ts            # UPDATE: defaultBookingFormTypes

firebase/functions/src/MercuryEngine/
├── shared/               # NEW: Shared utilities (PostIt)
│   ├── availability.ts
│   ├── hold.ts
│   └── booking.ts
├── appointments/         # Existing: standard booking
└── reservations/         # NEW: tableReservation booking
    ├── calculator.ts     # Capacity-based availability
    └── index.ts
```

## 4. Business Portal Features

1. **Table Management** - Create/edit tables, sections, capacities
2. **Menu Configuration** - Define dining experiences with time windows
3. **Capacity Rules** - Max guests, blackout dates
4. **Reservation Dashboard** - Calendar view, guest summaries

## 5. Acceptance Criteria

1. **Schema:** `bookingFormTypes` array works at Company + Store level
2. **Service:** Can create service with `serviceType: "menu"`
3. **Table:** Can create tables with name/capacity (optional)
4. **Booking:** Guest can select count → experience → date → time → hold → book
5. **Availability:** Capacity-based slots work correctly
