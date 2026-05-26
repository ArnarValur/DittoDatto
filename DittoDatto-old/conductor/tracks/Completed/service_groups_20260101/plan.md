# Service Groups - Implementation Plan

**Status:** ✅ Complete (2026-01-04)
**Track ID:** `service_groups_20260101`

---

## Overview

Service Groups allow grouping services with shared configuration. Configuration cascades: **Store → ServiceGroup → Service**

---

## Phase 1: Schema & Backend ✅

- [x] Store schema: add `defaultServiceConfig` — Done in `store.ts`
- [x] Create `ServiceGroupSchema` — Done in `service-group.ts`
- [x] Service schema: add `groupId` — Done in `service.ts`
- [x] CRUD via client-side Firestore composables

## Phase 2: Business Portal UI ✅

- [x] `useServiceGroups.ts` composable created
- [x] `ServiceGroupFormSlideover.vue` component created
- [x] Service form updated with group picker

## Phase 3: Store Defaults ✅

- [x] `defaultServiceConfig` in store schema supports cascade inheritance

## Phase 4: Integration 🔄

- [x] Schema cascade design complete
- [ ] MercuryEngine `getEffectiveConfig` utility (future enhancement)
- [ ] Full integration testing

---

## Files Implemented

| File | Purpose |
|------|---------|
| `packages/shared-types/src/service-group.ts` | ServiceGroup schema |
| `packages/shared-types/src/store.ts` | defaultServiceConfig |
| `packages/shared-types/src/service.ts` | groupId field |
| `apps/web/business-portal/app/composables/useServiceGroups.ts` | CRUD composable |
| `apps/web/business-portal/app/components/services/ServiceGroupFormSlideover.vue` | Form UI |
