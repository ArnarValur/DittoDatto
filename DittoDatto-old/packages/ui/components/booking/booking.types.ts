/**
 * Booking Panel — Shared Types
 *
 * Single source of truth for all booking-related interfaces.
 * Used by BookingSlideover, StandardBookingFlow, ReservationBookingFlow,
 * and all atomic step components.
 */

export interface ServiceItem {
  id: string
  title: string
  description?: string
  price?: number
  currency?: string
  duration?: number
  coverImage?: string
  bookingMode?: 'standard' | 'tableReservation' | 'ticketSystem'
  availabilityStart?: string
  availabilityEnd?: string
  groupId?: string
}

export interface StaffMember {
  id: string
  displayName: string
  avatarUrl?: string
  title?: string
}

export interface ServiceGroupItem {
  id: string
  name: string
  sortOrder?: number
  showOnBookingPanel?: boolean
  multiSelect?: boolean
}

export interface OpeningDay {
  isOpen: boolean
  open: string
  close: string
}

export interface OpeningSchedule {
  mon?: OpeningDay
  tue?: OpeningDay
  wed?: OpeningDay
  thu?: OpeningDay
  fri?: OpeningDay
  sat?: OpeningDay
  sun?: OpeningDay
}

export interface ReservationConfig {
  maxGuestsPerReservation?: number
  largePartyHandling?: 'email' | 'call' | 'datto' | 'disabled'
  largePartyContact?: string
  slotInterval?: number
}

/**
 * Generic confirm summary row — used by StepConfirmSummary.
 */
export interface ConfirmSummaryRow {
  icon: string
  label: string
  value: string
  /** Optional secondary lines (e.g. multi-service list) */
  secondaryValues?: string[]
}
