/**
 * Tests for core/shared/resource-availability.ts
 * 
 * Pure functions — tests resource conflict detection and best-fit allocation.
 */

import { describe, it, expect } from 'vitest'
import { getAvailableResourcesForSlot } from '../../src/core/shared/resource-availability.js'
import type { Resource, ResourceGroup } from '@dittodatto/shared-types'

// ============================================================================
// Test Fixtures
// ============================================================================

const makeResource = (overrides: Partial<Resource> & { id: string }): Resource => ({
  name: `Resource ${overrides.id}`,
  type: 'room',
  isBookable: true,
  priority: 'normal',
  maxCapacity: 1,
  minCapacity: 1,
  resourceGroupId: 'group-1',
  allowOverlapping: false,
  ...overrides,
} as Resource)

const group1: ResourceGroup = {
  id: 'group-1',
  name: 'Treatment Rooms',
} as ResourceGroup

const group2: ResourceGroup = {
  id: 'group-2',
  name: 'Equipment',
} as ResourceGroup

// ============================================================================
// getAvailableResourcesForSlot
// ============================================================================

describe('getAvailableResourcesForSlot', () => {
  // --- No requirements ---

  it('returns available with empty array when no resource groups required', () => {
    const result = getAvailableResourcesForSlot([], [], [], 540, 600, [])
    expect(result.available).toBe(true)
    expect(result.assignedResources).toEqual([])
  })

  it('returns available when requiredGroupIds is undefined-ish', () => {
    const result = getAvailableResourcesForSlot([], [], [], 540, 600, [])
    expect(result.available).toBe(true)
  })

  // --- Single group, single resource ---

  it('assigns a free resource when available', () => {
    const resources = [makeResource({ id: 'r1', resourceGroupId: 'group-1' })]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, []
    )
    expect(result.available).toBe(true)
    expect(result.assignedResources).toHaveLength(1)
    expect(result.assignedResources[0].id).toBe('r1')
  })

  it('returns unavailable when only resource is occupied', () => {
    const resources = [makeResource({ id: 'r1', resourceGroupId: 'group-1' })]
    const occupied = [{ start: 530, end: 590, resourceId: 'r1' }]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, occupied
    )
    expect(result.available).toBe(false)
  })

  it('assigns the free resource when one of two is occupied', () => {
    const resources = [
      makeResource({ id: 'r1', resourceGroupId: 'group-1' }),
      makeResource({ id: 'r2', resourceGroupId: 'group-1' }),
    ]
    const occupied = [{ start: 530, end: 590, resourceId: 'r1' }]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, occupied
    )
    expect(result.available).toBe(true)
    expect(result.assignedResources[0].id).toBe('r2')
  })

  // --- Non-overlapping times ---

  it('treats non-overlapping occupied intervals as free', () => {
    const resources = [makeResource({ id: 'r1', resourceGroupId: 'group-1' })]
    // Occupied 08:00-09:00, slot requested 09:00-10:00 → no overlap
    const occupied = [{ start: 480, end: 540, resourceId: 'r1' }]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, occupied
    )
    expect(result.available).toBe(true)
  })

  // --- Priority + best-fit sorting ---

  it('assigns high priority resource before normal priority', () => {
    const resources = [
      makeResource({ id: 'r-normal', resourceGroupId: 'group-1', priority: 'normal' }),
      makeResource({ id: 'r-high', resourceGroupId: 'group-1', priority: 'high' }),
    ]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, []
    )
    expect(result.assignedResources[0].id).toBe('r-high')
  })

  it('assigns smallest capacity resource (best-fit) within same priority', () => {
    const resources = [
      makeResource({ id: 'r-big', resourceGroupId: 'group-1', maxCapacity: 10 }),
      makeResource({ id: 'r-small', resourceGroupId: 'group-1', maxCapacity: 2 }),
    ]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, []
    )
    expect(result.assignedResources[0].id).toBe('r-small')
  })

  // --- Multiple required groups ---

  it('assigns one resource from each required group', () => {
    const resources = [
      makeResource({ id: 'room-1', resourceGroupId: 'group-1' }),
      makeResource({ id: 'equip-1', resourceGroupId: 'group-2' }),
    ]
    const result = getAvailableResourcesForSlot(
      resources, [group1, group2], ['group-1', 'group-2'], 540, 600, []
    )
    expect(result.available).toBe(true)
    expect(result.assignedResources).toHaveLength(2)
    const assignedIds = result.assignedResources.map(r => r.id)
    expect(assignedIds).toContain('room-1')
    expect(assignedIds).toContain('equip-1')
  })

  it('returns unavailable if any required group has no free resources', () => {
    const resources = [
      makeResource({ id: 'room-1', resourceGroupId: 'group-1' }),
      makeResource({ id: 'equip-1', resourceGroupId: 'group-2' }),
    ]
    const occupied = [{ start: 530, end: 590, resourceId: 'equip-1' }]
    const result = getAvailableResourcesForSlot(
      resources, [group1, group2], ['group-1', 'group-2'], 540, 600, occupied
    )
    expect(result.available).toBe(false)
  })

  // --- allowOverlapping ---

  it('allows overlapping resources to be assigned even when occupied', () => {
    const resources = [
      makeResource({ id: 'r1', resourceGroupId: 'group-1', allowOverlapping: true }),
    ]
    const occupied = [{ start: 530, end: 590, resourceId: 'r1' }]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, occupied
    )
    expect(result.available).toBe(true)
  })

  // --- Non-bookable resources ---

  it('skips non-bookable resources', () => {
    const resources = [
      makeResource({ id: 'r1', resourceGroupId: 'group-1', isBookable: false }),
    ]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, []
    )
    expect(result.available).toBe(false)
  })

  // --- Occupied intervals without resourceId ---

  it('ignores occupied intervals without resourceId (general occupations)', () => {
    const resources = [makeResource({ id: 'r1', resourceGroupId: 'group-1' })]
    // Occupied but no resourceId → should be ignored for resource check
    const occupied = [{ start: 530, end: 590 }]
    const result = getAvailableResourcesForSlot(
      resources, [group1], ['group-1'], 540, 600, occupied
    )
    expect(result.available).toBe(true)
  })
})
