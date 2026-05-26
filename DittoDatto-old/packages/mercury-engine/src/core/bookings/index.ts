/**
 * MercuryEngine Core - Appointments Domain
 * 
 * Re-exports all appointment-related business logic.
 * Standard 1:1 booking flow: Search → Hold → Pay → Confirm → Cancel
 */

export { calculateSlots, calculateSlotsFromContext } from './calculator.js'
export { createHold, resolveHoldAllocation } from './hold.js'
export { createBookingFromHold, cancelBooking, buildBookingReceipt, checkCancellationPolicy } from './booking.js'

// Re-export shared utilities that routes may need
export { upsertCustomerFromBooking } from '../shared/customer.js'
export { fetchAvailabilityData } from '../shared/data.js'
export * from '../shared/time.js'

// TODO: Rebook endpoint — atomic cancel-old + hold-new transaction
// export { rebookAppointment } from './rebook.js'

// TODO: Waitlist — check waitlist on cancellation, notify waiting customers
// export { checkWaitlistOnCancel, addToWaitlist } from './waitlist.js'
