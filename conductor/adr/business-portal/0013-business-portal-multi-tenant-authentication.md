# ADR-0013: Business Portal Multi-Tenant Authentication and Routing

> **Recorded:** 2026-06-08 20:50
> **Status:** accepted
> **Domain:** business-portal

## Context

The Business Portal is reserved exclusively for users with the `business` role (or platform administrative roles). Business users must be isolated to their respective company's tenant database (`company_{slug}`) upon login, preventing any cross-tenant data access.

## Decision

We will implement a direct-to-database WebSocket login sequence that enforces role-based access control (RBAC) and tenant isolation at the session startup level:

1. **Authentication:** Authenticate the user against the `companies` and `users` namespaces using SurrealDB namespace-level credentials, matching the Admin Panel's direct connection architecture.
2. **Role Verification:** Query the global `users/profiles` database to check the user's role. If the role is not `business`, `admin`, or `super_admin`, terminate the connection immediately.
3. **Tenant Routing:** Retrieve the `company_slug` from the user's profile and execute `USE NS companies DB company_{slug};` on the connection. This locks all subsequent query contexts to the company's isolated database.

## Consequences

- Guarantees strict multi-tenant data isolation at the database session level.
- Reuses the Admin Panel's robust, secure WebSocket connection and token persistence infrastructure.
- Simplifies routing and permissions checks inside the client application.
