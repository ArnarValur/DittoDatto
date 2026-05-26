# Service Groups Track

**Status:** [ ] Not Started
**Created:** 2026-01-01
**Priority:** P1 - Enhances service configuration UX

## Goal

Implement a cascading configuration inheritance system for services:

```
Store (Base Defaults) → ServiceGroup (Optional) → Service (Most Specific)
```

This allows merchants to:
- Set store-wide default configurations
- Create groups of services that share settings
- Override at any level for fine-grained control

## Why This Matters

| Scenario | Without Groups | With Groups |
|----------|---------------|-------------|
| 10 quick services (15 min each) | Configure 10 times | Configure group once |
| Change buffer time for all premium services | Edit 20 services | Edit 1 group |
| Different weekend vs weekday configs | Per-service rules | Group-level rules |

## Core Concepts

### 1. Store Base Defaults
```typescript
Store.defaultServiceConfig = {
  duration: 60,
  bufferTime: 15,
  capacity: 1,
  availabilityStart: '09:00',
  availabilityEnd: '17:00'
}
```

### 2. Service Groups (New Entity)
```typescript
ServiceGroupSchema = z.object({
  id: IdSchema,
  storeId: IdSchema,
  name: z.string().min(1),
  description: z.string().optional(),
  
  // Inherited config (all optional - only override what's needed)
  duration: z.number().int().positive().optional(),
  bufferTime: z.number().int().optional(),
  capacity: z.number().int().min(1).optional(),
  bookingMode: BookingModeSchema.optional(),
  
  // Availability rules (optional)
  availabilityRules: z.array(z.object({
    days: z.array(z.enum(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'])),
    start: z.string(), // "09:00"
    end: z.string()    // "17:00"
  })).optional(),
  
  // Staff association
  staffIds: z.array(IdSchema).optional(),
  
  createdAt: IsoDateSchema,
  updatedAt: IsoDateSchema
})
```

### 3. Service Updates
```typescript
ServiceSchema = z.object({
  // ... existing fields ...
  groupId: IdSchema.optional(), // NEW: Link to group
  // All config fields become optional with cascade resolution
})
```

### 4. Resolution Logic
```typescript
function getEffectiveConfig(service, group, store) {
  return {
    duration: service.duration ?? group?.duration ?? store.defaultServiceConfig.duration,
    bufferTime: service.bufferTime ?? group?.bufferTime ?? store.defaultServiceConfig.bufferTime,
    capacity: service.capacity ?? group?.capacity ?? store.defaultServiceConfig.capacity,
    bookingMode: service.bookingMode ?? group?.bookingMode ?? 'standard',
    // ... etc
  }
}
```

## Implementation Phases

### Phase 1: Schema & Backend
- [ ] Add `defaultServiceConfig` to Store schema
- [ ] Create `ServiceGroupSchema` in shared-types
- [ ] Add `groupId` to Service schema
- [ ] Create Firestore collection: `companies/{companyId}/stores/{storeId}/serviceGroups`
- [ ] Create CRUD functions for service groups

### Phase 2: Business Portal UI
- [ ] Add "Service Groups" section to store management
- [ ] Create ServiceGroupFormSlideover component
- [ ] Update ServiceFormSlideover with group selection dropdown
- [ ] Show inherited values with "Inherited from: [Group/Store]" labels

### Phase 3: Store Defaults UI
- [ ] Add "Default Service Settings" section to store settings
- [ ] Allow configuring base duration, buffer, capacity, availability

### Phase 4: Resolution & Testing
- [ ] Implement getEffectiveConfig utility
- [ ] Update MercuryEngine to use resolved configs
- [ ] Test cascade inheritance works correctly

## UI/UX Considerations

### Service Form
- Show group dropdown (optional)
- When group selected, show inherited values as placeholders
- "Use group default" / "Override" toggle for each field

### Service Groups Page
- List of groups with service count
- Quick-add services to groups
- Drag-drop to reorder/organize

## Acceptance Criteria

1. ✅ Merchant can set store-wide default service settings
2. ✅ Merchant can create service groups with shared configs
3. ✅ Services can belong to a group and inherit settings
4. ✅ Services can override inherited settings
5. ✅ MercuryEngine uses resolved configs for booking

## Related Tracks

- **Table Reservation** - Uses capacity/availability concepts
- **Business Portal Structure** - UI location for group management
- **Staff Management** (future) - Groups can have staff associations

## Notes

This feature was born from refactoring `bookingFormType` from Store to Service level. The cascade pattern provides a cleaner UX while maintaining flexibility.
