# CRM System Specification

## Problem
The current platform manages Bookings and Reservations but lacks a centralized Customer Relationship Management (CRM) system for businesses to track their clients. Bookings duplicate customer information (Name, Email, Phone) rather than linking to a unified customer profile. 

## Acceptance Criteria
- Businesses can view a list of all their unique customers in the Business Portal (`/customers`).
- Clicking on a customer reveals their profile, displaying contact details, internal notes, and a history of their past and upcoming bookings/reservations.
- Customer profiles support tags (e.g., "VIP", "No-Show Risk").
- When a booking is made (via marketplace or admin panel), it correctly links to an existing customer or creates a new entry if one doesn't exist.

## Edge Cases and Constraints
- **Data Privacy (GDPR)**: Customers might request data deletion. The platform must handle anonymization of CRM records while keeping transactional booking receipts intact.
- **Deduplication**: How do we prevent duplicate CRM entries if a customer uses slightly different emails or phones? (E.g. matching logic on Phone or Email).

## Dependencies
- Shared Types (needs a new `CustomerSchema` and additions to `BookingSchema`).
- Mercury Engine (needs updating to handle CRM insertion/linking during the booking process).
