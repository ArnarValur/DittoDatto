/**
 * useStaffSchedule Composable
 *
 * Manages reading and writing staff shift schedules.
 * Provides reactive access to weekly shifts and date overrides,
 * with methods for CRUD operations on schedule data.
 */
import type { WeeklyShift, DateOverride, DayShift, ShiftBlock } from '@dittodatto/shared-types'
import { doc, updateDoc, serverTimestamp } from 'firebase/firestore'
import { useFirestore } from 'vuefire'

/** Default empty day — not working, no blocks */
const emptyDay = (): DayShift => ({ isWorking: false, blocks: [] })

/** Default working day — 9 to 5 single block */
const defaultWorkDay = (): DayShift => ({
  isWorking: true,
  blocks: [{ start: '09:00', end: '17:00' }]
})

/** Generate a blank weekly template */
export function defaultWeeklyShifts(): WeeklyShift {
  return {
    mon: defaultWorkDay(),
    tue: defaultWorkDay(),
    wed: defaultWorkDay(),
    thu: defaultWorkDay(),
    fri: defaultWorkDay(),
    sat: emptyDay(),
    sun: emptyDay()
  }
}

export function useStaffSchedule() {
  const db = useFirestore()
  const { companyId } = useCompany()
  const toast = useToast()

  /**
   * Save the full weekly shift pattern for a staff member.
   */
  async function saveWeeklyShifts(staffId: string, shifts: WeeklyShift) {
    if (!companyId.value) return
    const ref = doc(db, 'companies', companyId.value, 'staff', staffId)
    await updateDoc(ref, {
      weeklyShifts: shifts,
      updatedAt: serverTimestamp()
    })
    toast.add({ title: 'Schedule saved', description: 'Weekly shifts updated.' })
  }

  /**
   * Save the full date overrides array for a staff member.
   */
  async function saveDateOverrides(staffId: string, overrides: DateOverride[]) {
    if (!companyId.value) return
    const ref = doc(db, 'companies', companyId.value, 'staff', staffId)
    await updateDoc(ref, {
      dateOverrides: overrides,
      updatedAt: serverTimestamp()
    })
    toast.add({ title: 'Overrides saved', description: 'Date overrides updated.' })
  }

  /**
   * Add a single date override, merging with existing.
   * If an override for the same date exists, it is replaced.
   */
  async function addDateOverride(staffId: string, override: DateOverride, existingOverrides: DateOverride[]) {
    const filtered = existingOverrides.filter(o => o.date !== override.date)
    filtered.push(override)
    // Sort by date for cleanliness
    filtered.sort((a, b) => a.date.localeCompare(b.date))
    await saveDateOverrides(staffId, filtered)
  }

  /**
   * Remove a date override by date string.
   */
  async function removeDateOverride(staffId: string, date: string, existingOverrides: DateOverride[]) {
    const filtered = existingOverrides.filter(o => o.date !== date)
    await saveDateOverrides(staffId, filtered)
  }

  /**
   * Resolve the effective schedule for a given date.
   * DateOverride takes precedence over weekly shifts.
   */
  function getEffectiveSchedule(
    weeklyShifts: WeeklyShift | undefined,
    dateOverrides: DateOverride[],
    date: string // YYYY-MM-DD
  ): { isWorking: boolean; blocks: ShiftBlock[] } {
    // Check for date override first
    const override = dateOverrides.find(o => o.date === date)
    if (override) {
      if (override.type === 'off' || override.type === 'sick') {
        return { isWorking: false, blocks: [] }
      }
      if (override.type === 'custom' && override.blocks) {
        return { isWorking: true, blocks: override.blocks }
      }
    }

    // Fall back to weekly pattern
    if (!weeklyShifts) {
      return { isWorking: false, blocks: [] }
    }

    const dayOfWeek = new Date(date).getDay() // 0=Sun, 1=Mon, ...
    const dayKeys: (keyof WeeklyShift)[] = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
    const dayKey = dayKeys[dayOfWeek]!
    const dayShift = weeklyShifts[dayKey]

    return {
      isWorking: dayShift.isWorking,
      blocks: dayShift.blocks
    }
  }

  return {
    saveWeeklyShifts,
    saveDateOverrides,
    addDateOverride,
    removeDateOverride,
    getEffectiveSchedule,
    defaultWeeklyShifts
  }
}
