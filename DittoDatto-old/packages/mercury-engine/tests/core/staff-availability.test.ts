/**
 * Tests for core/shared/staff-availability.ts
 * 
 * Pure functions — no Firestore, fully testable.
 * Tests shift matching, date overrides, and multi-staff slot filtering.
 */

import { describe, it, expect } from 'vitest'
import { isStaffAvailable, getAvailableStaffForSlot, getDayKey } from '../../src/core/shared/staff-availability.js'
import type { StaffMember } from '@dittodatto/shared-types'

// ============================================================================
// Test Fixtures
// ============================================================================

/** Staff with standard Mon-Fri 09:00-17:00 schedule */
const standardStaff: StaffMember = {
  id: 'staff-1',
  displayName: 'Alice',
  isBookable: true,
  status: 'active',
  storeIds: ['store-1'],
  weeklyShifts: {
    mon: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    tue: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    wed: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    thu: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    fri: { isWorking: true, blocks: [{ start: '09:00', end: '17:00' }] },
    sat: { isWorking: false, blocks: [] },
    sun: { isWorking: false, blocks: [] },
  },
}

/** Staff with split shift (lunch break) */
const splitShiftStaff: StaffMember = {
  id: 'staff-2',
  displayName: 'Bob',
  isBookable: true,
  status: 'active',
  storeIds: ['store-1'],
  weeklyShifts: {
    mon: { isWorking: true, blocks: [
      { start: '09:00', end: '12:00' },
      { start: '13:00', end: '17:00' },
    ]},
    tue: { isWorking: true, blocks: [
      { start: '09:00', end: '12:00' },
      { start: '13:00', end: '17:00' },
    ]},
    wed: { isWorking: false, blocks: [] }, // Day off
    thu: { isWorking: true, blocks: [
      { start: '09:00', end: '12:00' },
      { start: '13:00', end: '17:00' },
    ]},
    fri: { isWorking: true, blocks: [
      { start: '09:00', end: '12:00' },
      { start: '13:00', end: '17:00' },
    ]},
    sat: { isWorking: false, blocks: [] },
    sun: { isWorking: false, blocks: [] },
  },
}

/** Staff who is inactive */
const inactiveStaff: StaffMember = {
  ...standardStaff,
  id: 'staff-inactive',
  displayName: 'Inactive',
  status: 'inactive',
}

/** Staff who is not bookable */
const nonBookableStaff: StaffMember = {
  ...standardStaff,
  id: 'staff-nonbook',
  displayName: 'Admin',
  isBookable: false,
}

// ============================================================================
// getDayKey
// ============================================================================

describe('getDayKey', () => {
  it('returns correct day keys', () => {
    expect(getDayKey('2026-03-16')).toBe('mon')
    expect(getDayKey('2026-03-14')).toBe('sat')
    expect(getDayKey('2026-03-15')).toBe('sun')
  })
})

// ============================================================================
// isStaffAvailable
// ============================================================================

describe('isStaffAvailable', () => {
  // --- Basic schedule matching ---

  it('returns true when slot fits within a shift block', () => {
    // Monday, 10:00-11:00 (600-660) — within 09:00-17:00
    expect(isStaffAvailable(standardStaff, '2026-03-16', 600, 660)).toBe(true)
  })

  it('returns false when slot is outside working hours', () => {
    // Monday, 07:00-08:00 (420-480) — before 09:00
    expect(isStaffAvailable(standardStaff, '2026-03-16', 420, 480)).toBe(false)
  })

  it('returns false on days off', () => {
    // Saturday — not working
    expect(isStaffAvailable(standardStaff, '2026-03-14', 600, 660)).toBe(false)
  })

  it('returns true when slot exactly matches shift boundaries', () => {
    // Monday, exactly 09:00-17:00 (540-1020)
    expect(isStaffAvailable(standardStaff, '2026-03-16', 540, 1020)).toBe(true)
  })

  it('returns false when slot extends beyond shift end', () => {
    // Monday, 16:00-18:00 (960-1080) — extends past 17:00
    expect(isStaffAvailable(standardStaff, '2026-03-16', 960, 1080)).toBe(false)
  })

  // --- Split shifts ---

  it('returns true for slot in first block of split shift', () => {
    // Monday, 10:00-11:00 (600-660) — within 09:00-12:00
    expect(isStaffAvailable(splitShiftStaff, '2026-03-16', 600, 660)).toBe(true)
  })

  it('returns true for slot in second block of split shift', () => {
    // Monday, 14:00-15:00 (840-900) — within 13:00-17:00
    expect(isStaffAvailable(splitShiftStaff, '2026-03-16', 840, 900)).toBe(true)
  })

  it('returns false for slot spanning the gap in split shift', () => {
    // Monday, 11:30-13:30 (690-810) — spans 12:00-13:00 gap
    expect(isStaffAvailable(splitShiftStaff, '2026-03-16', 690, 810)).toBe(false)
  })

  it('returns false on day-off in split shift schedule', () => {
    // Wednesday — Bob's day off
    expect(isStaffAvailable(splitShiftStaff, '2026-03-18', 600, 660)).toBe(false)
  })

  // --- Status checks ---

  it('returns false for inactive staff regardless of schedule', () => {
    expect(isStaffAvailable(inactiveStaff, '2026-03-16', 600, 660)).toBe(false)
  })

  it('returns false for non-bookable staff', () => {
    expect(isStaffAvailable(nonBookableStaff, '2026-03-16', 600, 660)).toBe(false)
  })

  // --- Date overrides ---

  it('returns false when staff has a date override of type "off"', () => {
    const staffWithOverride: StaffMember = {
      ...standardStaff,
      dateOverrides: [{ date: '2026-03-16', type: 'off' }],
    }
    // Monday — would normally be available
    expect(isStaffAvailable(staffWithOverride, '2026-03-16', 600, 660)).toBe(false)
  })

  it('returns false when staff has a date override of type "sick"', () => {
    const staffWithOverride: StaffMember = {
      ...standardStaff,
      dateOverrides: [{ date: '2026-03-16', type: 'sick' }],
    }
    expect(isStaffAvailable(staffWithOverride, '2026-03-16', 600, 660)).toBe(false)
  })

  it('uses custom blocks from date override', () => {
    const staffWithOverride: StaffMember = {
      ...standardStaff,
      dateOverrides: [{
        date: '2026-03-16',
        type: 'custom',
        blocks: [{ start: '10:00', end: '14:00' }],
      }],
    }
    // Within custom block
    expect(isStaffAvailable(staffWithOverride, '2026-03-16', 600, 660)).toBe(true)
    // Outside custom block (before)
    expect(isStaffAvailable(staffWithOverride, '2026-03-16', 540, 570)).toBe(false)
    // Outside custom block (after)
    expect(isStaffAvailable(staffWithOverride, '2026-03-16', 900, 960)).toBe(false)
  })

  it('date override takes priority over weekly schedule', () => {
    const staffWithOverride: StaffMember = {
      ...standardStaff,
      dateOverrides: [{ date: '2026-03-16', type: 'off' }],
    }
    // Monday 10:00 — normally available, but override says "off"
    expect(isStaffAvailable(staffWithOverride, '2026-03-16', 600, 660)).toBe(false)
  })

  // --- Edge: no schedule data ---

  it('returns false when staff has no weeklyShifts (fail-closed)', () => {
    const noScheduleStaff: StaffMember = {
      id: 'staff-noschedule',
      displayName: 'NoSchedule',
      isBookable: true,
      status: 'active',
      storeIds: ['store-1'],
      // weeklyShifts is undefined
    }
    expect(isStaffAvailable(noScheduleStaff, '2026-03-16', 600, 660)).toBe(false)
  })
})

// ============================================================================
// getAvailableStaffForSlot
// ============================================================================

describe('getAvailableStaffForSlot', () => {
  const allStaff = [standardStaff, splitShiftStaff, inactiveStaff, nonBookableStaff]

  it('returns IDs of available staff for a Monday morning slot', () => {
    // Monday 10:00-11:00 — both standard and split shift are available
    const result = getAvailableStaffForSlot(allStaff, '2026-03-16', 600, 660)
    expect(result).toContain('staff-1')
    expect(result).toContain('staff-2')
    expect(result).not.toContain('staff-inactive')
    expect(result).not.toContain('staff-nonbook')
  })

  it('excludes split-shift staff during their lunch break', () => {
    // Monday 12:00-13:00 (720-780) — standard staff ok, split shift has a gap
    const result = getAvailableStaffForSlot(allStaff, '2026-03-16', 720, 780)
    expect(result).toContain('staff-1')
    expect(result).not.toContain('staff-2')
  })

  it('returns empty array on Saturday', () => {
    const result = getAvailableStaffForSlot(allStaff, '2026-03-14', 600, 660)
    expect(result).toEqual([])
  })

  it('returns empty array when no staff provided', () => {
    const result = getAvailableStaffForSlot([], '2026-03-16', 600, 660)
    expect(result).toEqual([])
  })
})
