# ADR-0008: Admin Panel Users Scope Isolation

> **Recorded:** 2026-06-01 00:10
> **Status:** accepted

## Context

The Admin Panel's **Users** screen is designated specifically for operators to manage public consumers (`customer`) when support issues arise, and company-users (`business`) specifically. Managing, displaying, or promoting administrative roles (`admin` or `super_admin`) from the general back-office UI introduces security risks and clutter.

## Decision

We will isolate the administrative scope from the general back-office Users screen:

1. **Query Filtering:** Restrict count and select SurrealDB queries in the `SurrealAdminRepository` to target only `customer` and `business` roles (`WHERE role IN ['customer', 'business']`).
2. **Promotion Lock:** Limit manual user registration and role promotion options to only `Customer` and `Business` roles in both the creation dialog and table PopupMenuButton.

## Consequences

- Administrative accounts (such as `arnarvalur` and `gurkudrengur`) are completely isolated and will not be returned or exposed by this screen.
- Operators cannot accidentally promote a general user to an administrator tier from the back-office interface.
- Administrative accounts must be provisioned or updated directly via backend SurrealDB schemas or secure command-line interfaces.
