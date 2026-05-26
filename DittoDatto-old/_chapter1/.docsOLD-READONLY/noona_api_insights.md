# Noona API Insights: Ideas for MercuryEngine

I've reviewed the Noona API documentation you shared, specifically looking into their HQ and Marketplace schemas for `Events`, `Time Slots`, and `Waitlists`.

Since Noona is a mature scheduling platform, looking at their data models gives us a great cheat sheet for features we might need to support in the future. Here are the most valuable concepts we can learn from and potentially adapt for **MercuryEngine**:

---

## 1. 🚦 The Event Lifecycle & State

Noona tracks the lifecycle of an event much more Granularly than just "pending" or "confirmed".

* **Check-in Tracking:** They store `check_in_at` (timestamp) and `check_in_origin` directly on the Event. For DittoDatto's Table Reservations, this would be highly valuable for the hosts at the door to mark guests as "arrived".
* **Employee Confirmation:** They use an `unconfirmed` boolean for businesses that require staff to manually accept bookings before they are finalized.
* **Penalty Tracking:** They track `outstanding_no_show_fee` directly on the booking. If a user no-shows, a fee is attached to the record, which can block future bookings until paid.

## 2. ⏳ Waitlists & Automated Offers

Noona's Waitlist implementation is excellent and something you should consider putting on the DittoDatto roadmap.

* **Data Model:** A `WaitlistEntry` contains `preferred_times` (array of dates + specific times).
* **Booking Offers:** When a slot frees up, the system generates a `booking_offer` with an `expires_at` timestamp. This offer is texted/emailed to the waitlisted customer. If they don't claim it in time, it expires and is offered to the next person.

## 3. 🔄 Recurring Rules (RRULE)

* **Current DittoDatto:** Every booking or block is a single instance.
* **Noona Approach:** Events and Blocked Times support the `rrule` standard. e.g., `"FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR"`.
* **Takeaway:** If you ever build "recurring blocks" (e.g., "Staff meeting every Tuesday at 14:00"), do not create 52 individual blocks in Firestore. Store one block with an `rrule` string, and let [calculator.ts](file:///media/addinator/Mercury/Projects/DittoDatto/packages/functions/src/MercuryEngine/calculator.ts) parse the rule dynamically when generating slots.

## 4. 🎛️ Time Slot Engine Overrides

Noona's `GET /time_slots` endpoint has some very clever query parameters that bypass strict rules for edge cases:

* `skip_can_perform: boolean` - Returns raw slots without checking if the specific staff/resource is capable of the service. Useful for admin-overrides.
* `override_booking_interval: int` - Forces the time tetris to step by X minutes instead of the store's default (e.g., forcing a 5-minute step interval instead of 15).

## 5. 🏷️ Analytics & Origins

* **Marketing Funnel:** Noona tracks `booking_source` natively, capturing `{ "group": "hq", "channel": "calendar", "funnel": "ads" }`.
* **Integrations:** They have a specific `rwg` (Reserve with Google) object natively on the event to handle Google's strict conversion tracking tokens. As you scale the Public Marketplace, separating "Direct DittoDatto app bookings" vs "Google Maps bookings" will be crucial.

## 6. 🛠️ Resources vs "Space"

* **Architecture Validation:** I noticed Noona has deprecated their `space` property on Events in favor of a unified `resources` array. Your recent decision to unify Tables, Rooms, and Equipment under the generic `Resource` schema is exactly the right path! You avoided the architectural trap they previously fell into.

---

### Recommendations for immediate consideration

1. Add `checkInAt` and `checkInBy` to your [Reservation](file:///media/addinator/Mercury/Projects/DittoDatto/packages/functions/src/MercuryEngine/reservations/booking.ts#13-28) schema. It will be an instant win for the restaurant UI.
2. Consider adding an `unconfirmed` flag if you want to support "Request to Book" flows (which ties into your "Capacity Request Flow" track on your todo list).
