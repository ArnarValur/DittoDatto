/**
 * useInheritedConfig Composable
 *
 * Resolves the cascading configuration for a Service.
 * Inheritance chain: Store → ServiceGroup → Service
 *
 * Returns the effective values and their sources for display.
 */
import type { ServiceGroup } from '@dittodatto/shared-types'

export interface InheritedField<T> {
  value: T | undefined
  source: 'store' | 'group' | 'service' | 'default'
  sourceName?: string
}

export interface InheritedConfig {
  duration: InheritedField<number>
  bufferTime: InheritedField<number>
  capacity: InheritedField<number>
  bookingMode: InheritedField<'standard' | 'tableReservation' | 'ticketSystem'>
  availabilityStart: InheritedField<string>
  availabilityEnd: InheritedField<string>
}

// Default values when nothing is set
const DEFAULTS = {
  duration: 60,
  bufferTime: 15,
  capacity: 1,
  bookingMode: 'standard' as const,
  availabilityStart: '09:00',
  availabilityEnd: '17:00'
}

export function useInheritedConfig(
  storeId: Ref<string | undefined>,
  groupId: Ref<string | undefined>,
  serviceValues: {
    duration?: number
    bufferTime?: number
    capacity?: number
    bookingMode?: string
    availabilityStart?: string
    availabilityEnd?: string
  }
) {
  const { stores } = useStores()
  const { groups } = useServiceGroups(storeId)

  // Get current store
  const store = computed(() => stores.value?.find(s => s.id === storeId.value))

  // Get current group
  const group = computed(() => groups.value?.find(g => g.id === groupId.value))

  // Resolve a single field through the cascade
  function resolveField<K extends keyof typeof DEFAULTS>(
    fieldName: K,
    serviceValue: typeof DEFAULTS[K] | undefined
  ): InheritedField<typeof DEFAULTS[K]> {
    // 1. Service has explicit value
    if (serviceValue !== undefined && serviceValue !== DEFAULTS[fieldName]) {
      return { value: serviceValue, source: 'service' }
    }

    // 2. Group has value
    const groupVal = group.value?.[fieldName as keyof ServiceGroup] as typeof DEFAULTS[K] | undefined
    if (groupVal !== undefined) {
      return { value: groupVal, source: 'group', sourceName: group.value?.name }
    }

    // 3. Store-level: for availability, derive from openingSchedule instead of defaultServiceConfig
    if (fieldName === 'availabilityStart' || fieldName === 'availabilityEnd') {
      const schedule = store.value?.openingSchedule
      if (schedule) {
        const openDays = Object.values(schedule).filter((d: any) => d?.isOpen)
        if (openDays.length > 0) {
          if (fieldName === 'availabilityStart') {
            // Earliest opening across all open days
            const earliest = openDays.reduce((min: string, d: any) => d.open < min ? d.open : min, '23:59')
            return { value: earliest as typeof DEFAULTS[K], source: 'store', sourceName: store.value?.name }
          } else {
            // Latest closing across all open days
            const latest = openDays.reduce((max: string, d: any) => d.close > max ? d.close : max, '00:00')
            return { value: latest as typeof DEFAULTS[K], source: 'store', sourceName: store.value?.name }
          }
        }
      }
    } else {
      // 3b. For non-availability fields, use store defaultServiceConfig as before
      const storeDefaults = store.value?.defaultServiceConfig
      const storeVal = (storeDefaults as Record<string, any>)?.[fieldName] as typeof DEFAULTS[K] | undefined
      if (storeVal !== undefined) {
        return { value: storeVal, source: 'store', sourceName: store.value?.name }
      }
    }

    // 4. System defaults
    return { value: DEFAULTS[fieldName], source: 'default' }
  }

  // Build the full inherited config
  const inheritedConfig = computed<InheritedConfig>(() => ({
    duration: resolveField('duration', serviceValues.duration),
    bufferTime: resolveField('bufferTime', serviceValues.bufferTime),
    capacity: resolveField('capacity', serviceValues.capacity),
    bookingMode: resolveField('bookingMode', serviceValues.bookingMode as typeof DEFAULTS['bookingMode']),
    availabilityStart: resolveField('availabilityStart', serviceValues.availabilityStart),
    availabilityEnd: resolveField('availabilityEnd', serviceValues.availabilityEnd)
  }))

  // Helper to get display text for source
  function getSourceLabel(field: InheritedField<unknown>): string | null {
    switch (field.source) {
      case 'group':
        return `Inherited from: ${field.sourceName || 'Group'}`
      case 'store':
        return `Inherited from: ${field.sourceName || 'Store'}`
      case 'default':
        return 'System default'
      case 'service':
        return null // No label needed - it's set on this service
    }
  }

  return {
    inheritedConfig,
    group,
    store,
    getSourceLabel,
    DEFAULTS
  }
}
